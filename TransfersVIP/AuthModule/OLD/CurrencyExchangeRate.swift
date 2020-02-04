//
//  CurrencyExchangeRate.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/25/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation
import ObjectMapper

class CurrencyExchangeRate: NSObject, Mappable {
    
    var usdLimitConst: Double?
    var currencyLimitConst: Double?
    var usdNbrkRate: Double?
    var currencyNbrkRate: Double?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        usdLimitConst <- map["usd_limit_const"]
        currencyLimitConst <- map["currency_limit_const"]
        usdNbrkRate <- map["usd_nbrk_rate"]
        currencyNbrkRate <- map["currency_nbrk_rate"]
    }
}
