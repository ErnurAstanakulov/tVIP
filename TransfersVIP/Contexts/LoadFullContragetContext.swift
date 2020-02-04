//
//  LoadFullContraget.swift
//  DigitalBank
//
//  Created by iosDeveloper on 6/13/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation

class LoadFullContragetContext: Context {
    public var contragentID: Int = Int.max
    
    public override func urlString() -> String {
        let id = String(contragentID)
        return baseURL + "api/counterparty/find-one-int/\(id)"
    }
}
