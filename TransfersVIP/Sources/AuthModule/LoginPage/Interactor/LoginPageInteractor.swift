//
//  LoginPageInteractor.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/5/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit
import SwiftyRSA

class LoginPageInteractor {
    private let presenter: LoginPagePresenterInput
    private let networkService: NetworkService
    
    private var lastAccessToken: String?
    private var customerList: [Customer]?
    private var changedAuthFactors: [Constants.FactorsType]?
    private var availableAuthFactorsList: [[Constants.FactorsType]]?
    private var canSkip: Bool?
    
    private var companyPersonId: Int?
    private var encryptedUsername: String?
    private var encryptedPassword: String?
    
    init(
        presenter: LoginPagePresenterInput,
        networkService: NetworkService
    ) {
        self.presenter = presenter
        self.networkService = networkService
    }
    
    private func clean() {
        lastAccessToken = nil
        customerList = nil
        changedAuthFactors = nil
        availableAuthFactorsList = nil
        canSkip = nil
        companyPersonId = nil
        encryptedUsername = nil
        encryptedPassword = nil
    }
}

extension LoginPageInteractor: LoginPageInteractorInput {
    func viewLoaded() {
        presenter.showPasswordForm()
    }
    
    func signInWith(username: String, password: String) {
        signIn(username: username, password: password)
    }
    
    func onChangeCustomer(at index: Int) {
        guard let changedCompanyPersonId = customerList?[index].id,
            let encryptedUsername = encryptedUsername,
            let encryptedPassword = encryptedPassword
        else {
                presenter.showError(message: contentErrorMessage)
                return
        }
        self.companyPersonId = changedCompanyPersonId
        performPasswordAuthFactors(encryptedUsername, encryptedPassword, changedCompanyPersonId)
    }
    
    func onChangeAuthFactors(at index: Int) {
        guard let availableAuthFactors = self.availableAuthFactorsList else {
            presenter.showError(message: contentErrorMessage)
            return
        }
        
        self.changedAuthFactors = availableAuthFactors[index]
        
        guard let firstAuthFactor = self.changedAuthFactors?.first else {
            presenter.showError(message: contentErrorMessage)
            return
        }
        
        switch firstAuthFactor {
        case .Generator:
            presenter.showOTPForm(canSkip!)
            break
        case .SMS:
            onChangeSMSAuthFactor(canSkip!)
            break
        default:
            presenter.showError(message: "Auth factor not available!")
        }
    }
    
    func onPassOTP(_ token: String) {
        guard let companyPersonId = companyPersonId,
            let generator = Int(token),
            let accessToken = lastAccessToken
        else {
            presenter.showError(error: LocalError.unknown)
            return
        }
        performOTPAuthFactors(generator, accessToken, companyPersonId)
    }
    
    func onPassSMS(_ code: String) {
        guard let token = lastAccessToken,
            let companyPersonId = companyPersonId,
            let code = Int(code)
            else {
                presenter.showError(error: LocalError.unknown)
                return
        }
        performSMSAuthFactors(code, token, companyPersonId)
    }
    
    func synchronizeOTP() {
        presenter.showSynchronizeOTPForm()
    }
    
    func onPassSynchronizeOTP(previousToken: String, nextToken: String) {
        guard let companyPersonId = companyPersonId else {
            presenter.showError(error: LocalError.unknown)
            return
        }
        synchronizeOTP(previousToken: previousToken, nextToken: nextToken, companyId: companyPersonId)
    }
    
    func onPressBackButton(){
        clean()
        presenter.showPasswordForm()
    }
    
    func onSkip() {
        guard canSkip != nil, canSkip! == true else {
            presenter.showError(message: "Вы не можете пропустить этот шаг")
            return
        }
        presenter.routeToMainMenuTabBar()
    }
    
    func onPressChangeLanguage() {
        presenter.showError(message: "Другие языки пока не доступны.")
    }
}

