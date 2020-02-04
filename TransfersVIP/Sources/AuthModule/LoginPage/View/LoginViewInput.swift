//
//  LoginViewInput.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/5/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

protocol LoginViewInput: BaseViewInputProtocol {
    func showPasswordForm()
    func showCustomerNamePicker(_ customerNameList: [String])
    func showAuthFactorsPicker(_ authFactorsList: [[String]], _ canSkip: Bool)
    func showOTPForm(_ canSkip: Bool)
    func showSMSForm(_ canSkip: Bool)
    func routeToMainMenuTabBar()
    func showSynchronizeOTPForm()
}
