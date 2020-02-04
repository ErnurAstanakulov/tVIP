//
//  ContragentFull.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 2/13/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import ObjectMapper

class ForeignContragent: NSObject, Mappable {
    var counterparty: Contragent?
    var accounts: [ContragentAccount]?
    var contracts: [Contract]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        counterparty <- map["counterparty"]
        accounts <- map["accounts"]
        contracts <- map["contracts"]
    }
}