extension LoginPageInteractor {
    private func signIn(username: String, password: String) {
        requestPublicKey(callback: { [weak self] (publicKey) in
            guard let self = self else {
                return
            }
            
            guard let encryptedUsername = RSAManager.encrypt(string: username, using: publicKey),
                let encryptedPassword = RSAManager.encrypt(string: password, using: publicKey)
                else {
                    self.presenter.showError(message: contentErrorMessage)
                    return
            }
            
            self.encryptedUsername = encryptedUsername
            self.encryptedPassword = encryptedPassword
            
            self.requestCustomers(encryptedUsername: encryptedUsername, encryptedPassword: encryptedPassword) { [unowned self] (oAuthCustomers) in
                self.customerList = oAuthCustomers.customerList
                
                guard let customerNameList = self.customerList?.compactMap({ $0.name }), !customerNameList.isEmpty else {
                    self.presenter.showError(message: contentErrorMessage)
                    return
                }
                
                if customerNameList.count == 1 {
                    self.onChangeCustomer(at: 0)
                } else {
                    self.presenter.showCustomerNamePicker(customerNameList)
                }
            }
        })
    }
    
    private func requestPublicKey(callback: @escaping (_ publicKey: PublicKey) -> ()) {
        presenter.startLoading()
        RSAManager.requestPublicKey { [weak self] (publicKey) in
            guard let self = self else {
                return
            }
            self.presenter.stopLoading()
            guard let publicKey = publicKey else {
                self.presenter.showError(message: contentErrorMessage)
                return
            }
            callback(publicKey)
        }
    }
    
    private func requestCustomers(encryptedUsername: String, encryptedPassword: String, callback: @escaping (_ oAuthData: OAuthCustomers) -> ()) {
        let context = LoginPasswordNetworkContext(username: encryptedUsername, password: encryptedPassword)
        
        presenter.startLoading()
        networkService.load(context: context) { [weak self] (networkResponse) in
            guard let self = self else {
                return
            }
            self.presenter.stopLoading()
            
            guard networkResponse.isSuccess else {
                self.presenter.showError(error: networkResponse.networkError ?? .unknown)
                return
            }
            
            guard let oAuthCustomers: OAuthCustomers = networkResponse.decode() else {
                self.presenter.showError(error: NetworkError.dataLoad)
                return
            }
            
            callback(oAuthCustomers)
        }
    }
    
    private func performPasswordAuthFactors(_ encryptedUsername: String, _ encryptedPassword: String, _ companyPersonId: Int) {
        let context = LoginPasswordNetworkContext(username: encryptedUsername, password: encryptedPassword, id: companyPersonId)
        performAuthFactors(context)
    }
    
    private func performOTPAuthFactors(_ generator: Int, _ accessToken: String, _ companyPersonId: Int) {
        let context = LoginOTPNetworkContext(generator: generator, token: accessToken, id: companyPersonId)
        performAuthFactors(context)
    }
    
    private func performSMSAuthFactors(_ code: Int, _ token: String, _ companyPersonId: Int) {
        let context = LoginSMSNetworkContext(code: code, token: token, id: companyPersonId)
        performAuthFactors(context)
    }
    
    private func performAuthFactors(_ loginNetworkContext: NetworkContext) {
        presenter.startLoading()
        networkService.load(context: loginNetworkContext) { [weak self] (networkResponse) in
            guard let self = self else {
                return
            }
            self.presenter.stopLoading()
            
            guard networkResponse.isSuccess else {
                self.presenter.showError(error: networkResponse.networkError ?? .unknown)
                return
            }
            
            guard let oAuthFactors: OAuthFactors = networkResponse.decode() else {
                self.presenter.showError(message: contentErrorMessage)
                return
            }
            
            guard let oAuthToken: OAuthToken = networkResponse.decode() else {
                self.presenter.showError(message: contentErrorMessage)
                return
            }
            self.save(oAuthToken: oAuthToken)
            
            if (oAuthFactors.possibleChainList.count > 0) {
                let authFactorsList = self.convertToAuthFactors(oAuthFactors.possibleChainList)
                let lastAuthFactorList = self.convertToFactorsTypeList(oAuthFactors.passedAuthFactorList)
                let availableAuthFactorsList = self.excludeLastFrom(authFactorsList: authFactorsList, lastAuthFactorList)
                let availableAuthFactorTitlesList = self.extractAuthFactorsTitles(availableAuthFactorsList)
                
                self.canSkip = oAuthFactors.canSkip
                self.availableAuthFactorsList = availableAuthFactorsList
                self.presenter.showAuthFactorsPicker(availableAuthFactorTitlesList, oAuthFactors.canSkip)
                return
            }
            
            self.fetchUserData { [unowned self] in
                self.presenter.routeToMainMenuTabBar()
            }
        }
    }
    
