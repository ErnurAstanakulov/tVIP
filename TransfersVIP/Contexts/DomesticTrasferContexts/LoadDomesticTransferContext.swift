//
//  LoadDomesticTransferContext.swift
//  DigitalBank
//
//  Created by iosDeveloper on 7/21/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation

class LoadDomesticTransferContext: Context {
    var ID: String?
    
    public override func urlString() -> String {
        guard let id = self.ID else { return "" }
        return baseURL + "api/payment/domestic-transfer/\(id)"
    }
}

class LoadStandingOrderContext: Context {
    var ID: String?
    
    public override func urlString() -> String {
        guard let id = self.ID else { return "" }
        return baseURL + "api/standing-order/\(id)"
    }
}
