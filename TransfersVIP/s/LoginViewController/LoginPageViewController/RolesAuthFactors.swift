//
//  RolesAuthFactors.swift
//  DigitalBank
//
//  Created by psuser on 01/04/2019.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation
import ObjectMapper

class RolesAuthFactors: Mappable {
    
    var role: RoleObject?
    var authFactorChain: [Constants.FactorsType]?
    
    required init?(map: Map) {
        role <- map["role"]
        authFactorChain <- map["auth_factor_chain"]
    }
    
    func mapping(map: Map) {
        role <- map["role"]
        authFactorChain <- map["auth_factor_chain"]
    }
}
