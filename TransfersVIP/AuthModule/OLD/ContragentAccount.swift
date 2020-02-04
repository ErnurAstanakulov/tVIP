//
//  ContragentAccount.swift
//  DigitalBank
//
//  Created by iosDeveloper on 6/19/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import ObjectMapper

class ContragentAccount: Account {
    var agentId: Int?
    var agentBankCode: String?
    var agentCity: String?
    var agentAddress: String?
    var agentBankName: String?
    var agentCorrBankAcc: String?
    var agentCountryId: String?
    var agentCountryName: String?
    var agentCountryTwoLetterCode: String?
    
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        agentId <- map["agentId"]
        agentBankCode <- map["agentBankCode"]
        agentCity <- map["agentCity"]
        agentAddress <- map["agentAddress"]
        agentBankName <- map["agentBankName"]
        agentCorrBankAcc <- map["agentCorrBankAcc"]
        agentCountryId <- map["agentCountryId"]
        agentCountryName <- map["agentCountryName"]
        agentCountryTwoLetterCode <- map["agentCountryTwoLetterCode"]
    }
}
