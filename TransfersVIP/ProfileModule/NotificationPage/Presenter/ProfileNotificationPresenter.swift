//
//  ProfileNotificationPresenter.swift
//  TransfersVIP
//
//  Created by psuser on 10/18/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

protocol ProfileNotificationPresenterInput: BasePresenterInputProtocol {
    
    func setComponents(_ notifications: [ProfileNotification])
}

class ProfileNotificationPresenter  {
    
    private let view: ProfileNotificationViewInput
    
    init(view: ProfileNotificationViewInput) {
        self.view = view
    }
}
extension ProfileNotificationPresenter: ProfileNotificationPresenterInput {
    
    var baseView: BaseViewInputProtocol {
        return view
    }
    
    func setComponents(_ notifications: [ProfileNotification]) {
        view.setComponents(notifications)
    }
}
