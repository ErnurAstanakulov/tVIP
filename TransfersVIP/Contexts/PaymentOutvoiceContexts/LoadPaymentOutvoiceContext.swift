//
//  LoadPaymentOutvoiceContext.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 4/12/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation

class LoadPaymentOutvoiceContext: Context {
    public var ID: String!
    
    public override func urlString() -> String {
        guard let id = ID else { return "" }
        return baseURL + "api/exposedorder/\(id)"
    }
}

