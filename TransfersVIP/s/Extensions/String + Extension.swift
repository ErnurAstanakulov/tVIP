//
//  String + extension.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 3/3/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import UIKit

extension String {
    
    func nullifyIfEmpty() -> String? {
        return self.isEmpty ? nil : self
    }
    
    func removeLastChar() -> String {
        return self.substring(to: self.index(before: self.endIndex))
    }
    
    func nsRange(from range: Range<String.Index>) -> NSRange? {
        guard let from = range.lowerBound.samePosition(in: utf16),
            let to = range.upperBound.samePosition(in: utf16) else {
        return nil
        }
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from),
                       length: utf16.distance(from: from, to: to))
    }

    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location + nsRange.length, limitedBy: utf16.endIndex),
            let from = from16.samePosition(in: self),
            let to = to16.samePosition(in: self)
            else { return nil }
        return from ..< to
    }
    
    func inserting(separator: String, every n: Int) -> String {
        var result: String = ""
        let characters = Array(self.characters)
        stride(from: 0, to: characters.count, by: n).forEach {
            result += String(characters[$0..<min($0+n, characters.count)])
            if $0+n < characters.count {
                result += separator
            }
        }
        return result
    }
    
    func date(format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date
    }
    
    func getDateGMT(format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        return dateFormatter.date(from: self)
    }
    
    func sizeForFont(_ font: UIFont) -> CGSize {
        return self.sizeForFont(font)
    }
    
    func widthForFont(_ font: UIFont) -> CGFloat {
        return self.sizeForFont(font).width
    }
    
    func heightForFont(_ font: UIFont) -> CGFloat {
        return self.sizeForFont(font).height
    }
    
    // Check character for Lation alphabet with regex pattern
    
    func isLatin() -> Bool {
        let latinRegex = "^[a-zA-Z.,0-9$@$!/%*?&#-_ +()|]+$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", latinRegex)
        return predicate.evaluate(with: self)
    }
    
    var toJSON: AnyObject? {
        if let data = data(using: .utf8, allowLossyConversion: false) {
            return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as AnyObject
        }
        return nil
    }
    
    func trim() -> String {
        return self.replacingOccurrences(of: "\\s", with: "", options: .regularExpression)
    }
    
    /// Encode a String to Base64
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    var attributedHtmlString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8),
                                          options: [
                                            .documentType: NSAttributedString.DocumentType.html,
                                            .characterEncoding: String.Encoding.utf8.rawValue
                ], documentAttributes: nil)
        } catch {
            print("Error:", error)
            return nil
        }
    }
}

