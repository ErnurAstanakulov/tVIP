//
//  ProfileNotificationRouter.swift
//  TransfersVIP
//
//  Created by psuser on 10/18/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation
protocol ProfileNotificationRouterInput {
    func createModule(page: ProfilePages) -> UIViewController
    func pushDetail(with id: Int)
}

class ProfileNotificationRouter {
    private let networkService: NetworkService
    private var view = UIViewController()
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension ProfileNotificationRouter: ProfileNotificationRouterInput {
    
    func createModule(page: ProfilePages) -> UIViewController {
        let view = ProfileNotificationViewController()
        let presenter: ProfileNotificationPresenterInput = ProfileNotificationPresenter(view: view)
        let interactor: ProfileNotificationInteractorInput = ProfileNotificationInteractor(presenter: presenter, networkService: networkService)
        view.router = self
        view.interactor = interactor
        self.view = view
        return view
    }
    
    func pushDetail(with id: Int) {
        let router = ProfileNotificationDetailRouter(networkService: networkService)
        view.navigationController?.pushViewController(router.createModule(channelId: id), animated: true)
    }
}
