//
//  SaveRecipientContext.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 3/9/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import Alamofire

class SaveRecipientContext: Context {
    public var recipient: Recipient?
    
    public override func urlString() -> String {
        return baseURL + "api/counterparty/payment"
    }
    
    // This function can be reloaded
    public override func parametres() -> [String: Any]? {
        guard let recipient = self.recipient else { return nil }
        return recipient.toJSON()
    }
    
    // By default .get, this function can be reloaded
    public override func HTTPMethod() -> HTTPMethod {
        return .post
    }
    
    // By default .URLEncoding.default, this function can be reloaded
    public override func encoding() -> ParameterEncoding {
        return JSONEncoding.default
    }
}
