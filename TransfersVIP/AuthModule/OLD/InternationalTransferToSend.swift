//
//  InternationalTransferToSend.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 4/4/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import ObjectMapper

class InternationalTransferToSend: NSObject, Mappable {
//    var documentNumber: String?
    var account: ForeignAccountView?
    var amount: String?
    var senderAddress: String?
    var valueDate: String?
    var purpose: String?
    var purposeCode: String?
    var kvo: String?
    var kvoLabel: String?
    var purposeUserValue: String?
    var priority: Bool?
    var number: String?
    var isTemplate: Bool?
    var templateName: String?
    var director: CompanyPerson? //+
    
    var accountant: CompanyPerson?
    var info: String?
    var transliterate: Bool? = false
    var feeTypeCode: String?
    var feeAccount: FeeAccount?
    var currencyOperationType: String?
    var contractNumber: String?
    var contractDate: String?
    var invoice: String?
    var invoiceDate: String?
    
    var contractAuditNumber: String?
    var contractAuditDate: String?
    var additionalInfo: String?
    var confirmation: Bool? = false
    var benefName: String?
    var benefId: Int?
    var benefTaxCode: String?
    var benefAccount: String?
    var benefBankCode: String?
    var benefResidencyCode: String?
    var benefKpp: String?
    
    var benefCountryCode: String?
    var benefCity: String?
    var benefAddress: String?
    var benefBankCorrAccount: String?
    var benefBankName: String?
    var benefBankCountryCode: String?
    var benefBankCountry: String?
    var benefBankCity: String?
    var benefBankAddress: String?
    var agentCorrAccount: String?
    var agentBankName: String?
    
    var agentBankCode: String?
    var agentBankCountry: String?
    var agentBankCountryCode: String?
    var agentBankCity: String?
    var agentBankAddress: String?

    var isNotNeedUnc: Bool?
    var isNotLinkTerrorism: Bool?
    var isPermitGiveInformation: Bool?
    
    var field_N4: String?
    var field_N5: String?
    var taxIdNumber: String?
    var taxPeriod: String?
    var operationTypeCode: String?
    var basisTaxPayment: String?
    var taxDocumentType: String?
    var taxDocumentDate: String?

    override init() {
        super.init()
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
//        documentNumber <- map["documentnumber"]
        account <- map["account"]
        amount <- map["amount"]
        valueDate <- map["valueDate"]
        purpose <- map["purpose"]
        purposeCode <- map["purposeCode"]
        kvo <- map["kvo"]
        kvoLabel <- map["kvoLabel"]
        purposeUserValue <- map["purposeUserValue"]
        priority <- map["priority"]
        number <- map["number"]
        isTemplate <- map["isTemplate"]
        templateName <- map["templateName"]
        director <- map["director"]
        senderAddress <- map["senderAddress"]
        
        accountant <- map["accountant"]
        info <- map["info"]
        transliterate <- map["transliterate"]
        feeTypeCode <- map["feeTypeCode"]
        feeAccount <- map["feeAccount"]
        currencyOperationType <- map["currencyOperationType"]
        contractNumber <- map["contractNumber"]
        contractDate <- map["contractDate"]
        invoice <- map["invoice"]
        invoiceDate <- map["invoiceDate"]
        
        contractAuditNumber <- map["contractAuditNumber"]
        contractAuditDate <- map["contractAuditDate"]
        additionalInfo <- map["additionalInfo"]
        confirmation <- map["confirmation"]
        benefName <- map["benefName"]
        benefId <- map["benefId"]
        benefTaxCode <- map["benefTaxCode"]
        benefAccount <- map["benefAccount"]
        benefBankCode <- map["benefBankCode"]
        benefResidencyCode <- map["benefResidencyCode"]
        benefKpp <- map["benefKpp"]

        benefCountryCode <- map["benefCountryCode"]
        benefCity <- map["benefCity"]
        benefAddress <- map["benefAddress"]
        benefBankCorrAccount <- map["benefBankCorrAccount"]
        benefBankName <- map["benefBankName"]
        benefBankCountryCode <- map["benefBankCountryCode"]
        benefBankCountry <- map["benefBankCountry"]
        benefBankCity <- map["benefBankCity"]
        benefBankAddress <- map["benefBankAddress"]
        agentCorrAccount <- map["agentCorrAccount"]
        agentBankName <- map["agentBankName"]
        
        agentBankCode <- map["agentBankCode"]
        agentBankCountry <- map["agentBankCountry"]
        agentBankCountryCode <- map["agentBankCountryCode"]
        agentBankCity <- map["agentBankCity"]
        agentBankAddress <- map["agentBankAddress"]
        
        isNotNeedUnc <- map["isNotNeedUnc"]
        isNotLinkTerrorism <- map["isNotLinkTerrorism"]
        isPermitGiveInformation <- map["isPermitGiveInformation"]
        taxDocumentType <- map["taxDocumentType"]
        field_N4 <- map["field_N4"]
        field_N5 <- map["field_N5"]
        taxIdNumber <- map["taxIdNumber"]
        taxPeriod <- map["taxPeriod"]
        operationTypeCode <- map["operationTypeCode"]
        basisTaxPayment <- map["basisTaxPayment"]
        taxDocumentDate <- map["taxDocumentDate"]
    }
}
