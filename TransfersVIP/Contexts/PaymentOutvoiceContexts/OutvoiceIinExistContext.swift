//
//  OutvoiceIinExistContext.swift
//  DigitalBank
//
//  Created by Алем Утемисов on 22.01.2018.
//  Copyright © 2018 iosDeveloper. All rights reserved.
//

import Foundation
import Alamofire

class OutvoiceIinExistContext: Context {
    
    public var iin: String!
    public var payerName: String!
    
    override func urlString() -> String {
        return baseURL + "api/exposedorder/is-exist"
    }
    
    override func parametres() -> [String : Any]? {
        guard let iin = iin, let payerName = payerName else { return nil }
        return [
            "payerTaxCode": iin,
            "payerName": payerName
        ]
    }
}
