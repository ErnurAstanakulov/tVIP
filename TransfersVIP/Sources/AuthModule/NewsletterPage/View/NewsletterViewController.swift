//
//  NewsletterViewController.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/14/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

class NewsletterViewController: BaseViewController {
    var interactor: NewsletterPageInteractorInput?
    var router: NewsletterPageRouterInput?
    
    private var menuHeaderView = MenuHeaderView()
    private var tableView = UITableView()
    
    private var refreshControl = UIRefreshControl()
    
    private var newsletterItemList = [NewsletterItem]()
    
    override func loadView() {
        super.loadView()
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.loadNewsletterList()
    }
    
    @objc private func onRefresh() {
        interactor?.onRefresh()
    }
}

extension NewsletterViewController: NewsletterViewInput {
    func set(newsletterItemList: [NewsletterItem]) {
        self.newsletterItemList = newsletterItemList
        tableView.reloadData()
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
    }
}

extension NewsletterViewController: ViewInitalizationProtocol {
    func addSubviews() {
        view.addSubview(menuHeaderView)
        view.addSubview(tableView)
        
        tableView.tableFooterView = UIView()
    }
    
    func setupConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        menuHeaderView.addConstaintsToHorizontal()
        layoutConstraints += [
            menuHeaderView.topAnchor.constraint(equalTo: view.topAnchor, constant: UIApplication.shared.statusBarFrame.height),
            menuHeaderView.heightAnchor.constraint(equalToConstant: 60)
        ]
        
        tableView.addConstaintsToHorizontal()
        layoutConstraints += [
            tableView.topAnchor.constraint(equalTo: menuHeaderView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    func stylizeViews() {
        menuHeaderView.set(title: "Новости")
        menuHeaderView.setBackButton(isHidden: false)
        
        tableView.backgroundColor = .clear
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
        tableView.separatorColor = AppColor.lineColor.uiColor
    }
    
    func extraTasks() {
        menuHeaderView.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        tableView.register(NewsletterTableViewCell.self)
        
        refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
    }
}

extension NewsletterViewController: MenuHeaderDelegate {
    func onPressBackButton() {
        navigationController?.popViewController(animated: false)
    }
}

extension NewsletterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsletterItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NewsletterTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        
        let newsletterItem = newsletterItemList[indexPath.row]
        cell.set(newsletterItem: newsletterItem)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let newsletterItem = newsletterItemList[indexPath.row]
        router?.routeToNewsletterDetailPage(newsletterItem: newsletterItem)
    }
}
