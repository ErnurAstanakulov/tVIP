//
//  MenuPagePresenter.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/12/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation

class MenuPagePresenter {
    
    private(set) unowned var view: MenuViewInput
    
    init(view: MenuViewInput) {
        self.view = view
    }
}

extension MenuPagePresenter: MenuPagePresenterInput {
    var baseView: BaseViewInputProtocol {
        return view
    }
    
    func show(menuItemList: [MenuPageItem]) {
        view.show(menuItemList: menuItemList)
    }
    
    func routeToCurrenciesModule() {
        view.routeToCurrenciesModule()
    }
    
    func routeToNewslettersModule() {
        view.routeToNewslettersModule()
    }
    
    func routeToBranchesModule() {
        view.routeToBranchesModule()
    }
    
    func show(url: URL?) {
        guard let url = url else {
            showError(error: LocalError.unknown)
            return
        }
        view.show(url: url)
    }
}
