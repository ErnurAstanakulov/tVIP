//
//  LoadAccountTransfersContext.swift
//  DigitalBank
//
//  Created by Misha Korchak on 11.04.17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation

class LoadAccountTransfersNetworkContext: NetworkContext {
    
    var route: Route
    
    var method: NetworkMethod = .get
    var isCopy: Bool?
    
    init(id: Int, isCopy: Bool) {
        route = .apiPaymentAccountTransferById(id)
        self.isCopy = isCopy
    }
    
    var parameters: [String : Any] {
        var params:[String: Any] = [:]
        if let isCopy = isCopy {
            params["isCopy"] = isCopy
        }
        return params
    }
}

class LoadDomesticTransferNetworkContext: NetworkContext {
    var route: Route
    var isCopy: Bool?

    var method: NetworkMethod = .get

    init(id: Int) {
        route = .apiPaymentDomesticTransferById(id)
    }
    
    var parameters: [String : Any] {
        var params:[String: Any] = [:]
        if let isCopy = isCopy {
            params["isCopy"] = isCopy
        }
        return params
    }
}

class LoadStandingOrderNetworkContext: NetworkContext {
    var route: Route
    var isCopy: Bool?

    var method: NetworkMethod = .get
    
    init(id: Int, isCopy: Bool) {
        route = .apiStandingOrderById(id)
        self.isCopy = isCopy
    }
    
    var parameters: [String : Any] {
        var params:[String: Any] = [:]
        if let isCopy = isCopy {
            params["isCopy"] = isCopy
        }
        return params
    }
}


class LoadDomesticTransferContext: Context {
    var ID: String?
    
    public override func urlString() -> String {
        guard let id = self.ID else { return "" }
        return baseURL + "api/payment/domestic-transfer/\(id)"
    }
}


class LoadAccountTransfersContext: Context {
    public var ID: String?
    public var isCopy: Bool?
    
    public override func urlString() -> String {
        guard let id = self.ID else { return "" }
        return baseURL + "api/payment/account-transfer/\(id)"
    }
    
    override func parametres() -> [String : Any]? {
        guard let isCopy = self.isCopy else {
            return nil
        }
        return ["isCopy": isCopy]
    }
}
