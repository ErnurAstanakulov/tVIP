//
//  LoginPageInteractorInput.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/5/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

protocol LoginPageInteractorInput: BaseInteractorInputProtocol {
    func signInWith(username: String, password: String)
    func onChangeCustomer(at index: Int)
    func onChangeAuthFactors(at index: Int)
    func onPassOTP(_ token: String)
    func onPassSMS(_ code: String)
    func synchronizeOTP()
    func onPassSynchronizeOTP(previousToken: String, nextToken: String)
    func onPressBackButton()
    func onSkip()
    func onPressChangeLanguage()
}
protocol SingFormInteractorInput {
    func onPassOTP(_ token: String)
    func onPassSMS(_ code: String)
        func synchronizeOTP()
}
