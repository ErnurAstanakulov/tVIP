//
//  LoadPersonalUpdateNetworkContext.swift
//  TransfersVIP
//
//  Created by psuser on 10/15/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

struct LoadPersonalUpdateNetworkContext: NetworkContext {
    var method: NetworkMethod = .put
    var encoding: NetworkEncoding = .json
    var route: Route = .apiPersonalUpdate
    private let password: String
    private let email: String
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    var parameters: [String : Any] {
        var params: [String : Any] = [:]
        params["password"] = password
        params["email"] = email
        return params
    }
}
