//
//  AuthMainPageRouter.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/12/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

class AuthMainPageRouter {
    private weak var view: AuthMainViewController?
    private var networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension AuthMainPageRouter: AuthMainPageRouterInput {
    func createModule() -> UIViewController {
        let view = AuthMainViewController()
        
        let presenter = AuthMainPagePresenter(view: view)
        let interactor = AuthMainPageInteractor(presenter: presenter, networkService: networkService)
        
        view.interactor = interactor
        view.router = self
        
        self.view = view
        return view
    }
    
    func setupLoginPageModule() -> UIViewController {
        let loginPageRouter: LoginPageRouterInput = LoginPageRouter(networkService: networkService, navigationController: view?.navigationController)
        let loginPageViewController = loginPageRouter.createModule()
        return loginPageViewController
    }
    
    func setupMenuPageModule() -> UIViewController {
        let menuPageRouter: MenuPageRouterInput = MenuPageRouter(networkService: networkService)
        let menuPageViewController = menuPageRouter.createModule()
        return UINavigationController(rootViewController: menuPageViewController).viewControllers[0]
    }
}
