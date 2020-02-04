//
//  VATContext.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 3/1/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import Alamofire

class VATContext: Context {
    public var sum: String = "0"
    public override func urlString() -> String {
        return "\(baseURL)api/customer/documents/calculate-vat?amount=\(sum)"
    }
    
    public override func parametres() -> [String: Any]? {
        return nil
    }
    
    // By default .get, this function can be reloaded
    public override func HTTPMethod() -> HTTPMethod {
        return .get
    }
    
    // By default .URLEncoding.default, this function can be reloaded
    public override func encoding() -> ParameterEncoding {
        return JSONEncoding.default
    }
}
   
