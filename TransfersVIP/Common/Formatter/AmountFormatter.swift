//
//  AmountFormatter.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/30/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation

class AmountFormatter: TextFormatter {
    
    private var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        
        formatter.usesGroupingSeparator = true
        formatter.groupingSize = 3
        formatter.numberStyle = .currency
        formatter.currencyCode = ""
        formatter.currencySymbol = ""
        formatter.currencyDecimalSeparator = "."
        formatter.currencyGroupingSeparator = " "
        
        return formatter
    }()
    
    func string(for obj: Any) -> String? {
        guard let amount = obj as? Double else {
            return nil
        }
        return formatter.string(from: NSNumber(value: amount))!
    }
}
