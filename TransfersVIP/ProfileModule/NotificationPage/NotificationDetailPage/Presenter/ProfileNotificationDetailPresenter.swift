//
//  ProfileNotificationDetailPresenter.swift
//  TransfersVIP
//
//  Created by psuser on 10/19/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation
protocol ProfileNotificationDetailPresenterInput: BasePresenterInputProtocol {
    func setupComponents(_ components: [HeaderComponent<Int, Constants.NotificationSettingsType>])
    func showController(with items: [NotificationItem], by items: Constants.NotificationSettingsType)
    func routeBack()
}
class ProfileNotificationDetailPresenter {
    
    private let view: ProfileNotificationDetailViewInput
    
    init(view: ProfileNotificationDetailViewInput) {
        self.view =  view
    }
}
extension ProfileNotificationDetailPresenter: ProfileNotificationDetailPresenterInput {
    var baseView: BaseViewInputProtocol {
        return view
    }
    
    func setupComponents(_ components: [HeaderComponent<Int, Constants.NotificationSettingsType>]) {
        view.setupComponents(components)
    }
    
    func showController(with items: [NotificationItem], by type: Constants.NotificationSettingsType) {
        view.showController(with: items, by: type)
    }
    
    func routeBack() {
        view.routeBack()
    }

}
