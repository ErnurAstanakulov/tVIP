//
//  SavePaymentPurposeContext .swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 3/9/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation

class SavePaymentPurposeContext : Context {
    public var name: String?
    
    public override func urlString() -> String {
        return baseURL + "api/payment-purpose/create"
    }
    
    // This function can be reloaded
    public override func parametres() -> [String: Any]? {
        guard let name = self.name else { return nil }
        return ["purpose": name]
    }
}
