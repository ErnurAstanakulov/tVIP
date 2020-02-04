//
//  ValidateRedBalanceNetworkContext.swift
//  TransfersVIP
//
//  Created by psuser on 23/09/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

class ValidateRedBalanceNetworkContext: NetworkContext {
    var route: Route { return .apiCustomerDocumentsValidateRedBalance}
    var method: NetworkMethod { return .get }
    let parameters: [String : Any]
    var encoding: NetworkEncoding { return .urlString }
    
    init(amount: String, with accountId: Int) {
        parameters = [
            "amount": amount,
            "accountId": accountId
        ]
    }
}






