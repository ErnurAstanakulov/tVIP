//
//  InternationalTransferDocument.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 4/3/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import ObjectMapper

class InternationalTransfer: BaseModel {
    var externalId: String?
    var customerId: Int?
    var custName: String?
    var customerTaxCode: String?
    var custResidencyCode: String?
    var valueDate: String?
    var documentDate: String?
    var created: String?
    var number: String?
    var state: String?
    var type: String?
    var director: CompanyPerson?
    var accountant: CompanyPerson?
    var bankResponse: String?
    var manager: String?
    var info: String?
    var isTemplate: Bool?
    var templateName: String?
    var account: ForeignAccountView?
    var custBankCode: String?
    var amount: Double?
    var senderAddress: String?
    var purpose: String?
    var purposeCode: String?
    var purposeCodeLabel: String?
    var kvo: String?
    var kvoLabel: String?
    var purposeUserValue: String?
    var priority: Bool?
    var benefName: String?
    var benefTaxCode: String?
    var benefAccount: String?
    var benefBankCode: String?
    var benefResidencyCode: String?
    var actions: Actions?
    var custIntlName: String?
    var transliterate: Bool?
    var feeTypeCode: String?
    var feeAccount: FeeAccount?
    var currencyOperationType: String?
    var currencyOperationTypeLabel: String?
    var contractNumber: String?
    var contractDate: String?
    var invoice: String?
    var invoiceDate: String?
    var contractAuditNumber: String?
    var contractAuditDate: String?
    var additionalInfo: String?
    var confirmation: Bool?
    var benefKpp: String?
    var benefCountryCode: String?
    var benefCountry: String?
    var benefCity: String?
    var benefAddress: String?
    var benefBankCorrAccount: String?
    var benefBankName: String?
    var benefBankCountry: String?
    var benefBankCountryCode: String?
    var benefBankCity: String?
    var benefBankAddress: String?
    var agentCorrAccount: String?
    var agentBankName: String?
    var agentBankCode: String?
    var agentBankCountry: String?
    var agentBankCountryCode: String?
    var agentBankCity: String?
    var agentBankAddress: String?
    var fileAttributes: [ServerFormFile]?
    
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
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        customerId <- map["customerId"]
        custName <- map["custName"]
        customerTaxCode <- map["customerTaxCode"]
        custResidencyCode <- map["custResidencyCode"]
        created <- map["created"]
        number <- map["number"]
        state <- map["state"]
        type <- map["type"]
        director <- map["director"]
        accountant <- map["accountant"]
        bankResponse <- map["bankResponse"]
        manager <- map["manager"]
        info <- map["info"]
        isTemplate <- map["isTemplate"]
        templateName <- map["templateName"]
        account <- map["account"]
        custBankCode <- map["custBankCode"]
        amount <- map["amount"]
        senderAddress <- map["senderAddress"]
        valueDate <- map["valueDate"]
        documentDate <- map["documentdate"]
        purpose <- map["purpose"]
        purposeCode <- map["purposeCode"]
        purposeCodeLabel <- map["purposeCodeLabel"]
        kvo <- map["kvo"]
        kvoLabel <- map["kvoLabel"]
        purposeUserValue <- map["purposeUserValue"]
        priority <- map["priority"]
        benefName <- map["benefName"]
        benefTaxCode <- map["benefTaxCode"]
        benefAccount <- map["benefAccount"]
        benefBankCode <- map["benefBankCode"]
        benefResidencyCode <- map["benefResidencyCode"]
        actions <- map["actions"]
        custIntlName <- map["custIntlName"]
        transliterate <- map["transliterate"]
        feeTypeCode <- map["feeTypeCode"]
        feeAccount <- map["feeAccount"]
        currencyOperationType <- map["currencyOperationType"]
        currencyOperationTypeLabel <- map["currencyOperationTypeLabel"]
        contractNumber <- map["contractNumber"]
        contractDate <- map["contractDate"]
        invoice <- map["invoice"]
        invoiceDate <- map["invoiceDate"]
        contractAuditNumber <- map["contractAuditNumber"]
        contractAuditDate <- map["contractAuditDate"]
        additionalInfo <- map["additionalInfo"]
        confirmation <- map["confirmation"]
        benefKpp <- map["benefKpp"]
        benefCountryCode <- map["benefCountryCode"]
        benefCountry <- map["benefCountry"]
        benefCity <- map["benefCity"]
        benefAddress <- map["benefAddress"]
        benefBankCorrAccount <- map["benefBankCorrAccount"]
        benefBankName <- map["benefBankName"]
        benefBankCountry <- map["benefBankCountry"]
        benefBankCountryCode <- map["benefBankCountryCode"]
        benefBankCity <- map["benefBankCity"]
        benefBankAddress <- map["benefBankAddress"]
        agentCorrAccount <- map["agentCorrAccount"]
        agentBankName <- map["agentBankName"]
        agentBankCode <- map["agentBankCode"]
        agentBankCountry <- map["agentBankCountry"]
        agentBankCountryCode <- map["agentBankCountryCode"]
        agentBankCity <- map["agentBankCity"]
        agentBankAddress <- map["agentBankAddress"]
        fileAttributes <- map["fileAttributes"]
        
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
    
    // doesnt work
    var creationDate: String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: self.created!)
        return date?.stringWith(format: "yyyy-MM-dd")
    }
}
