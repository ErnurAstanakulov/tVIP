//
//  LoginPageRouter.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/5/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

class LoginPageRouter {
    private weak var viewController: LoginPageViewController?
    private weak var navigaitonController: UINavigationController?
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService, navigationController: UINavigationController?) {
        self.networkService = networkService
        self.navigaitonController = navigationController
    }
}

extension LoginPageRouter: LoginPageRouterInput {
    func createModule() -> UIViewController {
        let view = LoginPageViewController()
        let presenter = LoginPagePresenter(view: view)
        let interactor = LoginPageInteractor(
            presenter: presenter,
            networkService: networkService
        )
        
        view.interactor = interactor
        view.router = self
        
        self.viewController = view
        
        return view
    }
    
    func routeToMainMenuTabBar() {
        let router: TabBarPageRouterInput = TabBarPageRouter(networkService: networkService)
        let viewController = router.createModule()
        navigaitonController?.pushViewController(viewController, animated: true)
    }
    
    func presentSynchronizeOTPForm(complation: @escaping (String?, String?) -> ()) {
        let alertController = UIAlertController(title: "Введите код", message: "", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Первое значение"
            textField.keyboardType = .numberPad
            textField.clearButtonMode = .always
        }
        alertController.addTextField { textField in
            textField.placeholder = "Второе значение"
            textField.keyboardType = .numberPad
            textField.clearButtonMode = .always
        }
        let confirmAction = UIAlertAction(title: "Принять", style: .default) { [weak alertController] _ in
            guard let alertController = alertController
            else {
                complation(nil, nil)
                return
            }
            let previousToken = alertController.textFields?[0].text
            let nextToken = alertController.textFields?[1].text
            complation(previousToken, nextToken)
        }
        alertController.addAction(confirmAction)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        viewController?.present(alertController, animated: true, completion: nil)
    }
}
