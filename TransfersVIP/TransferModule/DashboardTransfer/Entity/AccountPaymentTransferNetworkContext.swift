//
//  AccountPaymentTransferNetworkContext.swift
//  TransfersVIP
//
//  Created by psuser on 25/09/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

class AccountPaymentTransferNetworkContext: PaymentTransferNetworkContext {
    var route: Route { return .apiPaymentAccountTransfer}
    let parameters: [String : Any]
    
    init(parameters: [String : Any]) {
        self.parameters = parameters
    }
}
