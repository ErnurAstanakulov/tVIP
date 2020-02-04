//
//  DashboardTransferRouter.swift
//  TransfersVIP
//
//  Created by psuser on 29/08/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import UIKit

class DashboardTransferRouter {
    private var networkService: NetworkService
    private(set) weak var view: DashboardTransferContainerViewController?
    
    init() {
        self.networkService = NetworkAdapter(sessionManager: sessionManager)
    }
}
extension DashboardTransferRouter: DashboardTransferRouterInput {
    func createTransferNewController() -> UIViewController {
        let router: TransferNewRouterInput = TransferNewRouter()
        let view = router.createModule()
        return view
    }
    
    func createTransferWorkController() -> UIViewController {
        let router: TransferWorkRouterInput =  TransferWorkRouter(networkService: networkService)
        let view = router.createModule()
        return view
    }
    
    func createTransferTemplateMenuController() -> UIViewController {
        return TemplateViewController()
    }
    
    func createTransferRegularController() -> UIViewController {
        return RegularViewController()
    }
    
    func createModule() -> UIViewController {
        let view = DashboardTransferContainerViewController()
        let presenter: DashboardTransferPresenterInput = DashboardTransferPresenter(view: view)
        let iteractor = DashboardTransferIteractor(presenter: presenter, networkService: networkService)
        view.router = self
        view.iteractor = iteractor
        self.view = view
        return view
    }
    
}
