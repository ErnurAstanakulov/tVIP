//
//  AuthMainPagePresenter.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/12/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

class AuthMainPagePresenter {
    private(set) unowned var view: AuthMainViewInput
    
    init(view: AuthMainViewInput) {
        self.view = view
    }
}

extension AuthMainPagePresenter: AuthMainPagePresenterInput {
    var baseView: BaseViewInputProtocol {
        return view
    }
    
    func setupPages() {
        view.setupPages()
    }
}
