//
//  String+extesion.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/4/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation

extension String {
    
    func toDigits() -> [Int] {
        return compactMap { Int(String($0)) }
    }
    
    func decimalDigits() -> String {
        let charset = CharacterSet.decimalDigits
        return String(self.unicodeScalars.filter(charset.contains(_:)))
    }
    
    func latinLettersAndDigits() -> String {
        let digitsCharset = CharacterSet.decimalDigits
        let latinCharset = CharacterSet.latinLetters
        return String(
            self.unicodeScalars.filter { scalar -> Bool in
                return digitsCharset.contains(scalar) || latinCharset.contains(scalar)
            }
        )
    }
    
    // Conflict with file String + Extension in Library dir!!!
    func myInserting(separator: String, every counter: Int) -> String {
        let result = enumerated().reduce("") { char, tuple -> String in
            return tuple.offset != 0 && tuple.offset % counter == 0
                ? (char + separator + String(tuple.element))
                : (char + String(tuple.element))
        }
        return result
    }
    
    /// Format string represented amount to splitted;
    ///
    /// Example: "1000000.5" will be formatted to "1 000 000.50"
    public var splittedAmount: String? {
        let amountString = replacingOccurrences(of: ",", with: ".")
        guard let amount = Double(amountString) else { return nil }
        let number = NSNumber(value: amount)
        let numberFormatter = NumberFormatter()
        numberFormatter.decimalSeparator = "."
        numberFormatter.groupingSeparator = " "
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(from: number)
    }
    
    /// Convert String to Date with specified format
    ///
    /// - Parameter dateFormat: Date representation format
    /// - Returns: String as Date object
    public func date(withFormat dateFormat: DateFormat) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat.string
        return dateFormatter.date(from: self)
    }
    
    public func time(withFormat dateFormat: DateFormat) -> Date? {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateFormat = dateFormat.string
        return formatter.date(from: self)
        
    }
    
    // substring by range (s = 'qwerty'; s[0..<3] will be 'qwe')
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
}
