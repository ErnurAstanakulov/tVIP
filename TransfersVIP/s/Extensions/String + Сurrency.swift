//
//  String + Сurrency.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 3/21/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation

extension String {
    
    
    // formatting text for currency textField
    func currencyInputFormatting() -> String {
        let formatter = NumberFormatter()
        //        formatter.numberStyle = .currencyAccounting
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        let double = (amountWithPrefix as NSString).doubleValue
        let number = NSNumber(value: (double / 100))
        
        guard number != 0 as NSNumber else { return "" }
        
        let summ = formatter.string(from: number)!
        return summ.replacingOccurrences(of: ",", with: ".")
    }
    
    func splitedAmount() -> String? {
        let parsedAmount = self.replacingOccurrences(of: ",", with: ".")
        guard let floatAmount = Sum(parsedAmount) else { return nil }
        let number = NSNumber(value: floatAmount)
        let formatter = NumberFormatter()
        formatter.decimalSeparator = "." //DESC, coints separator
        formatter.groupingSeparator = " " // amounts separator
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: number)
    }
    
    func amountInputFormatting() -> String? {
        guard let amount = Double(self) else {
            return nil
        }
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.groupingSize = 3
        currencyFormatter.currencySymbol = ""
        currencyFormatter.currencyGroupingSeparator = " "
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencyDecimalSeparator = ","
        
        return currencyFormatter.string(from: NSNumber(value: amount))!
    }
    
    func doubleFromAmountInputFormat() -> Double? {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.groupingSize = 3
        currencyFormatter.currencySymbol = ""
        currencyFormatter.currencyGroupingSeparator = " "
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencyDecimalSeparator = ","
        
        return currencyFormatter.number(from: self) as? Double
    }
}

