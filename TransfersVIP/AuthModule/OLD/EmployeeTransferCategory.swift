//
//  EmployeeTransferCategory.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 3/14/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import ObjectMapper

class EmployeeTransferCategory: BaseModel {
    var label: String?
    var code: String?

    override func mapping(map: Map) {
        super.mapping(map: map)
        
        label <- map["label"]
        code <- map["code"]
    }
}
