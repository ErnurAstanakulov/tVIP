//
//  LoadAccountTransfersContext.swift
//  DigitalBank
//
//  Created by Misha Korchak on 11.04.17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation

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
