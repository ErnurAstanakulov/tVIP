//
//  LoginPagePresenter.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/5/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation

class LoginPagePresenter {
    private(set) unowned var view: LoginViewInput
    
    init(
        view: LoginViewInput
    ) {
        self.view = view
    }
}

extension LoginPagePresenter: LoginPagePresenterInput {
    var baseView: BaseViewInputProtocol {
        return view
    }

    func showPasswordForm() {
        view.showPasswordForm()
    }
    
    func showCustomerNamePicker(_ customerNameList: [String]) {
        view.showCustomerNamePicker(customerNameList)
    }
    
    func showAuthFactorsPicker(_ authFactorsList: [[String]], _ canSkip: Bool) {
        view.showAuthFactorsPicker(authFactorsList, canSkip)
    }
    
    func showOTPForm(_ canSkip: Bool) {
        view.showOTPForm(canSkip)
    }
    
    func showSMSForm(_ canSkip: Bool) {
        view.showSMSForm(canSkip)
    }
    
    func routeToMainMenuTabBar() {
        view.routeToMainMenuTabBar()
    }
    
    func showSynchronizeOTPForm() {
        view.showSynchronizeOTPForm()
    }
}
