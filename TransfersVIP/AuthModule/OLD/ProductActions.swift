//
//  ProductActions.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/31/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation

enum ProductActions: String, Codable {
    //TODO: Remove rawValue and use var title
    case details = "details"
    case statement = "statement"
    case closeAccount = "closeAccount"
    case transfer = "transfer"
    case intTransferOrder = "intTransferOrder"
    case history = "history"
    case exposeOrder = "exposeOrder"
    case paymentFromAccount = "paymentFromAccount"
    case sendRequisites = "sendRequisites"
    case payrollFromAccount = "payrollFromAccount"
    case ownAccountTransfer = "ownAccountTransfer"
    case arrest = "arrest"
    
    case openCardOrder = "openCardOrder"
    case creditCard = "creditCard"
    case block = "block"
    case blockedAmountDetails = "blockedAmountDetails"
    case unblockCard = "unblockCard"
    case changeLimits = "changeLimits"
    case configureRestrictions = "configureRestrictions"
    case newCard = "newCard"
    
    case issueTranche = "issueTranche"
    case demandIssuanceTranche = "demandIssuanceTranche"
    case prescheduledRepaymentOrder = "prescheduledRepaymentOrder"
    case loanPayment = "loanPayment"
    case tranches = "tranches"
    case schedule = "schedule"
    case creditDebtByDate = "creditDebtByDate"
    case creditLoanStatement = "creditLoanStatement"
    
    case closeDepositOrder = "closeDepositOrder"
    case depositReplenishment = "depositReplenishment"
    case withdraw = "withdraw"
    case partialWithdraw = "partialWithdraw"
    case earlyTermination = "earlyTermination"
    
    case viewOperations = "viewOperations"
    case conversion = "conversion"
    case assignUNK = "assignUNK"
    
    var title: String {
        return rawValue
    }
}
