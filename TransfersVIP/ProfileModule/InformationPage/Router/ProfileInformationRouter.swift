//
//  ProfileInformationRouter.swift
//  TransfersVIP
//
//  Created by psuser on 10/14/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

protocol ProfileInformationRouterInput {
    func createModule(page: ProfilePages) -> UIViewController
}

class ProfileInformationRouter {
    
    private var networkService: NetworkService
    private var view: ProfileInformationViewInput!
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
}
extension ProfileInformationRouter: ProfileInformationRouterInput {
    
    func createModule(page: ProfilePages) -> UIViewController {
        let view = ProfileInformationViewController(page: page)
        let presenter: ProfileInformationPresenterInput = ProfileInformationPresenter(view: view)
        let interactor: ProfileInformationInteractorInput = ProfileInformationInteractor(presenter: presenter, networkService: networkService)
        view.interactor = interactor
        view.router = self
        self.view = view
        return view
    }
}
