//
//  ExposedOrderPaymentTransferNetworkContext.swift
//  TransfersVIP
//
//  Created by psuser on 25/09/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

class ExposedOrderPaymentTransferNetworkContext: PaymentTransferNetworkContext {
    var route: Route { return .apiExposedOrder}
    let parameters: [String : Any]
    
    init(parameters: [String : Any], state: DocumemtState) {
        self.parameters = parameters.merged(with: state.parameters)
    }
}

