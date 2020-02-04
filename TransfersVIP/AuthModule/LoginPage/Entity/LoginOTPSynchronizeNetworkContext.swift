//
//  LoginOTPSynchronizeNetworkContext.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/16/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

class LoginOTPSynchronizeNetworkContext: NetworkContext {
    var route: Route = .apiProcessAuthFactorOtpSync
    var method: NetworkMethod = .post
    var encoding: NetworkEncoding = .json
    var parameters: [String : Any] {
        return [
            "previousToken": previousToken,
            "nextToken": nextToken,
            "companyPersonId": companyPersonId
        ]
    }
    
    var previousToken: String
    var nextToken: String
    var companyPersonId: Int
    
    init (
        previousToken: String,
        nextToken: String,
        companyPersonId: Int
    ) {
        self.previousToken = previousToken
        self.nextToken = nextToken
        self.companyPersonId = companyPersonId
    }
}
