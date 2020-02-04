//
//  MenuPageInteractor.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/12/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation

class MenuPageInteractor {
    private(set) var presenter: MenuPagePresenterInput
    private var networkService: NetworkService
    
    private var menuItems = [MenuPageItem]()
    
    init(presenter: MenuPagePresenterInput, networkService: NetworkService) {
        self.presenter = presenter
        self.networkService = networkService
    }
}

extension MenuPageInteractor: MenuPageInteractorInput {
    func setupMenuItemList() {
        menuItems = [
            MenuPageItem(type: .currencies, icon: .dollar, title: "Курсы валют"),
            MenuPageItem(type: .newsletters, icon: .newspaper, title: "Новости"),
            MenuPageItem(type: .branches, icon: .position, title: "Отделения и банкоматы"),
            MenuPageItem(type: .opportunities, icon: .opportunity, title: "Возможности"),
            MenuPageItem(type: .aboutBank, icon: .information, title: "О банке")
        ]
        
        presenter.show(menuItemList: menuItems)
    }
    
    func didSelectItemWith(type: MenuPageItemType) {
        switch type {
        case .currencies:
            presenter.routeToCurrenciesModule()
        case .newsletters:
            presenter.routeToNewslettersModule()
        case .branches:
            presenter.routeToBranchesModule()
        case .opportunities:
            presenter.show(url: URL(string: "https://www.sberbank.kz/ru/individuals"))
        case .aboutBank:
            presenter.show(url: URL(string: "https://www.sberbank.kz/ru/about/category/informaciya-o-banke"))
        }
    }
}
