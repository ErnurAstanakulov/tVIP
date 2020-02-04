//
//  AccountTransfersFullModel.swift
//  DigitalBank
//
//  Created by Misha Korchak on 11.04.17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import ObjectMapper

class AccountTransfersFullModel: BaseModel {
    var externalId: String?
    var custId: Int?
    var custName: String?
    var custTaxCode: String?
    var custResidencyCode: String?
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
    var receiveDateTime: String?
    var account: AccountsViews?
    var custBankCode: String?
    var custBankName: String?
    var amount: Double?
    var valueDate: String?
    var purpose: String?
    var purposeCode: String?
    var purposeCodeLabel: String?
    var priority: Bool?
    var benefName: String?
    var benefTaxCode: String?
    var benefAccount: String?
    var benefBankCode: String?
    var benefResidencyCode: String?
    var actions: Actions?
    var accountTransferType: String?
    var individualExchangeRate: Bool?
    var exchangeRate: Double?
    var creditAccount: AccountsViews?
    var creditSum: Double?
    var feeAccount: AccountsViews?
    var fixDebitSum: Bool?
    var standingOrder: String?
    var operationTargetCode: String?
    var executionAmount: Sum?
    var executionRate: Sum?
    var currencyContracts: [ForeignExchangeContract]?
    var operationTargetId: Int?
    var operationTargetName: String?
    var timeTo:String?
    var fixedAmount: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        custId <- map["custId"]
        custName <- map["custName"]
        custTaxCode <- map["custTaxCode"]
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
        isTemplate <- map["template"]
        templateName <- map["templateName"]
        receiveDateTime <- map["receiveDateTime"]
        account <- map["account"]
        custBankCode <- map["custBankCode"]
        custBankName <- map["custBankName"]
        amount <- map["amount"]
        valueDate <- map["valueDate"]
        purpose <- map["purpose"]
        purposeCode <- map["purposeCode"]
        purposeCodeLabel <- map["purposeCodeLabel"]
        priority <- map["priority"]
        benefName <- map["benefName"]
        benefTaxCode <- map["benefTaxCode"]
        benefAccount <- map["benefAccount"]
        benefBankCode <- map["benefBankCode"]
        benefResidencyCode <- map["benefResidencyCode"]
        actions <- map["actions"]
        accountTransferType <- map["accountTransferType"]
        individualExchangeRate <- map["individualExchangeRate"]
        exchangeRate <- map["exchangeRate"]
        creditAccount <- map["creditAccount"]
        creditSum <- map["creditSum"]
        feeAccount <- map["feeAccount"]
        fixDebitSum <- map["fixDebitSum"]
        standingOrder <- map["standingOrder"]
        operationTargetCode <- map["operationTargetCode"]
        executionAmount <- map["executionAmount"]
        executionRate <- map["executionRate"]
        currencyContracts <- map["currencyContracts"]
        operationTargetId <- map["operationTargetId"]
        operationTargetName <- map["operationTargetName"]
        timeTo <- map["timeTo"]
        fixedAmount <- map["fixedAmount"]
        
    }
}
//struct SMAccountTransfersFullModel: Codable, SMBaseModel {
//    var id: Int
//    var externalId: String?
//    var custId: Int?
//    var custName: String?
//    var custTaxCode: String?
//    var custResidencyCode: String?
//    var created: String?
//    var number: String?
//    var state: String?
//    var type: String?
//    var director: SMCompanyPerson?
//    var accountant: SMCompanyPerson?
//    var bankResponse: String?
//    var manager: String?
//    var info: String?
//    var isTemplate: Bool?
//    var templateName: String?
//    var receiveDateTime: String?
//    var account: SMAccountsViews?
//    var custBankCode: String?
//    var custBankName: String?
//    var amount: Double?
//    var valueDate: String?
//    var purpose: String?
//    var purposeCode: String?
//    var purposeCodeLabel: String?
//    var priority: Bool?
//    var benefName: String?
//    var benefTaxCode: String?
//    var benefAccount: String?
//    var benefBankCode: String?
//    var benefResidencyCode: String?
//    var actions: SMTransferActions?
//    var accountTransferType: String?
//    var individualExchangeRate: Bool?
//    var exchangeRate: Double?
//    var creditAccount: SMAccountsViews?
//    var creditSum: Double?
//    var feeAccount: SMAccountsViews?
//    var fixDebitSum: Bool?
//    var standingOrder: String?
//    var operationTargetCode: String?
//    var executionAmount: Sum?
//    var executionRate: Sum?
//    var currencyContracts: [CMForeignExchangeContractProduct]?
//    var operationTargetId: Int?
//    var operationTargetName: String?
//    var timeTo:String?
//    var fixedAmount: String?
//}
//
//struct CMAccountTransfersFullModel {
//    var id: Int
//    var externalId: String?
//    var custId: Int?
//    var custName: String?
//    var custTaxCode: String?
//    var custResidencyCode: String?
//    var created: String?
//    var number: String?
//    var state: String?
//    var type: String?
//    var director: SMCompanyPerson?
//    var accountant: SMCompanyPerson?
//    var bankResponse: String?
//    var manager: String?
//    var info: String?
//    var isTemplate: Bool?
//    var templateName: String?
//    var receiveDateTime: String?
//    var account: SMAccountsViews?
//    var custBankCode: String?
//    var custBankName: String?
//    var amount: Double?
//    var valueDate: String?
//    var purpose: String?
//    var purposeCode: String?
//    var purposeCodeLabel: String?
//    var priority: Bool?
//    var benefName: String?
//    var benefTaxCode: String?
//    var benefAccount: String?
//    var benefBankCode: String?
//    var benefResidencyCode: String?
//    var actions: SMTransferActions?
//    var accountTransferType: String?
//    var individualExchangeRate: Bool?
//    var exchangeRate: Double?
//    var creditAccount: SMAccountsViews?
//    var creditSum: Double?
//    var feeAccount: SMAccountsViews?
//    var fixDebitSum: Bool?
//    var standingOrder: String?
//    var operationTargetCode: String?
//    var executionAmount: Sum?
//    var executionRate: Sum?
//    var currencyContracts: [CMForeignExchangeContractProduct]?
//    var operationTargetId: Int?
//    var operationTargetName: String?
//    var timeTo:String?
//    var fixedAmount: String?
//}
//
//
//struct AccountTransfersModelConverter: ModelConverter {
//    static func convert(serverModel: SMAccountTransfersFullModel) -> CMAccountTransfersFullModel {
//
//        return CMAccountTransfersFullModel(
//            id: serverModel.id,
//            externalId: serverModel.externalId,
//            custId: serverModel.custId,
//            custName: serverModel.custName,
//            custTaxCode: serverModel.custTaxCode,
//            custResidencyCode: serverModel.custResidencyCode,
//            created: serverModel.created,
//            number: serverModel.number,
//            state: serverModel.state,
//            type: serverModel.type,
//            director: serverModel.director,
//            accountant: serverModel.accountant,
//            bankResponse: serverModel.bankResponse,
//            manager: serverModel.manager,
//            info: serverModel.info,
//            isTemplate: serverModel.isTemplate,
//            templateName: serverModel.templateName,
//            receiveDateTime: serverModel.receiveDateTime,
//            account: serverModel.account,
//            custBankCode: serverModel.custBankCode,
//            custBankName: serverModel.custBankName,
//            amount: serverModel.amount,
//            valueDate: serverModel.valueDate,
//            purpose: serverModel.purpose,
//            purposeCode: serverModel.purposeCode,
//            purposeCodeLabel: serverModel.purposeCodeLabel,
//            priority: serverModel.priority,
//            benefName: serverModel.benefName,
//            benefTaxCode: serverModel.benefTaxCode,
//            benefAccount: serverModel.benefAccount,
//            benefBankCode: serverModel.benefBankCode,
//            benefResidencyCode: serverModel.benefResidencyCode,
//            actions: serverModel.actions,
//            accountTransferType: serverModel.accountTransferType,
//            individualExchangeRate: serverModel.individualExchangeRate,
//            exchangeRate: serverModel.exchangeRate,
//            creditAccount: serverModel.creditAccount,
//            creditSum: serverModel.creditSum,
//            feeAccount: serverModel.feeAccount,
//            fixDebitSum: serverModel.fixDebitSum,
//            standingOrder: serverModel.standingOrder,
//            operationTargetCode: serverModel.operationTargetCode,
//            executionAmount: serverModel.executionAmount,
//            executionRate: serverModel.executionRate,
//            currencyContracts: serverModel.currencyContracts,
//            operationTargetId: serverModel.operationTargetId,
//            operationTargetName: serverModel.operationTargetName,
//            timeTo: serverModel.timeTo,
//            fixedAmount: serverModel.fixedAmount
//        )
//    }
//
//    static func convert(clientModel: CMAccountTransfersFullModel) -> SMAccountTransfersFullModel {
//
//        return SMAccountTransfersFullModel(
//            id: clientModel.id,
//            externalId: clientModel.externalId,
//            custId: clientModel.custId,
//            custName: clientModel.custName,
//            custTaxCode: clientModel.custTaxCode,
//            custResidencyCode: clientModel.custResidencyCode,
//            created: clientModel.created,
//            number: clientModel.number,
//            state: clientModel.state,
//            type: clientModel.type,
//            director: clientModel.director,
//            accountant: clientModel.accountant,
//            bankResponse: clientModel.bankResponse,
//            manager: clientModel.manager,
//            info: clientModel.info,
//            isTemplate: clientModel.isTemplate,
//            templateName: clientModel.templateName,
//            receiveDateTime: clientModel.receiveDateTime,
//            account: clientModel.account,
//            custBankCode: clientModel.custBankCode,
//            custBankName: clientModel.custBankName,
//            amount: clientModel.amount,
//            valueDate: clientModel.valueDate,
//            purpose: clientModel.purpose,
//            purposeCode: clientModel.purposeCode,
//            purposeCodeLabel: clientModel.purposeCodeLabel,
//            priority: clientModel.priority,
//            benefName: clientModel.benefName,
//            benefTaxCode: clientModel.benefTaxCode,
//            benefAccount: clientModel.benefAccount,
//            benefBankCode: clientModel.benefBankCode,
//            benefResidencyCode: clientModel.benefResidencyCode,
//            actions: clientModel.actions,
//            accountTransferType: clientModel.accountTransferType,
//            individualExchangeRate: clientModel.individualExchangeRate,
//            exchangeRate: clientModel.exchangeRate,
//            creditAccount: clientModel.creditAccount,
//            creditSum: clientModel.creditSum,
//            feeAccount: clientModel.feeAccount,
//            fixDebitSum: clientModel.fixDebitSum,
//            standingOrder: clientModel.standingOrder,
//            operationTargetCode: clientModel.operationTargetCode,
//            executionAmount: clientModel.executionAmount,
//            executionRate: clientModel.executionRate,
//            currencyContracts: clientModel.currencyContracts,
//            operationTargetId: clientModel.operationTargetId,
//            operationTargetName: clientModel.operationTargetName,
//            timeTo: clientModel.timeTo,
//            fixedAmount: clientModel.fixedAmount
//        )
//    }
//}
