//
//  LoadPresonalAuthPersonNetworkContext.swift
//  TransfersVIP
//
//  Created by psuser on 10/17/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

struct LoadPersonalAuthNetworkContext: NetworkContext {
    
    var route: Route {
        return .apiPersonalByAuthPerson
    }
    
    var method: NetworkMethod { return .get }
    
    var parameters: [String : Any] {
        var params: [String: Any] = [:]
        params["sort"] = "id"
        params["order"] = "asc"
        return params
    }
}
