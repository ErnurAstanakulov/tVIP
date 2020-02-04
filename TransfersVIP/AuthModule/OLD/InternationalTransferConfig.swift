//
//  InternationalTransferConfig.swift
//  DigitalBank
//
//  Created by Vlad on 17.08.17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import ObjectMapper

class InternationalTransferConfig: Mappable {
    var constraints: InternationalTransferConstraints?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        constraints <- map["constraints"]
    }
}

class InternationalTransferConstraints: Mappable {
    var director: BaseConstraint?
    var amount: BaseConstraint?
    var valueDate: BaseConstraint?
    var purpose: BaseConstraint?
    var purposeCode: BaseConstraint?
    var accountCurrency: BaseConstraint?
    var account: BaseConstraint?
    var benefName: BaseConstraint?
    var benefResidencyCode: BaseConstraint?
    var benefAccount: BaseConstraint?
    var benefBankCode: BaseConstraint?
    var benefCountryCode: BaseConstraint?
    var benefCity: BaseConstraint?
    var benefAddress: BaseConstraint?
    var benefBankCorrAccount: BaseConstraint?
    var benefBankCity: BaseConstraint?
    var benefBankAddress: BaseConstraint?
    var agentBankCode: BaseConstraint?
    var agentCorrAccount: BaseConstraint?
    var agentBankCity: BaseConstraint?
    var agentBankAddress: BaseConstraint?
    var number: BaseConstraint?
    var contractNumber: BaseConstraint?
    var contractAuditNumber: BaseConstraint?
    var invoice: BaseConstraint?
    var feeTypeCode: BaseConstraint?
    var feeAccount: BaseConstraint?
    var info: BaseConstraint?
    var additionalInfo: BaseConstraint?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        director <- map["director"]
        amount <- map["amount"]
        valueDate <- map["valueDate"]
        purpose <- map["purpose"]
        purposeCode <- map["purposeCode"]
        accountCurrency <- map["accountCurrency"]
        account <- map["account"]
        benefName <- map["benefName"]
        benefResidencyCode <- map["benefResidencyCode"]
        benefAccount <- map["benefAccount"]
        benefBankCode <- map["benefBankCode"]
        benefCountryCode <- map["benefCountryCode"]
        benefCity <- map["benefCity"]
        benefAddress <- map["benefAddress"]
        benefBankCorrAccount <- map["benefBankCorrAccount"]
        benefBankCity <- map["benefBankCity"]
        benefBankAddress <- map["benefBankAddress"]
        agentBankCode <- map["agentBankCode"]
        agentCorrAccount <- map["agentCorrAccount"]
        agentBankCity <- map["agentBankCity"]
        agentBankAddress <- map["agentBankAddress"]
        number <- map["number"]
        contractNumber <- map["contractNumber"]
        contractAuditNumber <- map["contractAuditNumber"]
        invoice <- map["invoice"]
        feeTypeCode <- map["feeTypeCode"]
        feeAccount <- map["feeAccount"]
        info <- map["info"]
        additionalInfo <- map["additionalInfo"]
    }
}
