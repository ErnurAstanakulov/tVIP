//
//  MenuPageRouter.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/12/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation
import SafariServices

class MenuPageRouter {
    private weak var view: MenuPageViewController?
    private var networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension MenuPageRouter: MenuPageRouterInput {
    func createModule() -> UIViewController {
        let view = MenuPageViewController()
        let presenter = MenuPagePresenter(view: view)
        let interactor = MenuPageInteractor(presenter: presenter, networkService: networkService)
        
        view.interactor = interactor
        view.router = self
        
        self.view = view
        return view
    }
    
    func pushCurrenciesModule() {
        let currencyPageRouter: CurrencyPageRouterInput = CurrencyPageRouter(networkService: networkService)
        let currencyViewController = currencyPageRouter.createModule()
        view?.navigationController?.pushViewController(currencyViewController, animated: false)
    }
    
    func pushNewslettersModule() {
        let newsletterPageRouter: NewsletterPageRouterInput = NewsletterPageRouter(networkService: networkService)
        let newsletterViewController = newsletterPageRouter.createModule()
        view?.navigationController?.pushViewController(newsletterViewController, animated: false)
    }
    
    func pushBranchesModule() {
    }
    
    func pushSafaryViewController(url: URL) {
        let sfSafariViewController = SFSafariViewController(url: url)
        sfSafariViewController.preferredBarTintColor = AppColor.green.uiColor
        sfSafariViewController.preferredControlTintColor = .white
        view?.present(sfSafariViewController, animated: true, completion: nil)
    }
}
