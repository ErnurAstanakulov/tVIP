//
//  Route.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 6/27/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation

public enum Route: RouteProtocol {
    case apiSubsidiarieCustomer
    case apiSubsidiarieCustomerId(_ id: Int)
    case apiCodeBy(_ end: String)
    case apiOAuthToken
    case apiExchangeRate(_ byCode: String)
    case apiCustomerNews(_ sort: String, _ isActual: Bool)
    case apiProcessAuthFactorOtpSync
    case apiRequestSMS
    
    case apiDepositsByCustomer
    case apiCreditsByCustomer
    case apiCardsByCustomer
    case apiAccountsForWeb
    case apiForeignExchangeContractsForWeb
    case apiGuaranteesForWeb
    
    case apiDepositsTotalBalance
    case apiCreditsTotalBalance
    case apiCardsTotalBalance
    case apiAccountsTotalBalance
    case apiForeignExchangeContractTotalBalance
    case apiGuaranteesTotalBalance
    
    case apiDocumentsWorkingCount
    case apiCustomerDocumentsWork
    case apiWorkflowDocumentAction
    case apiCustomerDocumentsValidateRedBalance
    
    case apiPaymentAccountTransfer
    case apiPaymentDomesticTransfer
    case apiPaymentInternationalTransfer
    case apiStandingOrder
    case apiExposedOrder
    case apiCustomerDocumentsDocumentWithdraw
    case apiInvoice

    case apiPaymentAccountTransferById(_ id: Int)
    case apiPaymentDomesticTransferById(_ id: Int)
    case apiPaymentInternationalTransferById(_ id: Int)
    case apiExposedOrderById(_ id: Int)
    case apiStandingOrderById(_ id: Int)
    case apiInvoiceById(_ id: Int)
    case apiCustomerDocumentsDocumentWithDraw(_ id: Int)
    case apiCustomerDocumentsDocumentWithDrawDoToWithDraw(_ id: Int)
    case apiSigningSMSRequest
    case apiSigningCheckSMS
    case apiSigningCheckOTP
    
    // profile
    case apiPersonal
    case apiPersonalUpdate
    case apiTranslateLocales
    case apiPersonalByAuthPerson
    case apiNotificationsProperties
    case apiNotificationsPropertiesById(_ id: Int)

    public var serverUrl: String {
        return baseURL
    }   
}

extension Route {
    public var rawValue: String {
        switch self {
        case .apiSubsidiarieCustomer: return "api/subsidiary-customer"
        case .apiSubsidiarieCustomerId(let id): return "api/subsidiary-customer/\(id)"
        case .apiCodeBy(let end): return "api/codes/by/\(end)"
        case .apiOAuthToken: return "auth/oauth/token"
        case .apiExchangeRate(let code): return "api/exchange-rate/by-currency/?baseCurrencyIsoCode=\(code)"
        case .apiCustomerNews(let sort, let isActual): return "api/news/customer-news?sort=\(sort)&isActual=\(isActual)"
        case .apiProcessAuthFactorOtpSync: return "api/process-auth-factor/h-otp-sync"
        case .apiRequestSMS: return "api/process-auth-factor/request-sms"
        case .apiDepositsByCustomer: return "api/deposits/get-deposits-by-customer"
        case .apiCreditsByCustomer: return "api/credits/get-credits-by-customer"
        case .apiGuaranteesForWeb: return "api/guarantee/get-guarantees-for-web"
        case .apiCardsByCustomer: return "api/card/get-cards-by-customer"
        case .apiAccountsForWeb: return "api/account/get-accounts-for-web"
        case .apiForeignExchangeContractsForWeb: return "api/frgnexchange/get-exchange-for-web"
        case .apiDepositsTotalBalance: return "api/deposits/get-total-balance"
        case .apiCreditsTotalBalance: return "api/credits/get-total-balance"
        case .apiCardsTotalBalance: return "api/card/get-total-balance"
        case .apiAccountsTotalBalance: return "api/account/get-total-balance"
        case .apiForeignExchangeContractTotalBalance: return "api/frgnexchange/get-total-balance"
        case .apiGuaranteesTotalBalance: return "api/guarantee/get-total-balance"
        case .apiDocumentsWorkingCount: return "api/customer/documents/working-count"
        case .apiCustomerDocumentsWork: return
            "api/customer/documents/work"
        case .apiWorkflowDocumentAction: return
            "api/workflow/documentAction"
        case .apiCustomerDocumentsValidateRedBalance: return "api/customer/documents/validate-red-balance"
        case .apiPaymentAccountTransfer:
            return "api/payment/account-transfer/new"
        case .apiPaymentDomesticTransfer:
            return "api/payment/domestic-transfer/new"
        case .apiPaymentInternationalTransfer:
            return "api/payment/international-transfer/new"
        case .apiStandingOrder:
            return "api/standing-order/new"
        case .apiExposedOrder:
            return "api/exposedorder"
        case .apiCustomerDocumentsDocumentWithdraw:
            return "api/customer/documents/document-withdraw/new"
        case .apiInvoice:
            return "api/invoice/new"
        case .apiPaymentAccountTransferById(let id):
            return "api/payment/account-transfer/\(id)"
        case .apiPaymentDomesticTransferById(let id):
            return "api/payment/domestic-transfer/\(id)"
        case .apiPaymentInternationalTransferById(let id):
            return "api/payment/international-transfer/\(id)"
        case .apiExposedOrderById(let id):
            return "api/exposedorder/\(id)"
        case .apiStandingOrderById(let id):
            return "api/standing-order/\(id)"
        case .apiInvoiceById(let id):
            return "api/invoice/\(id)"
        case .apiCustomerDocumentsDocumentWithDraw(let id):
            return "api/customer/documents/document-withdraw/\(id)"
        case .apiCustomerDocumentsDocumentWithDrawDoToWithDraw(let id):
            return "api/customer/documents/document-withdraw/doc-to-withdraw/\(id)"
        case .apiSigningSMSRequest:
            return "api/signing/sms-request"
        case .apiSigningCheckSMS:
            return "api/signing/checkSMS"
        case .apiSigningCheckOTP:
            return "api/signing/checkOTP"
        case .apiPersonal:
            return "api/personal"
        case .apiPersonalUpdate:
            return "api/personal/update"
        case .apiTranslateLocales:
            return "api/translate/locales"
        case .apiPersonalByAuthPerson:
            return "api/personal/by-auth-person"
        case .apiNotificationsProperties:
            return "api/notifications/properties"
        case .apiNotificationsPropertiesById(let id):
            return "api/notifications/properties/\(id)"
        }
    }
}
