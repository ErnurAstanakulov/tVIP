//
//  SMSAuthentication.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 4/28/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import Alamofire

class SMSAuthenticationContext: Context {
    public var smsSender: LoginSMSSender!
    
    public override func urlString() -> String {
        return baseURL + "api/customer/sms"
    }
   
    public override func parametres() -> [String: Any]? {
        return smsSender.toJSON()
    }
    
    public override func HTTPMethod() -> HTTPMethod {
        return .post
    }
    
    public override func encoding() -> ParameterEncoding {
        return JSONEncoding.default
    }
}
