//
//  ExchangeRate.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 4/11/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import ObjectMapper

class ExchangeRate: BaseModel {
    var type: ExchangeRateType?
    var typeId: Int?
    var baseCurrencyIsoCode: String?
    var currencyIsoCode: String?
    var validFrom: String?
    var validTo: String?
    var coursePurchase: String?
    var courseSale: String?
    var scale: String?
    var rateNational: String?
    
    var fullCurrency: String { return String(format: "\(self.baseCurrencyIsoCode ?? "") - \(self.currencyIsoCode ?? "")") }
    var validFull: String { return String(format: "\(self.validFrom ?? "") - \(self.validTo ?? "")") }
    
    //Additional property
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {        
        super.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        type <- map["type"]
        typeId <- map["typeId"]
        baseCurrencyIsoCode <- map["baseCurrencyIsoCode"]
        currencyIsoCode <- map["targetCurrencyIsoCode"]
        validFrom <- map["validFrom"]
        validTo <- map["validTo"]
        coursePurchase <- map["ratePurchase"]
        courseSale <- map["rateSale"]
        scale <- map["scale"]
        rateNational <- map["rateNational"]
    }
    
    class ExchangeRateType: BaseModel {
        var value: String?
        var label: String?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            
            value <- map["value"]
            label <- map["label"]
        }
    }
    
    public var descriptionLabel: String? {
        guard let base = self.baseCurrencyIsoCode, let destination = self.currencyIsoCode else { return nil }
        return "\(base) - \(destination)"
    }
    
    var coursePurchaseFloat: Sum? { return coursePurchase.flatMap({ Sum($0) }) }
    var courseSaleFloat: Sum? { return courseSale.flatMap ({ Sum($0) }) }
}
