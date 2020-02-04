//
//  IINValidator.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/4/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation

class IINValidator: TextValidator {
    func isValidCharacters(in text: String) -> Bool {
        return isValidFormat(for: text)
    }
    
    func isValidFormat(for text: String) -> Bool {
        let iin: [Int] = text.toDigits()
        
        guard iin.count == 12 else {
            return false
        }
        
        switch iin[4] {
        case 0...3:
            let dateFormatterFromSM: DateFormatter = {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyMMdd"
                return dateFormatter
            }()
            if dateFormatterFromSM.date(from: String(text.prefix(6))) == nil {
                return false
            }
        case 4...6:
            break
        default:
            return false
        }
        
        let firstIINValidator =  [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
        let firstResult = zip(iin, firstIINValidator).map({ $0 * $1 }).reduce(0, +)
        
        var checkDigit = firstResult % 11
        
        if checkDigit == 10 {
            let secondIINValidator =  [3, 4, 5, 6, 7, 8, 9, 10, 11, 1, 2]
            let secondResult = zip(iin, secondIINValidator).map({ $0 * $1 }).reduce(0, +)
            
            checkDigit = secondResult % 11
        }
        
        guard checkDigit == iin[11] else {
            return false
        }
        
        return true
    }
}
