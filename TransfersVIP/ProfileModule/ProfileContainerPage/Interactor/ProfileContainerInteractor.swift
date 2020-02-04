//
//  ProfileContainerInteractor.swift
//  TransfersVIP
//
//  Created by psuser on 10/14/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import UIKit
protocol ProfileContainerInteractorInput: BaseInteractorInputProtocol {
    func setProfilePages()
}

class ProfileContainerInteractor {
    
    private let presenter: ProfileContainerPresenterInput
    private let networkService: NetworkService

    init(presenter: ProfileContainerPresenterInput, networkService: NetworkService) {
        self.presenter = presenter
        self.networkService = networkService
    }
}
extension ProfileContainerInteractor: ProfileContainerInteractorInput {
    func setProfilePages() {
        presenter.setProfilePages([.information, .organization, .notification])
    }
}
