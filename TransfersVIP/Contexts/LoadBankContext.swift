//
//  LoadBankContext.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 3/31/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation

class LoadBankContext: Context {
    var bankID: Int?
    
    public override func urlString() -> String {
        var urlParameter: String = ""
        if let id = bankID {
            urlParameter = String(format: "%d", id)
        }
        return baseURL + "api/banks/view/" + urlParameter
    }
}

class LoadBankSwiftsContext: Context {
    var search: String = ""
    var page: Int = 0
    var size: Int = 20
    var sort: String = "INTERNATIONAL_BANK_BIK"
    var order: String = "desc"
    var isNumeric: Bool = false
    
    public override func urlString() -> String {
        return  baseURL + "api/banks/get-international-banks-swifts"
    }
    public override func parametres() -> [String: Any] {
        var dict = ["search": search,
                    "page": page,
                    "size": size,
                    "sort": sort,
                    "order": order] as [String : Any]
        if isNumeric {
            dict["contains"] = "numeric"
        }
        return dict
    }
}
