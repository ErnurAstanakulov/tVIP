//
//  LoadPaymentRevokesContext.swift
//  DigitalBank
//
//  Created by Misha Korchak on 08.05.17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation

class LoadPaymentRevokesContext: Context {
    var page = 0
    
    var nextPage: Int{
        get{
            page += 1
            return page
        }
    }
    
    public var dictionary:[String:Any?] =
        [   "dateFrom"      : nil,
            "dateTo"        : nil,
            "search"        : nil,
            "status"        : nil,
            "types"         : nil,
            "selectedPeriod": "week",
            "page"          : 0,
            "size"          : Constants.objectsToLoad,
            "sort"          : "wdocument.updated",
            "order"         : "desc"]
    
    
    public override func urlString() -> String {
        return baseURL + "api/customer/documents/document-withdraw/"
    }
    
    override func parametres() -> [String : Any]? {
        var dict = AnyDict()
        for (key, value) in dictionary{
            if let value = value {
                dict.updateValue(value, forKey: key)
            }
        }
        dict["page"] = page
        dict["size"] = Constants.objectsToLoad
        return dict
    }
    
}
