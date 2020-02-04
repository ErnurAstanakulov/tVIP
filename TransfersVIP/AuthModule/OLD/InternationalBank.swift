//
//  InternationalBank.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 3/31/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import ObjectMapper

class InternationalBank: Bank {
    var internationalBankBik: String?
    var internationalBankName: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        internationalBankBik <- map["internationalBankBik"]
        internationalBankName <- map["internationalBankName"]
    }
}
