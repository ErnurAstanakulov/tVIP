//
//  AccountTransfersToSend.swift
//  DigitalBank
//
//  Created by Misha Korchak on 11.04.17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import ObjectMapper

class AccountTransfersToSend: NSObject, Mappable {
    
    var documentNumber: Int?
    var account: AccountsViews?
    var accountant: CompanyPerson?
    var amount: String?
    var creditAccount: AccountsViews?
    var creditSum: String?
    var director: CompanyPerson?
    var exchangeRate: String?
    var feeAccount: NationalAccountsViews?
    var individualExchangeRate: Bool?
    var fixDebitSum: Bool?
    var isTemplate: Bool?
    var number: String?
    var purpose: String?
    var purposeCode: String?
    var operationTargetId: String?
    var valueDate: String?
    var templateName: String?
    var info: String?
    var priority: Bool?
    var fixedAmount: String?
    var contractId: Int?
    var currencyContracts: [[String: Any]]?
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        documentNumber <- map["documentnumber"]
        account <- map["account"]
        accountant <- map["accountant"]
        amount <- map["amount"]
        creditAccount <- map["creditAccount"]
        creditSum <- map["creditSum"]
        director <- map["director"]
        exchangeRate <- map["exchangeRate"]
        feeAccount <- map["feeAccount"]
        individualExchangeRate <- map["individualExchangeRate"]
        fixDebitSum <- map["fixDebitSum"]
        isTemplate <- map["isTemplate"]
        number <- map["number"]
        purpose <- map["purpose"]
        purposeCode <- map["purposeCode"]
        valueDate <- map["valueDate"]
        templateName <- map["templateName"]
        info <- map["info"]
        priority <- map["priority"]
        operationTargetId <- map["operationTargetId"]
        fixedAmount <- map["fixedAmount"]
        contractId <- map["contractId"]
        currencyContracts <- map["currencyContracts"]
    }
}