    private func fetchUserData(complation: @escaping () -> ()) {
        presenter.startLoading()
        UserDataLoader.loadUserInfo { [weak self] (success, errorMessage) in
            guard let self = self else {
                return
            }
            self.presenter.stopLoading()
            
            guard success == true else {
                self.presenter.showError(message: errorMessage ?? NetworkError.unknown.description)
                return
            }
            complation()
        }
    }
    ю
    private func save(oAuthToken: OAuthToken) {
        if let adapter = sessionManager.adapter as? AppRequestAdapter {
            self.lastAccessToken = oAuthToken.accessToken
            adapter.accessToken = oAuthToken.accessToken
            adapter.refreshToken = oAuthToken.refreshToken
            adapter.encryptedUsername = self.encryptedUsername
        }
    }
}

extension LoginPageInteractor {
    private func convertToAuthFactors(_ valuesList: [[String]]) -> [[Constants.FactorsType]] {
        return valuesList.map({ (rawValueList) -> [Constants.FactorsType] in
            convertToFactorsTypeList(rawValueList)
        })
    }
    
    private func convertToFactorsTypeList(_ rawValueList: [String]) -> [Constants.FactorsType] {
        return rawValueList.compactMap { (rawValue) -> Constants.FactorsType? in
            Constants.FactorsType(rawValue: rawValue) ?? nil
        }
    }
    
    private func excludeLastFrom(authFactorsList: [[Constants.FactorsType]], _ lastAuthFactorList: [Constants.FactorsType]) -> [[Constants.FactorsType]] {
        let lastAuthFactor = lastAuthFactorList.last
        return authFactorsList.map { authFactors -> [Constants.FactorsType] in
            authFactors.filter { authFactor in
                authFactor != lastAuthFactor
            }
        }
    }
    
    private func extractAuthFactorsTitles(_ values: [[Constants.FactorsType]]) -> [[String]] {
        return values.map({ (authFactors) -> [String] in
            authFactors.map({ (authFactor) -> String in
                authFactor.localized
            })
        })
    }
    
    private func synchronizeOTP(previousToken: String, nextToken: String, companyId: Int) {
        let context = LoginOTPSynchronizeNetworkContext(previousToken: previousToken, nextToken: nextToken, companyPersonId: companyId)
        presenter.startLoading()
        networkService.load(context: context) { [weak self] (networkResponse) in
            guard let self = self else {
                return
            }
            self.presenter.stopLoading()
            
            guard networkResponse.isSuccess else {
                self.presenter.showError(error: networkResponse.networkError ?? .unknown)
                return
            }
            
            self.presenter.showSuccess(message: "ОТП успешно синхронизирован.")
        }
    }
    
    private func onChangeSMSAuthFactor(_ canSkip: Bool) {
        guard let id = companyPersonId else {
            presenter.showError(error: LocalError.unknown)
            return
        }
        
        let context = LoginSendSMSNetworkContext(id: id)
        presenter.startLoading()
        networkService.load(context: context) { [weak self] (networkResponse) in
            guard let self = self else {
                return
            }
            self.presenter.stopLoading()
            
            guard networkResponse.isSuccess else {
                self.presenter.showError(error: networkResponse.networkError ?? .unknown)
                return
            }
            
            self.presenter.showSMSForm(canSkip)
        }
    }
}
