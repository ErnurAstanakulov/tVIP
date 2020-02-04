//
//  FilterContext.swift
//  DigitalBank
//
//  Created by Alex Vovkotrub on 25.07.17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import UIKit
import Alamofire

class FilterContext: Context {
    public override func urlString() -> String {
        return baseURL + "api/common?type=document_type&type=document_state"
    }
    
    // By default .get, this function can be reloaded
    public override func HTTPMethod() -> HTTPMethod {
        return .get
    }
}
