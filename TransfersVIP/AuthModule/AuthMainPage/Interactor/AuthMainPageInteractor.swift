//
//  AuthMainPageInteractor.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/12/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

class AuthMainPageInteractor {
    var presenter: AuthMainPagePresenterInput!
    var networkService: NetworkService!
    
    private var loginViewController: UIViewController?
    private var menuViewController: UIViewController?
    
    init(presenter: AuthMainPagePresenterInput, networkService: NetworkService) {
        self.presenter = presenter
        self.networkService = networkService
    }
}

extension AuthMainPageInteractor: AuthMainPageInteractorInput {
    func viewLoaded() {
        presenter.setupPages()
    }
}
