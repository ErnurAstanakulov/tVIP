//
//  LoginCompaniesViewController.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/15/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

protocol LoginCompaniesDelegate: class {
    func onChangeCompanyItem(at indexPath: IndexPath)
}

class LoginCompaniesViewController: BaseViewController {
    
    weak var delegate: LoginCompaniesDelegate?
    
    private(set) var loginHeaderView = LoginHeaderView()
    private var tableView = UITableView()
    
    var customerNameList = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func loadView() {
        super.loadView()
        setupViews()
    }
}

extension LoginCompaniesViewController: ViewInitalizationProtocol {
    func addSubviews() {
        view.addSubview(tableView)
        
        tableView.tableHeaderView = loginHeaderView
        tableView.tableFooterView = UIView()
    }
    
    func setupConstraints() {
        loginHeaderView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: LoginHeaderView.VIEW_HEIGHT)
        
        tableView.addConstaintsToHorizontal()
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: statusBarHeight).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -tabBarHeight).isActive = true
    }
    
    func stylizeViews() {
        view.backgroundColor = .clear
    
        loginHeaderView.tabBar.languageTitle = "Русский"
        loginHeaderView.tabBar.backButtonVisible = true
        
        tableView.bounces = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }
    
    func extraTasks() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LoginCompanyTableViewCell.self)
    }
}

extension LoginCompaniesViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customerNameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LoginCompanyTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        
        let companyName = customerNameList[indexPath.row]
        cell.set(companyName: companyName)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.onChangeCompanyItem(at: indexPath)
    }
}
