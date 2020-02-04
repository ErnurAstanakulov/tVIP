//
//  LoadInternationalTransferContext.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 4/3/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation

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
