//
//  LoginSendSMSNetworkContext.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/17/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation

class LoginSendSMSNetworkContext: NetworkContext {
    var route: Route = .apiRequestSMS
    var method: NetworkMethod = .post
    var encoding: NetworkEncoding = .urlString
    var parameters: [String : Any] {
        return [
            "companyPersonId": id
        ]
    }
    
    private let id: Int
    
    init(id: Int) {
        self.id = id
    }
}

class SingingSMSNetworkContext: NetworkContext {
    var route: Route = .apiSigningSMSRequest
    var method: NetworkMethod = .post
    var encoding: NetworkEncoding = .json
}

class SingingCheckSMSNetworkContext: NetworkContext {
    var route: Route = .apiSigningCheckSMS
    var method: NetworkMethod = .post
    var encoding: NetworkEncoding = .urlString
    
    private let id: Int
    private let code: String
    
    init(code: String, with id: Int) {
        self.id = id
        self.code = code
    }
    
    var parameters: [String : Any] {
        return [
            "code": code,
            "ids": id
        ]
    }
}
class SingingCheckOTPNetworkContext: NetworkContext {
    var route: Route = .apiSigningCheckOTP
    var method: NetworkMethod = .post
    var encoding: NetworkEncoding = .urlString
    
    private let id: Int
    private let code: String
    
    init(code: String, with id: Int) {
        self.id = id
        self.code = code
    }
    
    var parameters: [String : Any] {
        return [
            "code": code,
            "ids": id
        ]
    }
}
