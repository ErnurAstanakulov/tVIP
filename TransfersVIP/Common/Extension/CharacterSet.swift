//
//  CharacterSet.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/4/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation

extension CharacterSet {
    
    static var latinLetters: CharacterSet {
        let characterString = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
        return CharacterSet(charactersIn: characterString)
    }
    
    static var vehicleIdentificationNumberSymbols: CharacterSet {
        var characterSet = CharacterSet.latinLetters.union(.decimalDigits)
        characterSet.remove(charactersIn: "IiOoQq")
        return characterSet
    }
}

