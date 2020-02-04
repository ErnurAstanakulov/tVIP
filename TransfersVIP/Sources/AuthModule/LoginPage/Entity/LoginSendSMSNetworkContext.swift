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
