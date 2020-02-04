//
//  ForeignExchangeContract.swift
//  DigitalBank
//
//  Created by Zhalgas Baibatyr on 28/09/2018.
//  Copyright © 2018 iosDeveloper. All rights reserved.
//

import ObjectMapper

class ForeignExchangeContract: ProductModel {
    typealias ContractType = ProductModel.Status
    
    var externalId: String?
    var customerId: Int?
    var customerTaxCode: String?
    var contractNumber: String?
    var contractDate: String?
    var conContractNumber: String?
    var conContractNumberDate: String?
    var contractAmount: Double?
    var contractCurrency: String? {
        didSet { currency = contractCurrency }
    }
    var contractPayCur: String?
    var endDate: String?
    var counterparty: String?
    var balance: Double?
    var paymentCurrency: String?
    var alias: String? {
        didSet { alias.map(rxName.onNext) }
    }
    var defaultAlias: String?
    var visible: Bool?
    var contractType: ContractType?
    var dio: Double?
    var difference: Double?
    
    var rxName = StringSubject(1)
    
    init(_ cmForeignExchangeContractProduct: CMForeignExchangeContractProduct) {
        super.init()
        
        self.id = cmForeignExchangeContractProduct.id
        self.actions = cmForeignExchangeContractProduct.actions?.map { $0.title } ?? nil
        self.demandActions = cmForeignExchangeContractProduct.demandActions?.map(DemandAction.init)
        self.currency = cmForeignExchangeContractProduct.currencyType?.currencyCode
        self.currencyName = cmForeignExchangeContractProduct.currencyName
        self.displayOrder = cmForeignExchangeContractProduct.displayOrder
        self.status = cmForeignExchangeContractProduct.status.map(Status.init) ?? nil
        self.accountId = cmForeignExchangeContractProduct.accountId
        
        self.externalId = cmForeignExchangeContractProduct.externalId
        self.customerId = cmForeignExchangeContractProduct.customerId
        self.customerTaxCode = cmForeignExchangeContractProduct.customerTaxCode
        self.contractNumber = cmForeignExchangeContractProduct.contractNumber
        self.contractDate = cmForeignExchangeContractProduct.contractDate
        self.conContractNumber = cmForeignExchangeContractProduct.conContractNumber
        self.conContractNumberDate = cmForeignExchangeContractProduct.conContractNumberDate
        self.contractAmount = cmForeignExchangeContractProduct.contractAmount
        self.contractCurrency = cmForeignExchangeContractProduct.contractCurrency
        self.contractPayCur = cmForeignExchangeContractProduct.contractPayCur
        self.endDate = cmForeignExchangeContractProduct.endDate
        self.counterparty = cmForeignExchangeContractProduct.counterparty
        self.balance = cmForeignExchangeContractProduct.balance
        self.paymentCurrency = cmForeignExchangeContractProduct.paymentCurrency
        self.alias = cmForeignExchangeContractProduct.alias
        self.defaultAlias = cmForeignExchangeContractProduct.defaultAlias
        self.visible = cmForeignExchangeContractProduct.visible
        self.contractType = cmForeignExchangeContractProduct.contractType.map(ProductModel.Status.init)
        self.dio = cmForeignExchangeContractProduct.dio
        self.difference = cmForeignExchangeContractProduct.difference
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override var productTitle: String? {
        get { return alias }
        set { alias = newValue }
    }
    
    override var amountToDisplay: String? {
        get { return String(contractAmount ?? 0.0) }
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        externalId <- map["externalId"]
        customerId <- map["customerId"]
        customerTaxCode <- map["customerTaxCode"]
        contractNumber <- map["contractNumber"]
        contractDate <- map["contractDate"]
        conContractNumber <- map["conContractNumber"]
        conContractNumberDate <- map["conContractNumberDate"]
        contractAmount <- map["contractAmount"]
        contractCurrency <- map["contractCurrency"]
        contractPayCur <- map["contractPayCur"]
        endDate <- map["endDate"]
        counterparty <- map["counterparty"]
        balance <- map["balance"]
        paymentCurrency <- map["paymentCurrency"]
        alias <- map["alias"]
        defaultAlias <- map["defaultAlias"]
        visible <- map["visible"]
        contractType <- map["contractType"]
        dio <- map["dio"]
        difference <- map["difference"]
    }
}
class CurrencyContract: ProductModel {
     var contractNumber: String?
 
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        contractNumber <- map["contractNumber"]
    }
}

struct CMForeignExchangeContractProduct: ProductProtocol, ProductPreviewProtocol {
    var id: Int
    var actions: [ProductActions]?
    var demandActions: [SMDemandAction]?
    var accountId: Int?
    var status: SMProductStatus?
    var alias: String?
    
    var currencyType: CurrencyType?
    let currencyName: String?
    
    let displayOrder: Double?
    
    var externalId: String?
    var customerId: Int?
    var customerTaxCode: String?
    var contractNumber: String?
    var contractDate: String?
    var conContractNumber: String?
    var conContractNumberDate: String?
    var contractAmount: Double?
    var contractCurrency: String?
    var contractPayCur: String?
    var endDate: String?
    var counterparty: String?
    var paymentCurrency: String?
    var contractType: SMProductStatus?
    var defaultAlias: String?
    var visible: Bool?
    var dio: Double?
    var difference: Double?
}

extension CMForeignExchangeContractProduct {
    var numberToDisplay: String? {
        return contractNumber
    }
    
    var accountNumber: String? {
        return contractNumber
    }
    
    var balance: Double? {
        return contractAmount
    }
}


struct SMForeignExchangeContractProduct: Codable {
    var id: Int
    
    var actions: [String]?
    var demandActions: [SMDemandAction]?
    var currencyName: String?
    var displayOrder: Double?
    var status: SMProductStatus?
    var accountId: Int?
    
    var externalId: String?
    var customerId: Int?
    var customerTaxCode: String?
    var contractNumber: String?
    var contractDate: String?
    var conContractNumber: String?
    var conContractNumberDate: String?
    var contractAmount: Double?
    var contractCurrency: String?
    var contractPayCur: String?
    var endDate: String?
    var counterparty: String?
    var balance: Double?
    var paymentCurrency: String?
    var alias: String?
    var contractType: SMProductStatus?
    var defaultAlias: String?
    var visible: Bool?
    var dio: Double?
    var difference: Double?
}

import Foundation

protocol ProductProtocol {
    var id: Int { get }
    var actions: [ProductActions]? { get }
    var demandActions: [SMDemandAction]? { get }
    var accountId: Int? { get }
    var status: SMProductStatus? { get }
    var accountNumber: String? { get }
    var alias: String? { get }
}

protocol ProductPreviewProtocol {
    var id: Int { get }
    var accountNumber: String? { get }
    var balance: Double? { get }
    var currencyType: CurrencyType? { get }
    var numberToDisplay: String? { get }
    var accountId: Int? { get }
    var status: SMProductStatus? { get }
    var alias: String? { get }
}
