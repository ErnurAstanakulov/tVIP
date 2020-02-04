//
//  UITextField + Extensions.swift
//  DigitalBank
//
//  Created by iosDeveloper on 8/15/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import UIKit

extension UITextField {
    func amountCharacters(shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let sourceString = self.text else { return true }
        guard sourceString.count < 16 else {
            return string.isEmpty
        }
        let replacmentString = string.replacingOccurrences(of: ",", with: ".")
        let originString: NSString = sourceString as NSString
        let newString = originString.replacingCharacters(in: range, with: replacmentString)
        if (!sourceString.isEmpty && replacmentString == ".") {
            return !sourceString.contains(".") && sourceString.count < 15 ? true : false
        } else {
            self.text = newString.amountInputFormatting()
            return false
        }
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        inputAccessoryView = UIToolbar.toolbarPiker(target: self, action: #selector(resignFirstResponder))
    }
}

extension UITextField {
    func validatePhoneNumber(_ nextField: UITextField?, replacement string: String, in range: NSRange ) -> Bool {
        guard let text = self.text else { return false }
        let preparedString = range.location <= 3 ? text : (text as NSString).replacingCharacters(in: range, with: string)
        let newString = preparedString.replacingOccurrences(of: "+7", with: "")
        let components = (newString as NSString).components(separatedBy: NSCharacterSet.decimalDigits.inverted)
        let decimalString = components.joined(separator: "")
        let decimalCount = decimalString.count
        
        if decimalCount > 10 {
            self.resignFirstResponder()
            _ = nextField?.becomeFirstResponder()
            return false
        }
        
        let offset = decimalCount < 3 ? decimalCount : 3
        let index = decimalString.index(decimalString.startIndex, offsetBy: offset)
        let areaCode = decimalString[..<index]
        let remainder = decimalString[index...]
        
        if self.text?.count != 0 && (range.location <= 3) {
            let newPosition = decimalCount < 3 ? self.position(from: self.beginningOfDocument, offset: 4 + decimalCount) ?? self.endOfDocument : self.endOfDocument
            let cursorPosition = self.textRange(from: newPosition, to: newPosition)
            self.selectedTextRange = cursorPosition
            
            return false
        }
        
        
        self.text = "+7 (\(areaCode)) \(remainder)"
        
        var symbolsOffset = range.length <= 0 ? 1 : 0
        if areaCode.count == 3 && range.location == areaCode.count + 4 && range.length <= 0 {
            symbolsOffset += 2
        }
        
        if areaCode.count == 3 && range.location == areaCode.count + 6 && range.length > 0 {
            symbolsOffset += -2
        }
        
        let selfOffset = range.location + symbolsOffset
        let newPosition = self.position(from: self.beginningOfDocument, offset: selfOffset) ?? self.endOfDocument
        
        let cursorPosition = self.textRange(from: newPosition, to: newPosition)
        self.selectedTextRange = cursorPosition
        
        if decimalCount == 10 {
            self.resignFirstResponder()
            _ = nextField?.becomeFirstResponder()
        }
        
        return false
    }
}
