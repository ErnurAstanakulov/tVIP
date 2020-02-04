//
//  OTPAuthentication.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 4/28/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import Alamofire

class OTPAuthenticationContext: Context {
    public var otpSender: LoginOTPSender!
    
    public override func urlString() -> String {
        return baseURL + "api/customer/otp"
    }
    
    public override func parametres() -> [String: Any]? {
        return otpSender.toJSON()
    }
    
    public override func HTTPMethod() -> HTTPMethod {
        return .post
    }
}
