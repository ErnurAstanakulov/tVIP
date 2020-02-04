//
//  RoleObject.swift
//  DigitalBank
//
//  Created by psuser on 01/04/2019.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation
import ObjectMapper

class RoleObject: Mappable {
    
    var id: Int?
    var code: Constants.Roles?
    
    required init?(map: Map) {
        id <- map["id"]
        code <- map["code"]
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        code <- map["code"]
    }
}
