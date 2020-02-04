//
//  Contract.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 3/31/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import ObjectMapper

class Contract: NSObject, Mappable {
    var id: Int?
    var deleted: Bool?
    var contractId: Int?
    var contractNumber: String?
    var contractDate: String?
    var accountingContractNumber: String?
    var accountingContractDate: String?
    var currency: String?
    var amount: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        contractId <- map["contractId"]
        deleted <- map["deleted"]
        contractNumber <- map["contractNumber"]
        contractDate <- map["contractDate"]
        accountingContractNumber <- map["accountingContractNumber"]
        accountingContractDate <- map["accountingContractDate"]
        currency <- map["currency"]
        amount <- map["amount"]
    }
}

