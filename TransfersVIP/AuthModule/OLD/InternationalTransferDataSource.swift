//
//  InternationalTransfer.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 3/30/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import ObjectMapper

class InternationalTransferDataSource: NSObject, Mappable {
    var documentNumber: String?
    var foreignAccountViews: [ForeignAccountView]?
    var feeAccounts: [FeeAccount]?
    var currencies: [String]?
    var countries: [Country]?
    var customerView: CustomerView?
    var banksSwifts: [String]?
    var currencyOperationTypes: [СurrencyOperationTypes]?
    var knp: [KNP]?
    var kvo: [KVO]?
    var feeTypes: [FeeType]?
    var paymentPurposes: [String]?
    var companyPersons: [[CompanyPerson]]?
    var counterparties: [ForeignContragent]?
    var KBE: [KBE]?
    var payDays: ValueDates?
    var templates: [DomesticTransferTemplateDescription]?
    var basisTaxPayments: [BasisTaxPayment]?
    var rubCodeOperations: [BasisTaxPayment]?
    var taxDocumentTypes: [BasisTaxPayment]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        templates <- map["TEMPLATES"]
        documentNumber <- map["DOCUMENT_NUMBER"]
        foreignAccountViews <- map["ACCOUNTS"]
        feeAccounts <- map["FEE_ACCOUNTS"]
        currencies <- map["currencies"]
        countries <- map["COUNTRIES"]
        customerView <- map["CUSTOMER"]
        banksSwifts <- map["banksSwifts"]
        currencyOperationTypes <- map["CURRENCY_OPERATION_TYPES"]
        knp <- map["KNP"]
        kvo <- map["KVO"]
        feeTypes <- map["FEE_TYPES"]
        paymentPurposes <- map["PURPOSES"]
        companyPersons <- map["COMPANY_PERSONS"]
        counterparties <- map["COUNTERPARTIES"]
        KBE <- map["KBE"]
        basisTaxPayments <- map["BASIS_TAX_PAYMENTS"]
        rubCodeOperations <- map["TRANSFER_RUB_CODE_OPERATIONS"]
        taxDocumentTypes <- map["TAX_DOCUMENT_TYPES"]
    }
    
    var directors: [CompanyPerson]{
        return companyPersons?.first ?? []
    }
    
    var accountants: [CompanyPerson]{
        return companyPersons?.last ?? []
    }
    
}

class FeeType: Mappable {
    var label: String?
    var code: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        label <- map["label"]
        code <- map["code"]
    }
}

class FeeAccount: BaseModel {
    var number: String?
    var currency: String?
    var balance: Sum?
    var plannedBalance: Sum?
    var status: Status?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        number <- map["number"]
        currency <- map["currency"]
        balance <- map["balance"]
        plannedBalance <- map["plannedBalance"]
        status <- map["status"]
    }
}

class ForeignAccountView: BaseModel {
    var number: String?
    var currency: String?
    var balance: Sum?
    var plannedBalance: Sum?
    var status: Status?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        number <- map["number"]
        currency <- map["currency"]
        balance <- map["balance"]
        plannedBalance <- map["plannedBalance"]
        status <- map["status"]
    }
}

class СurrencyOperationTypes: BaseModel {
    var label: String?
    var code: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        label <- map["label"]
        code <- map["code"]
    }
}

class InternationalCurrencyContract: BaseModel {
    
    var state: State?
    var externalId: String?
    var customerId: Int?
    var customerTaxCode: String?
    var contractNumber: String?
    var contractDate: String?
    var conContractNumber: String?
    var conContractNumberDate: String?
    var contractAmount: Double?
    var contractCurrency: String?
    var endDate: String?
    var counterparty: String?
    var balance: Double?
    var paymentCurrency: String?
    var actions: Actions?
    var alias: String?
    var defaultAlias: String?
    var displayOrder: Int?
    var visible: Bool?
    var customerName: String?
    var dio: Double?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        state <- map["status"]
        externalId <- map["externalId"]
        customerId <- map["customerId"]
        customerTaxCode <- map["customerTaxCode"]
        contractNumber <- map["contractNumber"]
        contractDate <- map["contractDate"]
        conContractNumber <- map["conContractNumber"]
        conContractNumberDate <- map["conContractNumberDate"]
        contractAmount <- map["contractAmount"]
        contractCurrency <- map["contractCurrency"]
        endDate <- map["endDate"]
        counterparty <- map["counterparty"]
        balance <- map["balance"]
        paymentCurrency <- map["paymentCurrency"]
        actions <- map["actions"]
        alias <- map["alias"]
        defaultAlias <- map["defaultAlias"]
        displayOrder <- map["displayOrder"]
        visible <- map["visible"]
        customerName <- map["customerName"]
        dio <- map["dio"]
    }
}

class BasisTaxPayment: BaseModel {
    var category: String?
    var code: String?
    var deleted: Bool?
    var externalId: String?
    var label: String?
    var nameKey: String?
    var nameMap: Translations?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        category <- map["category"]
        code <- map["code"]
        externalId <- map["externalId"]
        label <- map["label"]
        nameKey <- map["nameKey"]
        deleted <- map["deleted"]
        nameMap <- map["nameMap"]
    }
}
class Translations: NSObject, Mappable {
    var en: String?
    var ru: String?
    var kk: String?
    var key: String?
    
    required init?(map: Map) {
        super.init()
    }
    
    func mapping(map: Map) {
        en <- map["en"]
        ru <- map["ru"]
        kk <- map["kk"]
        key <- map["key"]
    }
}
struct Locales: Decodable {
    var en: String?
    var ru: String?
    var kk: String?
    var tr: String?
    var cn: String?
}
