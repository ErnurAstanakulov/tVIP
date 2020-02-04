//
//  LoadProfileNetworkContext.swift
//  TransfersVIP
//
//  Created by psuser on 10/14/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

struct LoadProfileNetworkContext: NetworkContext {
    var route: Route = .apiPersonal
    
    var method: NetworkMethod = .get
}
