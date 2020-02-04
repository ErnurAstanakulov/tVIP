//
//  SimpleTextValidator.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/4/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation

class SimpleTextValidator: TextValidator {
    
    let maxCharCount: Int
    init (maxCharCount: Int) {
        self.maxCharCount = maxCharCount
    }
    
    func isValidCharacters(in text: String) -> Bool {
        return text.count <= maxCharCount
    }
}
