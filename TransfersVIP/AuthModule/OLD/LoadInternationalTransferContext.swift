//
//  LoadInternationalTransferContext.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 4/3/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation

class LoadInternationalTransferNetworkContext: NetworkContext {
    var route: Route
    var isCopy: Bool
    var method: NetworkMethod {
        return .get
    }
    
    init(id: Int, isCopy: Bool) {
        route = .apiPaymentInternationalTransferById(id)
        self.isCopy = isCopy
    }
    
    var parameters: [String : Any] {
        var params:[String: Any] = [:]
        params["isCopy"] = isCopy
        return params
    }
}

class LoadPaymentOutvoiceNetworkContext: NetworkContext {
    var route: Route
    var isCopy: Bool
    var method: NetworkMethod {
        return .get
    }
    
    init(id: Int, isCopy: Bool) {
        route = .apiExposedOrderById(id)
        self.isCopy = isCopy
    }
    
    var parameters: [String : Any] {
        var params:[String: Any] = [:]
        params["isCopy"] = isCopy
        return params
    }
}

class LoadPaymentInvoiceNetworkContext: NetworkContext {
    var route: Route
    var isCopy: Bool
    var method: NetworkMethod {
        return .get
    }
    
    init(id: Int, isCopy: Bool) {
        route = .apiInvoiceById(id)
        self.isCopy = isCopy
    }
    
    var parameters: [String : Any] {
        var params:[String: Any] = [:]
        params["isCopy"] = isCopy
        return params
    }
}

class LoadPaymentsRevokeDetailNetworkContext: NetworkContext {
    var route: Route
    var isCopy: Bool
    var method: NetworkMethod {
        return .get
    }
    
    init(id: Int, isCopy: Bool) {
        self.isCopy = isCopy
        route = .apiCustomerDocumentsDocumentWithDraw(id)
    }
    
    var parameters: [String : Any] {
        var params:[String: Any] = [:]
        params["isCopy"] = isCopy
        return params
    }
}

class LoadPaymentsDocumentWithDrawNetworkContext: NetworkContext {
    var route: Route
    var method: NetworkMethod {
        return .get
    }
    
    init(id: Int) {
        route = .apiCustomerDocumentsDocumentWithDrawDoToWithDraw(id)
    }
}

class LoadInternationalTransferContext: Context {
    public var ID: String?
    
    public override func urlString() -> String {
        guard let id = self.ID else { return "" }
        return baseURL + "api/payment/international-transfer/\(id)"
    }
}
class LoadFortexTransferContext: Context {
    public var ID: String?

    public override func urlString() -> String {
        guard let id = self.ID else { return "" }
        return baseURL + "api/fortex/\(id)"
    }
}
