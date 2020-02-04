//
//  LoginPasswordNetworkContext.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/5/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation

class LoginPasswordNetworkContext: NetworkContext {
    var route: Route = .apiOAuthToken
    var method: NetworkMethod = .post
    var encoding: NetworkEncoding = .urlString
    var parameters: [String: Any] {
        var params: [String: Any] = [
            "user_type": "customer",
            "username": username,
            "grant_type": "Password",
            "password": password
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
    
    private let password: String
    private let username: String
    private let id: Int?
    
    init(username: String, password: String, id: Int? = nil) {
        self.username = username
        self.password = password
        self.id = id
    }
}
