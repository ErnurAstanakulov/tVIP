//
//  InternationalTransfersShort.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 3/27/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import ObjectMapper

class InternationalTransfersShort: BaseModel {
    var number: String?
    var templateName: String?
    var isTemplate: Bool?
    var created: String?
    var payerName: String?
    var payerAccount: String?
    var receiverName: String?
    var receiverAccount: String?
    var amount: String?
    var purpose: String?
    var currency: String?
    var state: InternationalTransferState?
    var actions: Actions?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        number <- map["number"]
        templateName <- map["templateName"]
        isTemplate <- map["isTemplate"]
        created <- map["created"]
        payerName <- map["payerName"]
        payerAccount <- map["payerAccount"]
        receiverName <- map["receiverName"]
        receiverAccount <- map["receiverAccount"]
        amount <- map["amount"]
        purpose <- map["purpose"]
        currency <- map["currency"]
        state <- map["state"]
        actions <- map["actions"]
    }
}

class InternationalTransferState: State {
    var externalId: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        externalId <- map["externalId"]
    }
}
