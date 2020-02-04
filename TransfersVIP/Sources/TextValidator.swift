//
//  TextValidator.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/3/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation

protocol TextValidator {
    
    /// Patternt for format validation
    var pattern: String? { get }
    
    /// Custom validation rule method
    var customRule: (_ text: String) -> Bool { get }
    
    /// Method to check if characters of the text are allowed
    ///
    /// - Parameter text: text to validate
    /// - Returns: `true` if text has been passed validation, otherwise `false`
    func isValidCharacters(in text: String) -> Bool
    
    /// Method to check if text satisfies the format
    ///
    /// - Parameter text: text to validate
    /// - Returns: `true` if text has been passed validation, otherwise `false`
    func isValidFormat(for text: String) -> Bool
    
    /// Method to check custom validation rule
    ///
    /// - Parameter text: text to validate
    /// - Returns: custom validation rule result
    func isValidCustomRule(for text: String) -> Bool
}

extension TextValidator {
    
    var pattern: String? { return nil }
    
    var customRule: (_ text: String) -> Bool {
        return { _ in true }
    }
    
    func isValidFormat(for text: String) -> Bool {
        guard let pattern = pattern else { return true }
        
        let regex: NSRegularExpression
        do {
            regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        } catch {
            return false
        }
        
        let range = NSRange(location: 0, length: text.count)
        return regex.firstMatch(in: text, range: range) != nil
    }
    
    func isValidCustomRule(for text: String) -> Bool {
        return customRule(text)
    }
}
