//
//  LoadProfileNotificationNetworkContext.swift
//  TransfersVIP
//
//  Created by psuser on 10/18/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

struct LoadProfileNotificationNetworkContext: NetworkContext {

    var route: Route { return .apiNotificationsProperties }
    var method: NetworkMethod { return .get }
    
    var parameters: [String : Any] {
        var params: [String: Any] = [:]
        params["sort"] = "id"
        params["order"] = "asc"
        return params
    }
}
