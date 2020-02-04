//
//  AccountTransfersDataSource.swift
//  DigitalBank
//
//  Created by Misha Korchak on 11.04.17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import ObjectMapper

class AccountTransfersDataSource: NSObject, Mappable {
    
    var documentNumber: String?
    var feeAccounts: [NationalAccountsViews]?
    var foreignAccountViews: [ForeignAccountView]?
    var accountsViews: [AccountsViews]?
    var customerView: CustomerView?
    var purposes: [String]?
    var companyPersons: [[CompanyPerson]]?
    var knp: [KNP]?
    var valueDates: ValueDates?
    var operationTargets: [OperationTarget]?
    var templates: [DomesticTransferTemplateDescription]?
    var currencyContracts: [ForeignExchangeContract]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        templates <- map["TEMPLATES"]
        valueDates <- map["PAYMENT_DATES"]
        documentNumber <- map["DOCUMENT_NUMBER"]
        foreignAccountViews <- map["ACCOUNTS"]
        feeAccounts <- map["FEE_ACCOUNTS"]
        accountsViews <- map["ACCOUNTS"]
        customerView <- map["CUSTOMER"]
        purposes <- map["PURPOSES"]
        companyPersons <- map["COMPANY_PERSONS"]
        knp <- map["KNP"]
        operationTargets <- map["OPERATION_TARGET"]
        currencyContracts <- map["CURRENCY_CONTRACTS"]
    }
    
    var directors: [CompanyPerson]{
        return companyPersons?.first ?? []
    }
    
    var accountants: [CompanyPerson]{
        return companyPersons?.last ?? []
    }
}

class OperationTarget: BaseModel {
    var code: String?
    var name: String?
    var deleted: Bool?
    var contractType: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        code <- map["code"]
        name <- map["name"]
        deleted <- map["deleted"]
        contractType <- map["contractType"]
    }
}

class NationalAccountsViews: BaseModel {
    var number: String?
    var currency: String?
    var balance: Sum?
    var plannedBalance: Sum?
    var alias: String?
    var status: Status?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        alias <- map["alias"]
        number <- map["number"]
        currency <- map["currency"]
        balance <- map["balance"]
        plannedBalance <- map["plannedBalance"]
        status <- map["status"]
    }
}

class AccountsViews: BaseModel {
    var number: String?
    var currency: String?
    var balance: Sum?
    var plannedBalance: Sum?
    var alias: String?
    var status: Status?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        number <- map["number"]
        currency <- map["currency"]
        balance <- map["balance"]
        plannedBalance <- map["plannedBalance"]
        alias <- map["alias"]
        status <- map["status"]
    }
}

class EmptyAccountView: AccountsViews {
    
    override required init() {
        super.init()
        id = nil
        number = nil
        plannedBalance = nil
        currency = ""
        plannedBalance = nil
    }
    
    required init?(map: Map) {
        fatalError("init(map:) has not been implemented")
    }
}
