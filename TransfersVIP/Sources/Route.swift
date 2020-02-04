//
//  Route.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 6/27/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation
/// URL route protocol;
/// For **enum** extension with raw type **String**
public protocol RouteProtocol {
    
    /// Server URL
    var serverUrl: String { get }
    
    /// route API
    var rawValue: String { get }
}

public extension RouteProtocol {
    
    /// Get complete URL route
    var urlString: String { return serverUrl + rawValue }
}

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
        }
    }
}

class NewsletterListNetworkContext: NetworkContext {
    var route: Route = .apiCustomerNews("newsDate", true)
    var method: NetworkMethod = .get
}
let host = "digital-dev.sberbank.kz"
public let baseURL = "http://" + host + "/"
