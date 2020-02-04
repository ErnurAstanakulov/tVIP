//
//  LoadProfileNotificationPropertyNetworkContext.swift
//  TransfersVIP
//
//  Created by psuser on 10/19/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

struct LoadProfileNotificationPropertyNetworkContext: NetworkContext {
    
    var route: Route {
        return property != nil ? .apiNotificationsProperties : .apiNotificationsPropertiesById(id)
    }
    
    var method: NetworkMethod {
        return property != nil ? .put : .get
    }
    
    private let property: NotificationProperty?
    private let id: Int
    
    init(id: Int, _ property: NotificationProperty? = nil) {
        self.property = property
        self.id = id
    }
    
    var encoding: NetworkEncoding {
        return property != nil ? .json : .url
    }
    
    var parameters: [String : Any] {
        if let property = property {
            return property.asDictionary()
        }
        return [:]
    }
}
