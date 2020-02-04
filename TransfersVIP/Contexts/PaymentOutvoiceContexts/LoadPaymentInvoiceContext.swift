//
//  LoadPaymentInvoiceContext.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 4/10/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation

class LoadPaymentInvoiceContext: Context {
    public var ID: String!
    
    public override func urlString() -> String {
        guard let id = ID else { return "" }
        return baseURL + "api/invoice/\(id)"
    }
}
