//
//  CurrencyPageViewController.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/12/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

class CurrencyPageViewController: BaseViewController {
    var interactor: CurrencyPageInteractorInput?
    var router: CurrencyPageRouterInput?
    
    private var menuHeaderView = MenuHeaderView()
    
    private var currencyHeaderView = UIView()
    
    private var headerStackView = UIStackView()
    private var isoCodeTitleLabel = UILabel()
    private var ratePurchaseTitleLabel = UILabel()
    private var rateSaleTitleLabel = UILabel()
    private var rateNationalTitleLabel = UILabel()
    
    private var refreshControl = UIRefreshControl()
    private var tableView = UITableView()
    
    private var currencyItemList = [CurrencyItem]()
    
    override func loadView() {
        super.loadView()
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactor?.loadCurrencyList()
    }
    
    private func set(currencyItemList: [CurrencyItem]) {
        self.currencyItemList = currencyItemList
        tableView.reloadData()
    }
    
    @objc private func onRefresh(_ tableView: UITableView) {
        interactor?.onRefresh()
    }
}

extension CurrencyPageViewController: CurrencyViewInput {
    func show(currencyItemList: [CurrencyItem]) {
        set(currencyItemList: currencyItemList)
    }
    
    func clearList() {
        set(currencyItemList: [])
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
    }
}

extension CurrencyPageViewController: ViewInitalizationProtocol {
    func addSubviews() {
        view.addSubview(menuHeaderView)
        view.addSubview(tableView)
        
        currencyHeaderView.addSubview(headerStackView)
        headerStackView.addArrangedSubview(isoCodeTitleLabel)
        headerStackView.addArrangedSubview(ratePurchaseTitleLabel)
        headerStackView.addArrangedSubview(rateSaleTitleLabel)
        headerStackView.addArrangedSubview(rateNationalTitleLabel)
        
        tableView.tableHeaderView = currencyHeaderView
        tableView.tableFooterView = UIView()
    }
    
    func setupConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        headerStackView.addConstaintsToVertical()
        headerStackView.addConstaintsToHorizontal(padding: 8)
        
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
        
        currencyHeaderView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60)
        currencyHeaderView.backgroundColor = AppColor.green.uiColor.withAlphaComponent(0.1)
        
        headerStackView.alignment = .center
        headerStackView.distribution = .fillEqually
        
        isoCodeTitleLabel.text = "Валюта"
        ratePurchaseTitleLabel.text = "Покупка"
        rateSaleTitleLabel.text = "Продажа"
        rateNationalTitleLabel.text = "НБРК"
        
        stylize(label: isoCodeTitleLabel)
        stylize(label: ratePurchaseTitleLabel)
        stylize(label: rateSaleTitleLabel)
        stylize(label: rateNationalTitleLabel)
        
        menuHeaderView.set(title: "Курсы валют")
        menuHeaderView.setBackButton(isHidden: false)
        
        tableView.backgroundColor = .clear
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
        tableView.separatorColor = AppColor.lineColor.uiColor
    }
    
    private func stylize(label: UILabel) {
        label.textColor = AppColor.gray.uiColor
        label.font = AppFont.semibold.with(size: 14)
        label.textAlignment = .center
    }
    
    func extraTasks() {
        menuHeaderView.delegate = self
        
        tableView.refreshControl = refreshControl
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CurrencyTableViewCell.self)
        
        refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
    }
}

extension CurrencyPageViewController: MenuHeaderDelegate {
    func onPressBackButton() {
        router?.popModule()
    }
}

extension CurrencyPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CurrencyTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        
        let currencyItem = currencyItemList[indexPath.row]
        cell.set(currencyItem: currencyItem)
        
        return cell
    }
}

extension CurrencyPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
