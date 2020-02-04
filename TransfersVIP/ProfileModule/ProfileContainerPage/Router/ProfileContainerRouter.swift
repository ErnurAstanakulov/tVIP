//
//  ProfileContainerRouter.swift
//  TransfersVIP
//
//  Created by psuser on 10/14/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation
protocol ProfileContainerRouterInput {
    func createModule() -> UIViewController
    func createInformationModule() -> UIViewController
    func createOrganizationModule() -> UIViewController
    func createNotificationModule() -> UIViewController
}

class ProfileContainerRouter {
    
    private var networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
}
extension ProfileContainerRouter: ProfileContainerRouterInput {
    
    func createOrganizationModule() -> UIViewController {
        let router: ProfileOrganizationRouterInput = ProfileOrganizationRouter(networkService: networkService)
        let view = router.createModule(page: .organization)
        return view
    }
    
    func createNotificationModule() -> UIViewController {
        let router: ProfileNotificationRouterInput = ProfileNotificationRouter(networkService: networkService)
        let view = router.createModule(page: .notification)
        return view
    }
    
    func createInformationModule() -> UIViewController {
        let router: ProfileInformationRouterInput = ProfileInformationRouter(networkService: networkService)
        let view = router.createModule(page: .information)
        return view
    }
    
    func createModule() -> UIViewController {
        let view = ProfileContainerViewController()
        let presenter: ProfileContainerPresenterInput = ProfileContainerPresenter(view: view)
        let interactor = ProfileContainerInteractor(presenter: presenter, networkService: networkService)
        view.router = self
        view.interactor = interactor
        return view
    }
}
