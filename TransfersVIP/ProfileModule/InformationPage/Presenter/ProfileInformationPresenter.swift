//
//  ProfileInformationPresenter.swift
//  TransfersVIP
//
//  Created by psuser on 10/14/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

protocol ProfileInformationPresenterInput: BasePresenterInputProtocol {
    func setComponents(fields: [FiledComponent<PersonalFields>])
    func uploadProfile(_ viewController: UIViewController)
    func fillLocales(_ locales: Locales)
}

class ProfileInformationPresenter {
    
    private(set) var view: ProfileInformationViewInput
    
    init(view: ProfileInformationViewInput) {
        self.view = view
    }
}

extension ProfileInformationPresenter: ProfileInformationPresenterInput {
    var baseView: BaseViewInputProtocol {
        return view
    }
    
    func setComponents(fields: [FiledComponent<PersonalFields>]) {
        view.setComponents(fields: fields)
    }

    func uploadProfile(_ viewController: UIViewController) {
        view.uploadProfile(viewController)
    }
    
    func fillLocales(_ locales: Locales) {
        view.fillLocales(locales)
    }
}
