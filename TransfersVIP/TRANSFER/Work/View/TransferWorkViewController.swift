//
//  TransferWorkViewController.swift
//  TransfersVIP
//
//  Created by psuser on 31/08/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import UIKit

class TransferWorkViewController: BaseViewController, PagesDelegate {
    var page: Pages {
        return .work
    }
    var iteractor: TransferWorkIteractorInput!
    var router: TransferWorkRouterInput!
    private let tableView = UITableView()
    
    override func loadView() {
        super.loadView()
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }
    
}

extension TransferWorkViewController: TransferWorkViewControllerInput {
    
    func setWorkDocuments(documents: [String]) {
        
    }
    
}
extension TransferWorkViewController: ViewInitalizationProtocol {
    func addSubviews() {
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView.addConstaintsToFill()
    }
    
    func stylizeViews() {
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset.left = 25
        tableView.separatorInset.right = 25
    }
    
    func extraTasks() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TransferWorkCell.self, forCellReuseIdentifier: "TransferWorkCell")
    }
    
}
extension TransferWorkViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransferWorkCell") as! TransferWorkCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
