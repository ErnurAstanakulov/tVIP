//
//  ProfileNotificationDetailRouter.swift
//  TransfersVIP
//
//  Created by psuser on 10/19/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

protocol ProfileNotificationDetailRouterInput {
    func createModule(channelId: Int) -> UIViewController
    func popModule()
}

class ProfileNotificationDetailRouter: ProfileNotificationDetailRouterInput {
    
    private let networkService: NetworkService
    private(set) weak var view: ProfileNotificationDetailViewController?

    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func createModule(channelId: Int) -> UIViewController {
        let view = ProfileNotificationDetailViewController()
        let presenter: ProfileNotificationDetailPresenterInput = ProfileNotificationDetailPresenter(view: view)
        let interactor: ProfileNotificationDetailInteractorInput = ProfileNotificationDetailInteractor(channelId: channelId, networkService: networkService, presenter: presenter)
        view.router = self
        view.interactor = interactor
        self.view = view
        return view
    }
    
    func popModule() {
        view?.navigationController?.popViewController(animated: true)
    }
}
