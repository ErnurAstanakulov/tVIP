//
//  ProfileOrganizationRouter.swift
//  TransfersVIP
//
//  Created by psuser on 10/17/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

protocol ProfileOrganizationRouterInput {
    func createModule(page: ProfilePages) -> UIViewController
}

class ProfileOrganizationRouter: ProfileOrganizationRouterInput {
    
    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    
    func createModule(page: ProfilePages) -> UIViewController {
        let view = ProfileOrganizationViewController()
        let presenter: ProfileOrganizationPresenterInput = ProfileOrganizationPresenter(view: view)
        let interactor: ProfileOrganizationInteractorInput = ProfileOrganizationInteractor(networkService: networkService, presenter: presenter)
        
        view.interactor = interactor
        view.router = self
        return view
    }
    
}
