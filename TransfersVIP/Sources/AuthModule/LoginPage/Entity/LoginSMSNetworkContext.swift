//
//  LoginSMSNetworkContext.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/10/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation

class LoginSMSNetworkContext: NetworkContext {
    var route: Route = .apiOAuthToken
    var method: NetworkMethod = .post
    var encoding: NetworkEncoding = .urlString
    var parameters: [String: Any] {
        var params: [String: Any] = [
            "grant_type": "SMS",
            "user_type": "customer",
            "sms": code,
            "token": token
        ]
        if id != nil {
            params["id"] = id!
        }
        return params
    }
    var header: [String : String] {
        return [
            "Authorization": "Basic " + "MOBILE:".toBase64()
        ]
    }
    
    private let code: Int
    private let token: String
    private let id: Int?
    
    init(code: Int, token: String, id: Int? = nil) {
        self.code = code
        self.token = token
        self.id = id
    }
}
