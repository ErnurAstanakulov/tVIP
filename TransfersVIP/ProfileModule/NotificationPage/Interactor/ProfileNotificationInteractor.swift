//
//  ProfileNotificationInteractor.swift
//  TransfersVIP
//
//  Created by psuser on 10/18/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

protocol ProfileNotificationInteractorInput {
    func loadNotification()
}

class ProfileNotificationInteractor {
    private let networkService: NetworkService
    private let presenter: ProfileNotificationPresenterInput
    
    init(presenter: ProfileNotificationPresenterInput, networkService: NetworkService) {
        self.presenter = presenter
        self.networkService = networkService
    }
    
    private func load(completion: @escaping ([ProfileNotification]) -> ()) {
        let networkContext = LoadProfileNotificationNetworkContext()
        presenter.startLoading()
        networkService.load(context: networkContext) { [weak self] response in
            guard let interactor = self else { return }
            interactor.presenter.stopLoading()
            guard response.isSuccess else {
                interactor.presenter.showError(error: response.networkError ?? .unknown)
                return
            }
            
            guard let notification: PageableResponse<ProfileNotification>  = response.decode()
                else {
                    interactor.presenter.showError(error: NetworkError.dataLoad)
                    return
            }
            completion(notification.rows)
        }
    }
}

extension ProfileNotificationInteractor: ProfileNotificationInteractorInput {
    func loadNotification() {
        load { [weak self] (notifications) in
            guard let interactor = self else { return }
            interactor.presenter.setComponents(notifications)
        }
    }
}

