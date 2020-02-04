//
//  CurrencyItem.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/12/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

struct CurrencyItem: Decodable {
    var isoCode: String
    var ratePurchase: String
    var rateSale: String
    var rateNational: String
    
    enum CodingKeys: String, CodingKey {
        case isoCode = "targetCurrencyIsoCode"
        case ratePurchase
        case rateSale
        case rateNational
    }
}

