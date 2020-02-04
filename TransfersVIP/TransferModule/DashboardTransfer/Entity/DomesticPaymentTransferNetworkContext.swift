//
//  DomesticPaymentTransferNetworkContext.swift
//  TransfersVIP
//
//  Created by psuser on 25/09/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

class DomesticPaymentTransferNetworkContext: PaymentTransferNetworkContext {
    var route: Route { return .apiPaymentDomesticTransfer}
    let parameters: [String : Any]
    
    init(parameters: [String : Any], state: DocumemtState) {
        self.parameters = parameters.merged(with: state.parameters)
    }
}
