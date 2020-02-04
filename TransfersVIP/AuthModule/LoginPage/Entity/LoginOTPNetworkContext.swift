//
//  LoginOTPNetworkContext.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/10/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation

class LoginOTPNetworkContext: NetworkContext {
    var route: Route = .apiOAuthToken
    var method: NetworkMethod = .post
    var encoding: NetworkEncoding = .urlString
    var parameters: [String: Any] {
        var params: [String: Any] = [
            "user_type": "customer",
            "grant_type": "Generator",
            "generator": generator,
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
    
    private let generator: Int
    private let token: String
    private let id: Int?
    
    init(generator: Int, token: String, id: Int? = nil) {
        self.generator = generator
        self.token = token
        self.id = id
    }
}
