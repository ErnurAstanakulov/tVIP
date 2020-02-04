//
//  LoadPayDaysContext.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 4/6/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation

class LoadPayDaysContext: Context {
    var currency: String?
    
    public override func urlString() -> String {
        return baseURL + "api/calendar/get-current-and-value-dates"
    }
    
    public override func parametres() -> [String: Any]? {
        guard let currency = self.currency else { return nil }
        return ["currency": currency]
    }
}

