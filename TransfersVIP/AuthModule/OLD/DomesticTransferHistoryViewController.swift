//
//  DomesticTransferHistoryControllerViewController.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 3/20/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import UIKit
import Alamofire

class DocumetnHistoryViewController: LoadDataViewController {
    public var documentID: Int! {
        didSet {
            if let id = documentID, self.isViewLoaded {
                self.loadHistory(id: id)
            }
        }
    }
    
    var rootView: DocumetnHistoryView { return self.getView()! }
    private let historyURL = baseURL + "api/document-history"
    private let statesURL = baseURL + "api/codes/by/DocumentState"
    fileprivate var events: [DocumentHistory] = []
    fileprivate var states: [DocumentHistoryState] = []

    fileprivate var isEventsLoaded: Bool = false
    fileprivate var isStatesLoaded: Bool = true // now don't need load states (translations already in model)
    
    var stateRequest: DataRequest? = nil {
        willSet(newRequest) {
            stateRequest?.cancel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialTableViewConfig()
        self.configurateNavigationBar()
        if !isStatesLoaded {
            self.loadDocumentStates()
        }
    }
    
    //MARK: Overriden
    
    public override func menuAction() {
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    public override func returnAction() {
        let button = UIBarButtonItem(title: "Назад", style: .done, target: self, action: #selector(returnAction(_:)))
        self.navigationItem.rightBarButtonItem = button
    }
    
    @objc func returnAction(_ sender: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    public override func startLoading() {
        self.rootView.isLoadingViewVisible = true
    }
    
    public override func finishLoading() {
        if isEventsLoaded && isStatesLoaded {
            self.rootView.isLoadingViewVisible = false
            
            for event in events {
                
                if let fromState = states.first(where: { $0.code == event.fromState }) {
                    event.fromStateLabel = fromState.label
                }
                
                if let toState = states.first(where: { $0.code == event.toState }) {
                    event.toStateLabel = toState.label
                }
            }
            
            self.rootView.tableView.reloadData()
        }
    }
    
    private func configurateNavigationBar() {
        self.rootView.navigationBar.bringSubviewToFront(self.rootView)
        self.rootView.navigationBar.backButtonAction = { [unowned self] _ in
            self.navigationController?.popViewController(animated: true)
        }
        self.rootView.bringSubviewToFront(self.rootView.navigationBar)
    }
    
    //MARK: Private
    
    private func loadHistory(id: Int) {
        let parameters: [String : Any] = ["documentId": id,
                                          "page": pageToLoad,
                                          "size": 100,
                                          "sort": "action_time",
                                          "order": "desc"]
        self.loadFromServer(url: historyURL, method: .get, parameters: parameters, encoding: URLEncoding.queryString) { (responce) in
            guard let rows = responce as? [String: Any] else { return }
            guard let jsons = rows["rows"] as? [[String: Any]] else { return }
            jsons.forEach({ (json) in
                DocumentHistory(JSON: json).map({ self.events.append($0) })
            })
            self.isEventsLoaded = true
        }
    }
    
    private func loadDocumentStates() {
        self.startLoading()
        let request = sessionManager.request(statesURL)
        let validateRequest = request.validate()
        self.stateRequest = validateRequest
        validateRequest.responseJSON { [weak self] (serverResponse) in
            guard let vc = self else { return }
            guard let responce = serverResponse.result.value else {
                vc.errorHandling(serverResponse.result.error)
                return
            }
            guard let jsons = responce as? [[String: Any]] else { return }
            jsons.forEach({ (json) in
                DocumentHistoryState(JSON: json).map({ vc.states.append($0) })
            })
            vc.isStatesLoaded = true
            vc.finishLoading()
        }
    }
    
    private func initialTableViewConfig() {
        guard let tebleView = self.rootView.tableView else { return }
        tebleView.backgroundColor = .clear
        tebleView.estimatedRowHeight = 86
        tebleView.rowHeight = UITableView.automaticDimension
        tebleView.registerCell(withClass: DocumentHistoryCell.self)
    }
    
    deinit {
        request?.cancel()
        stateRequest?.cancel()
    }
}

extension DocumetnHistoryViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.events.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 6
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(cls: DocumentHistoryCell.self, indexPath: indexPath)
        let event = events[indexPath.section]
        cell.fillFromEvent(event)
        
        return cell
    }
}
