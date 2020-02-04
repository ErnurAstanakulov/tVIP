//
//  CurrencyPageRouter.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/12/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//
import UIKit
class CurrencyPageRouter {
    private(set) weak var view: CurrencyPageViewController?
    private var networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension CurrencyPageRouter: CurrencyPageRouterInput {
    func createModule() -> UIViewController {
        let view = CurrencyPageViewController()
        let presenter = CurrencyPagePresenter(view: view)
        let interactor = CurrencyPageInteractor(presenter: presenter, networkService: networkService)
        
        view.interactor = interactor
        view.router = self
        
        self.view = view
        
        return view
    }
    
    func popModule() {
        view?.navigationController?.popViewController(animated: false)
    }
}
