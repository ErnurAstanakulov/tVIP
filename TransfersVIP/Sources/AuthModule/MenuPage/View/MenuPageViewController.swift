//
//  MenuViewController.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/12/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

//TODO: Rename to MenuViewController after delete old
class MenuPageViewController: BaseViewController {
    var interactor: MenuPageInteractorInput?
    var router: MenuPageRouterInput?

    private var menuHeaderView = MenuHeaderView()
    private var tableView = UITableView()
    
    private var menuItemList = [MenuPageItem]()
    
    override func loadView() {
        super.loadView()
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.setupMenuItemList()
    }
}

extension MenuPageViewController: MenuViewInput {
    func show(menuItemList: [MenuPageItem]) {
        self.menuItemList = menuItemList
        tableView.reloadData()
    }
    
    func routeToCurrenciesModule() {
        router?.pushCurrenciesModule()
    }
    
    func routeToNewslettersModule() {
        router?.pushNewslettersModule()
    }
    
    func routeToBranchesModule() {
        showSuccess(message: "Недоступно")
    }
    
    func show(url: URL) {
        router?.pushSafaryViewController(url: url)
    }
}

extension MenuPageViewController: ViewInitalizationProtocol {
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
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -tabBarHeight)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    func stylizeViews() {
        view.backgroundColor = .clear
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        menuHeaderView.set(title: "Меню")
        menuHeaderView.setBackButton(isHidden: true)
        
        tableView.backgroundColor = .clear
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
        tableView.separatorColor = AppColor.lineColor.uiColor
    }
    
    func extraTasks() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MenuTableViewCell.self)
    }
}

extension MenuPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MenuTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        
        let menuItem = menuItemList[indexPath.row]
        cell.icon = menuItem.icon.uiImage
        cell.title = menuItem.title
        
        return cell
    }
}

extension MenuPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let menuItem = menuItemList[indexPath.row]
        interactor?.didSelectItemWith(type: menuItem.type)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
