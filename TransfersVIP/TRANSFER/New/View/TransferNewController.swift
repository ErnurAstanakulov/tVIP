//
//  TransferStaticPaymentViewController.swift
//  TransfersVIP
//
//  Created by psuser on 29/08/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import UIKit

class TransferNewController: BaseViewController {
    
    var iteractor: TransferNewIteractorInput!
    var router: TransferNewRouterInput!
    
    private let tableView = UITableView()
    private var models = [TransferNew]()
    
    override func loadView() {
        super.loadView()
        setupViews()
        iteractor.setTitles()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension TransferNewController: PagesDelegate {
    var page: Pages {
        return .new
    }
}
extension TransferNewController: TransferNewControllerInput {
    func setNewTransferTitles(titles: [TransferNew]) {
        self.models = titles
        self.tableView.reloadData()
    }
    
}

extension TransferNewController: ViewInitalizationProtocol {
    func addSubviews() {
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView.addConstaintsToFill()
    }
    
    func stylizeViews() {
        tableView.estimatedRowHeight = 58.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
        
    }
    
    func extraTasks() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TransferNewCell.self, forCellReuseIdentifier: "TransferNewCell")
    }
}

extension TransferNewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        print(self.navigationController?.navigationBar.frame.width)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension TransferNewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransferNewCell") as! TransferNewCell
        let model = models[indexPath.row]
        cell.fill(model)
        return cell
    }
}
