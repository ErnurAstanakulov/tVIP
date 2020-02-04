//
//  EmailValidator.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/3/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation

class EmailValidator: TextValidator {
    let pattern = Optional("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
    
    func isValidCharacters(in text: String) -> Bool {
        guard !text.isEmpty else { return true }
        let regex = "^[A-Z0-9a-z._%@+-]+$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)
    }
}
