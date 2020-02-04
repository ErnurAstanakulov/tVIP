//
//  NewsletterDetailViewController.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/15/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

class NewsletterDetailViewController: BaseViewController {
    var interactor: NewsletterDetailPageInteractorInput?
    var router: NewsletterDetailPageRouterInput?

    private var menuHeaderView = MenuHeaderView()
    private var tableView = UITableView()
    
    private var newsletterItem = NewsletterItem()
    
    override func loadView() {
        super.loadView()
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.setupNewsletterItem()
    }
}

extension NewsletterDetailViewController: NewsletterDetailViewInput {
    func show(newsletterItem: NewsletterItem) {
        self.newsletterItem = newsletterItem
        tableView.reloadData()
    }
}

extension NewsletterDetailViewController: ViewInitalizationProtocol {
    func addSubviews() {
        view.addSubview(menuHeaderView)
        view.addSubview(tableView)
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
        menuHeaderView.delegate = self
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
    }
    
    func extraTasks() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsletterDetailHeaderTableViewCell.self)
        tableView.register(NewsletterDetailBodyTableViewCell.self)
    }
}

extension NewsletterDetailViewController: MenuHeaderDelegate {
    func onPressBackButton() {
        navigationController?.popViewController(animated: false)
    }
}

extension NewsletterDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell: NewsletterDetailHeaderTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.set(newsletterItem: newsletterItem)
            return cell
        } else {
            let cell: NewsletterDetailBodyTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.set(newsletterItem: newsletterItem)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    private func getHeaderCellAt(indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
