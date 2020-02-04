//
//  ProfileNotificationViewController.swift
//  TransfersVIP
//
//  Created by psuser on 10/11/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import UIKit

protocol ProfileNotificationViewInput: BaseViewControllerProtocol {
    func setComponents(_ notifications: [ProfileNotification])
}

class ProfileNotificationViewController: UIViewController, ProfilePagesProtocol {
    
    var page: ProfilePages = .notification
    
    var interactor: ProfileNotificationInteractorInput?
    var router: ProfileNotificationRouterInput?
    private var notifications: [ProfileNotification] = []

    private let tableView = UITableView()
    
    override func loadView() {
        super.loadView()
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.loadNotification()
    }
}
extension ProfileNotificationViewController: ViewInitalizationProtocol {
    func addSubviews() {
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView.addConstaintsToFill()
    }
    
    func stylizeViews() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 65
    }
    
    func extraTasks() {
        tableView.register(NotificationFieldCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.layoutSubviews()
    }
}
extension ProfileNotificationViewController: ProfileNotificationViewInput {
  
    var activityIndicator: UIActivityIndicatorView {
        return .init(style: .gray)
    }
    
    func setComponents(_ notifications: [ProfileNotification]) {
        self.notifications = notifications
        tableView.reloadData()
    }
}
extension ProfileNotificationViewController: EditButtonDelegate {
    func onPressButton(_ sender: UIButton) {
        router?.pushDetail(with: sender.tag)
    }
}
extension ProfileNotificationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let notification = notifications[indexPath.row]
        let cell: NotificationFieldCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.fill(notification)
        cell.setDelegate(self)
        return cell
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 120
    }
}


