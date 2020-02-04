//
//  TabBarPageRouter.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/19/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation
import UIKit

class TabBarPageRouter {
    private(set) weak var view: TabBarViewController?
    private var networkService: NetworkService
    private var navigationController: UINavigationController?
    
    init(networkService: NetworkService,
         navigationController: UINavigationController?) {
        self.networkService = networkService
        self.navigationController = navigationController
    }
}

extension TabBarPageRouter: TabBarPageRouterInput {
    func createMainPageController() -> UINavigationController {
    
        return UINavigationController(rootViewController: UIViewController())
    }
    
    func createTransferController() -> UINavigationController {
        let router: DashboardTransferRouterInput = DashboardTransferRouter(networkService: networkService)
        let view = router.createModule()
        return UINavigationController(rootViewController: view)
    }
    
    func createMenuController() -> UINavigationController {
        let router: ProfileContainerRouterInput = ProfileContainerRouter(networkService: networkService)
        let view = router.createModule()
        return UINavigationController(rootViewController: view)
    }
    
    func createDemandController() -> UINavigationController {
        return UINavigationController(rootViewController: UIViewController())
    }
    
    func createModule() -> UIViewController {
        let view = TabBarViewController()
        let presenter = TabBarPagePresenter(view: view)
        let interactor = TabBarPageInteractor(presenter: presenter, networkService: networkService)
        
        view.interactor = interactor
        view.router = self
        
        self.view = view
        return view
    }
}
