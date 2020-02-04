//
//  PaymentTransferNetworkContext.swift
//  TransfersVIP
//
//  Created by psuser on 25/09/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation
protocol PaymentTransferNetworkContext: NetworkContext {
}
extension PaymentTransferNetworkContext {
    var method: NetworkMethod { return .post }
    var encoding: NetworkEncoding { return .json }
}

enum DocumemtState {
    case draft
    case new
    case template(String)
    
    var parameters: [String: Any] {
        switch self {
        case .draft:
            var jsonParameters: [String: Any] = [:]
            jsonParameters["isTemplate"] = false
            jsonParameters["isRaw"] = true
            return jsonParameters
        case .new:
            var jsonParameters: [String: Any] = [:]
            jsonParameters["isTemplate"] = false
            jsonParameters["isRaw"] = false
            return jsonParameters
        case .template(let templateName):
            var jsonParameters: [String: Any] = [:]
            jsonParameters["templateName"] = templateName
            jsonParameters["isTemplate"] = true
            jsonParameters["isRaw"] = false
            return jsonParameters
        }
    }
}
