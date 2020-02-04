//
//  BaseConstraint.swift
//  DigitalBank
//
//  Created by Vlad on 17.08.17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseConstraint: Mappable {
    var isRequired: Bool?
    var regexp: String? //название шаблона регулярки
    var regexpr: String? //приходит сразу регулярка
    var email: Bool?
    var account: Bool?
    var taxCode: Bool?
    var greaterThanZero: Bool?
    var maxLength: Int?
    var minLength: Int?
    var length: Int?
    var regExchangeRate: String?
    var password: Bool?
    var amount: Bool?
    var amountNotNull: Bool? // uses for maskedAmount
    var selected: Bool? // filter invalid selection (none)
    var iban: Bool?
    var hasProperty: String?
    var disabledNames: [String]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        isRequired <- map["required"]
        regexp <- map["regexp"]
        regexpr <- map["regexpr"]
        email <- map["email"]
        account <- map["account"]
        taxCode <- map["taxCode"]
        greaterThanZero <- map["greaterThanZero"]
        maxLength <- map["maxLength"]
        minLength <- map["minLength"]
        length <- map["length"]
        regExchangeRate <- map["regExchangeRate"]
        password <- map["password"]
        amount <- map["amount"]
        amountNotNull <- map["amountNotNull"]
        selected <- map["selected"]
        iban <- map["iban"]
        hasProperty <- map["hasProperty"]
        disabledNames <- map["disabledNames"]
    }
    
    init(isRequired: Bool = false) {
        self.isRequired = isRequired
    }
}

