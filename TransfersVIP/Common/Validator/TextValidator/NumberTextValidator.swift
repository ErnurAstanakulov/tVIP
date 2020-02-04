//
//  NumberTextValidator.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/3/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation

class NumberTextValidator: TextValidator {
    let pattern: String? = "^[0-9]+$"
    
    let range: ClosedRange<Int>?
    
    init(range: ClosedRange<Int>? = nil) {
        self.range = range
    }
    
    func isValidCharacters(in text: String) -> Bool {
        guard !text.isEmpty else {
            return false
        }
        
        guard let number = Int(text), String(number) == text else {
            return false
        }
        
        let validate = isValidFormat(for: text)
        guard let range = range else {
            return validate
        }
        return validate && (range ~= number)
    }
}
