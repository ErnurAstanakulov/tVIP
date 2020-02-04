//
//  LoginOAuthModel.swift
//  DigitalBank
//
//  Created by psuser on 02/05/2019.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation

struct LoginOAuthModel {
    
    let url = baseURL + "auth/oauth/token"
    let header: [String: String] = [
        "Authorization": "Basic " + "MOBILE:".toBase64()
    ]
    var token: String?
    var grantType = Constants.AuthentificationType.password.rawValue
    let userType: String = "customer"
    var userName: String?
    var password: String?
    var id: Int?
    var index: Int?
    var sms: String?
    var generator: String?
    var isMultiple = false
    var parameters:[String: Any] {
        get {
            return getCurrentParameters()
        }
    }
    
    mutating func resetParameters() {
        if let accessToken = (sessionManager.adapter as? AppRequestAdapter)?.accessToken {
            self.token = accessToken
        } else {
            self.id = nil
            self.index = nil
            self.token = nil
        }
        sessionManager.adapter?.closeSession()
        self.userName = nil
        self.password = nil
        self.sms = nil
        self.generator = nil
        self.grantType = Constants.AuthentificationType.password.rawValue
    }
    
    private func getCurrentParameters() -> [String: Any] {
        var paramerters = [String: Any]()
        paramerters["user_type"] = userType
        if let username = userName {
            paramerters["username"] = username
        }
        if let password = password {
            paramerters["password"] = password
        }
        if let id = getCustomerByIndex() {
            paramerters["id"] = id
        } else if let id = id {
            paramerters["id"] = id
        }
        paramerters["grant_type"] = grantType
        if let sms = sms {
            paramerters["sms"] = sms
        }
        if let token = token {
            paramerters["token"] = token
        }
        if let generator = generator {
            paramerters["generator"] = generator
        }
        return paramerters
    }
    
    private func getCustomerByIndex() -> Int? {
        if let index = index, let customers = AuthorizationAdapter.shared.customers, customers.count > index,
           let customerId = customers[index].id {
            return customerId
        }
        return nil
    }
    
    internal mutating func setPasswordGrandType() {
        sessionManager.adapter?.closeSession()
        self.grantType = Constants.AuthentificationType.password.rawValue
        self.password = AuthorizationAdapter.shared.encryptedPassword
        self.userName = AuthorizationAdapter.shared.encryptedLogin
        self.id = nil
        self.sms = nil
        self.generator = nil
        self.token = nil
    }
    
    internal mutating func setSMSGrandType() {
        self.grantType = Constants.AuthentificationType.sms.rawValue
        self.password = AuthorizationAdapter.shared.encryptedPassword
        self.userName = AuthorizationAdapter.shared.encryptedLogin
        self.generator = nil
    }
    
    internal mutating func setOTPGrandType() {
        self.grantType = Constants.AuthentificationType.generator.rawValue
        self.password = AuthorizationAdapter.shared.encryptedPassword
        self.userName = AuthorizationAdapter.shared.encryptedLogin
        self.sms = nil
    }
}
