//
//  LoadPaymentOrderTamplatesContext.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 3/6/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import Alamofire

class LoadPaymentOrderTamplatesContext: Context {
    public var documentType: String!
    
    override func urlString() -> String {
        return baseURL + "api/payment/domestic-transfer/template-list"
    }
    
    public override func parametres() -> [String: Any]? {
        return ["documentType": documentType ?? ""]
    }
}
