//
//  LoadDataViewController.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 1/24/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift

class LoadDataViewController: UIViewController {
    
    //DESC: By default return action
    var rightAction: UIBarButtonItem?
    
    var pageToLoad = 0 
    var totalRows = 0
    var isDataSourceLoaded = false
    
    let searchText = PublishSubject<String>()
    let bag = DisposeBag()
    
    //MARK: Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    var request: DataRequest? = nil {
        willSet(newRequest) {
            request?.cancel()
        }
    }
    
    //MARK: overridden methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuAction()
        self.returnAction()
        self.setupSearchText()
    }
    
    deinit {
        self.request?.cancel()
    }
    
    func setupSearchText() {
        
        
    }
    
    //MARK: Public methods
    
    //Dont call this method directly, it intended for reloadin in child classes
    public func startLoading() {
    }
    
    //Dont call this method directly, it intended for reloadin in child classes
    public func finishLoading() {
    }
    
    //Override this method with searching logic, it's going to be called everytime `searchText` changes
    public func search(with text: String) {
    }
    
    //Dont call this method directly, it intended for reloadin in child classes
    public func errorHandling(_ error: Error?) {
        if let error = error {
            let allert = UIAlertController.presentSimpleError(title: "Ошибка", message: error.localizedDescription)
            self.present(allert, animated: true, completion: nil)
        }
    }
    
    //Signature of closure to handle server responce
    typealias JSONHandler = (_ json: Any) -> ()
    public func loadFromServer(url: URLConvertible, method: HTTPMethod = .get, parameters: [String: Any]? = nil, encoding: ParameterEncoding = URLEncoding.default, handler: @escaping JSONHandler) {
        self.startLoading()
        self.request = sessionManager.request(url, method: method, parameters: parameters, encoding: encoding, headers: nil)
            .validate().responseJSON { [weak self] (serverResponce) in
            log(serverResponse: serverResponce)
            guard let vc = self, let json = serverResponce.result.value else {
                if let error = serverResponce.result.error as NSError?, error.code != -999 {
                    self?.errorHandling(serverResponce.result.error)
                }
                return
            }
            handler(json)
            guard let result = json as? [String : Any] else { return }
            vc.pageToLoad += 1
            guard let rows = result["total"] as? [String : Any],
                let count = rows["count"] as? Int else {
                vc.finishLoading()
                return
            }
            vc.totalRows = count
            vc.finishLoading()
        }
    }
    
    //DESC: Default menu action implementation
    public func menuAction() {
//        let button = UIBarButtonItem(title: "Меню", style: .done, target: self, action: #selector(showMenu(_:)))
//        //self.navigationItem.leftBarButtonItem = button
//        self.navigationItem.rightBarButtonItem = button
    }

    @objc func showMenu(_ sender: UIBarButtonItem) {
        
    }
    
    public func returnAction() {
        
//        let rightAction = UIBarButtonItem(title: "Назад", style: .done, target: self, action: nil)
//        self.rightAction = rightAction
//        self.navigationItem.rightBarButtonItem = rightAction
    }
    
    //DESC: You can call this method in child classes (e.g. viewDidLoad()) to add some tap gesture recognither to rootView
    public func activeTapGestureOnView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(_ :)))
        self.view.addGestureRecognizer(gesture)
    }
    
    //DESC: Default action - endEditing for rottView and all it's subviews, you can reload this method in child classes
    @objc func tapGestureAction(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}
