//
//  AccountTransferTemplatesModel.swift
//  DigitalBank
//
//  Created by Misha Korchak on 10.04.17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import ObjectMapper

class AccountTransfersModel: BaseModel {
    var number: String?
    var created: String?
    var templateName: String?
    var debitAccount: String?
    var creditAccount: String?
    var debitSum: String?
    var creditSum: String?
    var exchangeRate: String?
    var stateLabel: String?
    var actions: [String] = []
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        number <- map["number"]
        created <- map["created"]
        templateName <- map["templateName"]
        debitAccount <- map["debitAccount"]
        creditAccount <- map["creditAccount"]
        debitSum <- map["debitSum"]
        creditSum <- map["creditSum"]
        exchangeRate <- map["exchangeRate"]
    }
}
