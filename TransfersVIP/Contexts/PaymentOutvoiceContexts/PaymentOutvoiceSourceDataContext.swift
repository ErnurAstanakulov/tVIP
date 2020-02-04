//
//  PaymentOutvoiceSourceDataContext.swift
//  DigitalBank
//
//  Created by iosDeveloper on 7/18/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation

class PaymentOutvoiceSourceDataContext: GenericContext<AnyDict> {
    
    override func urlString() -> String {
        return  baseURL + "api/documents/mobile/payment-order-and-payroll-data"

    }
}

