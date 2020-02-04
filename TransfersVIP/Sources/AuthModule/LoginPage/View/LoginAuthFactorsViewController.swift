//
//  LoginAuthFactorsViewController.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/10/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

protocol LoginAuthFactorsDelegate: class, LoginPageSkipable {
    func onChangeAuthFactorsItem(at indexPath: IndexPath, _ viewController: LoginAuthFactorsViewController)
}

class LoginAuthFactorsViewController: BaseViewController {
    
    weak var delegate: LoginAuthFactorsDelegate?
    
    private(set) var loginHeaderView = LoginHeaderView()
    private var footerView = UIView()
    private var skipButton = UIButton()
    
    private var tableView = UITableView()
    
    var authFactorsList = [[String]]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func loadView() {
        super.loadView()
        setupViews()
    }
    
    @objc private func onPressSkipButton() {
        delegate?.onPressSkip(self)
    }
}

extension LoginAuthFactorsViewController {
    var canSkip: Bool {
        get {
            return !skipButton.isHidden
        }
        set {
            skipButton.isHidden = !newValue
        }
    }
}

extension LoginAuthFactorsViewController: ViewInitalizationProtocol {
    func addSubviews() {
        view.addSubview(tableView)
        footerView.addSubview(skipButton)
        
        tableView.tableHeaderView = loginHeaderView
        tableView.tableFooterView = footerView
    }
    
    func setupConstraints() {
        loginHeaderView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: LoginHeaderView.VIEW_HEIGHT)
        footerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100)
        
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.heightAnchor.constraint(equalToConstant: 16).isActive = true
        skipButton.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
        skipButton.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 10).isActive = true
        
        tableView.addConstaintsToHorizontal()
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: statusBarHeight).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -tabBarHeight).isActive = true
    }
    
    func stylizeViews() {
        view.backgroundColor = .clear
        
        loginHeaderView.tabBar.languageTitle = "Русский"
        loginHeaderView.tabBar.backButtonVisible = true
        
        skipButton.setTitle("Пропустить", for: .normal)
        skipButton.setTitleColor(.gray, for: .normal)
        skipButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        
        tableView.bounces = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }
    
    func extraTasks() {
        skipButton.addTarget(self, action: #selector(onPressSkipButton), for: .touchUpInside)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LoginAuthFactorsTableViewCell.self)
    }
}

extension LoginAuthFactorsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return authFactorsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LoginAuthFactorsTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        
        let authFactors = authFactorsList[indexPath.row]
        cell.set(authFactors: authFactors)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.onChangeAuthFactorsItem(at: indexPath, self)
    }
}
