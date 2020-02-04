//
//  ProfileOrganizationPresenter.swift
//  TransfersVIP
//
//  Created by psuser on 10/17/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ProfileOrganizationPresenterInput {
    func setOrganizations(_ organizations: Observable<[Organization]>)
}

class ProfileOrganizationPresenter: ProfileOrganizationPresenterInput {
    
    private let view: ProfileOrganizationViewInput
    
    init(view: ProfileOrganizationViewInput) {
        self.view = view
    }
    
    func setOrganizations(_ organizations: Observable<[Organization]>)
    {
        view.setOrganizations(organizations)
    }
}
