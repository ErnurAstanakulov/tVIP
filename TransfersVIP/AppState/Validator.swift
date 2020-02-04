//
//  Validator.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 2/27/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import UIKit

struct Validator {
    
    // MARK: General length validation
    
    static func validateLength(stirng: String, validator: Int) -> Bool {
        return stirng.count == validator
    }
    
    // MARK: INN Validation
    
    public enum INNValidationError: Error {
        case toShort(description: String)
        case toLong(description: String)
        case unacceptable(description: String)
        case notValid(description: String)
    }
    
    static func descriptionINNError(_ error: INNValidationError) -> String {
        switch error {
            case .toShort(description: let description): return description
            case .toLong(description: let description): return description
            case .unacceptable(description: let description): return description
            case .notValid(description: let description): return description
        }
    }
    
    static func validateINN(_ INN: String?) throws -> Bool {
        guard let INN = INN, !INN.isEmpty  else {
            throw INNValidationError.toShort(description: "Обязательное поле!")
        }
        return true
    }
    
    // MARK: IBAN Validation
    
    public enum IBANValidationError: Error {
        case notValidLength(description: String)
        case unacceptableSymbols(description: String)
    }
    
    public static func descriptionIBANError(_ error: IBANValidationError) -> String {
        switch error {
        case .notValidLength(description: let description): return description
        case .unacceptableSymbols(description: let description): return description
        }
    }
    
    public static func validateInternationalIBAN(iban: String?) throws -> Bool {
        guard let iban = iban, !iban.isEmpty, iban.count < 34 else {
            throw IBANValidationError.notValidLength(description: "IBAN должен содержать до 34 символов")
        }
    
//        let prepare = self.iso13616Prepare(iban: iban)
//        let resultValue = self.iso7064Mod97_10(iban: prepare)
//        return resultValue == 1
        return true
    }
    
    public static func validateIBAN(iban: String?) throws -> Bool {
        //проверить на КЗ
        guard let iban = iban, iban.count == 20 else {
            throw IBANValidationError.notValidLength(description: "IBAN должен содержать 20 символов")
        }
        
        let validator = "^[a-zA-Z0-9]+$"
        if !self.validateString(string: iban, RegEx: validator) {
            throw IBANValidationError.unacceptableSymbols(description: "Содержит не допустимые значения")
        }

        let prepare = self.iso13616Prepare(iban: iban)
        let resultValue = self.iso7064Mod97_10(iban: prepare)
        return resultValue == 1
    }
    
    public static func isValidEmail(email: String?) -> Bool {
        guard let email = email, !email.isEmpty  else { return false }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: email)
    }
    
    public static func validateKBE(_ kbe: String?) -> Bool {
        guard let kbe = kbe, !kbe.isEmpty else { return false }
        let kbeRegEx = "^[1-2]+[0-9, A]"
        let predicate = NSPredicate(format:"SELF MATCHES %@", kbeRegEx)
        return predicate.evaluate(with: kbe)
    }
    
    // MARK: Private func
    
    static private func validateString(string: String, RegEx: String) -> Bool {
        let predicate = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return predicate.evaluate(with: string)
    }
    
    public static func iso13616Prepare(iban: String) -> String {
        var stringToReturn = ""
        
        let ibanUp = iban.uppercased()
        
        let indexFour = ibanUp.index(ibanUp.startIndex, offsetBy: 4)
        let newIban = ibanUp.substring(from: indexFour) + ibanUp.substring(to: indexFour)
        
        for character: Character in newIban.characters {
            let indexCheck = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
            let index = indexCheck.characters.index(of: character)!
            let length = indexCheck.distance(from: indexCheck.startIndex, to: index)
            stringToReturn.append(String(length))
        }
        
        return stringToReturn
    }
    
    public static func iso7064Mod97_10(iban: String) -> Int {
        var remainder = iban
        var block: String!
        
        while remainder.count > 2 {
            let lenth = remainder.count
            let index = remainder.count < 9 ? lenth : 9
            let indexFour = remainder.index(remainder.startIndex, offsetBy: index)
            block = remainder.substring(to: indexFour)
            
            let blockCount = block.count
            let indexFrom = remainder.index(remainder.startIndex, offsetBy: blockCount)
            
            remainder = String(Int(block, radix: 10)! % 97) + remainder.substring(from: indexFrom)
        }
        
        return Int(remainder, radix: 10)! % 97
    }
    
    // MARK: Validating by constraint
    
    @discardableResult
    public static func validate(textField: UITextField, errorLabel: UILabel, constraint: BaseConstraint?) -> Bool {
        guard let constraint = constraint else {
            processValidationResult(isValid: true, allertLabel: errorLabel, alletMessage: nil)
            return true
        }
        let text = textField.text
        let error = validatingError(text: text, constraint: constraint)
        let isValid = (error == nil)
        processValidationResult(isValid: isValid, allertLabel: errorLabel, alletMessage: error)
        return isValid
    }
    
    @discardableResult
    public static func validate(switcher: UISwitch, errorLabel: UILabel, constraint: BaseConstraint?) -> Bool {
        guard let constraint = constraint else {
            processValidationResult(isValid: true, allertLabel: errorLabel, alletMessage: nil)
            return true
        }
        let isOn = switcher.isOn
        let error = validate(isFilled: isOn, constraint: constraint)
        let isValid = (error == nil)
        processValidationResult(isValid: isValid, allertLabel: errorLabel, alletMessage: error)
        return isValid
    }
    
    private static func processValidationResult(isValid: Bool, allertLabel: UILabel, alletMessage message: String? = "") {
        allertLabel.isHidden = isValid
        allertLabel.text = isValid ? nil : message
    }
    
    public static func validate(isFilled: Bool, constraint: BaseConstraint) -> String? {
        guard let isRequired = constraint.isRequired, isRequired else { return nil }
        return !isFilled ? "Обязательное поле!" : nil
    }
    
    // nil = textField is valide
    public static func validatingError(text: String?, constraint: BaseConstraint) -> String? {
        
        let text = text ?? ""
        
        let isEmpty = text.isEmpty
        
        if let required = constraint.isRequired, required && isEmpty {
            return "Обязательное поле!"
        }
        
        if isEmpty {
            return nil // FROM WEB: by default field is not required
        }
        
        let textLength = text.count
        
        if let pattern = constraint.regexpr, !pattern.isEmpty {
            if self.test(text: text, pattern: pattern) == false {
                return "Данные введены некорректно"
            }
        }
        
        if let patternTemplate = constraint.regexp, !patternTemplate.isEmpty {
            guard let pattern = self.getPatternFromTemplate(template: patternTemplate) else { return "" }
            if self.test(text: text, pattern: pattern) == false {
                return "Данные введены некорректно"
            }
        }
        
        if let maxLength = constraint.maxLength {
            if textLength > maxLength {
                return "Поле должно быть не больше \(maxLength) символов"
            }
        }
        
        if let minLength = constraint.minLength {
            if textLength < minLength {
                return "Поле должно быть не меньше \(minLength) символов"
            }
        }
        
        if let length = constraint.length {
            if textLength != length {
                return "Поле должно быть длиной в \(length) символов"
            }
        }
        
        if let isEmail = constraint.email, isEmail == true {
            let pattern = "^(?:(?:[\\w`~!#$%^&*\\-=+;:{}'|,?\\/]+(?:(?:\\.(?:\"(?:\\?[\\w`~!#$%^&*\\-=+;:{}'|,?\\/\\.()<>\\[\\] @]|\\\"|\\\\)*\"|[\\w`~!#$%^&*\\-=+;:{}'|,?\\/]+))*\\.[\\w`~!#$%^&*\\-=+;:{}'|,?\\/]+)?)|(?:\"(?:\\?[\\w`~!#$%^&*\\-=+;:{}'|,?\\/\\.()<>\\[\\] @]|\\\"|\\\\)+\"))@(?:[a-zA-Z\\d\\-]+(?:\\.[a-zA-Z\\d\\-]+)*|\\[\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\])$"
            if self.test(text: text, pattern: pattern) == false {
                return "Некорректный адрес электронной почты"
            }
        }
        
        if let isPassword = constraint.password, isPassword == true {
            let pattern = "/(?=^.{2,}$)((?=.*\\d)|(?=.*\\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z])(?=.*[!@#$]).*$/g"
            if self.test(text: text, pattern: pattern) == false {
                return "Некорректный пароль"
            }
        }
        
        if let isTaxCode = constraint.taxCode, isTaxCode == true {
            do {
                let isValid = try validateINN(text)
                if !isValid {
                    return "Не валидный ИНН"
                }
            } catch let error as INNValidationError {
                return descriptionINNError(error)
            } catch {
                return "Нераспознанная ошибка"
            }
        }
        
        if let isAccount = constraint.account, isAccount == true {
            do {
                let isValid = try validateIBAN(iban: text)
                if !isValid {
                    return "Невалидный номер счета"
                }
            } catch let error as IBANValidationError {
                return descriptionIBANError(error)
            } catch {
                return "Нераспознанная ошибка"
            }
        }
        
        if let isAmount = constraint.amount, isAmount == true {
            guard let value = Double(text), value > 0 else {
                return "0 недопустимо"
            }
        }
        
        if let regExchangeRate = constraint.regExchangeRate, !regExchangeRate.isEmpty {
            if self.test(text: text, pattern: regExchangeRate) == false {
                return "Некорректный курс сделки"
            }
        }
        
        if let isGreaterThanZero = constraint.greaterThanZero, isGreaterThanZero == true {
            guard let value = Double(text), value > 0 else {
                return "0 недопустимо"
            }
        }
        
        if let isAmountNotNull = constraint.amountNotNull, isAmountNotNull == true {
            guard let value = Double(text), value > 0 else {
                return "0 недопустимо"
            }
        }
        
        if let isSelected = constraint.selected, isSelected == true {
            if textLength == 0 {
                return "Пожалуйста, выберите значение из списка"
            }
        }
        
        if let hasProperty = constraint.hasProperty, !hasProperty.isEmpty {
        }
        
        if let disabledNames = constraint.disabledNames, disabledNames.count > 0 {
            if let contained = disabledNames.first(where: { $0.lowercased() == text.lowercased() }) {
                return "Не должно содержать \"\(contained)\""
            }
        }
        
        return nil
    }
    
    static func test(text: String, pattern: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            return regex.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.count)) != nil
        } catch {
            return false
        }
    }
    
    static func getPatternFromTemplate(template: String) -> String? {
        switch template {
        case "lettersOrDash":
            return "^[\\pL-әіңғүұқөһӘІҢҒҮҰҚӨҺ. ]*$"
        case "phone":
            return "^[0-9+]+$"
        case "numbers":
            return "^[0-9]+$"
        case "numbersAndPoints":
            return "^[0-9.]+$"
        case "date":
            return "^[0-3][0-9][.][0-1][0-9][.][0-9]{4}?$"
        case "numbersWithotLeadingZero":
            return "^([1-9][0-9]{0,10})$"
        case "letterAndNumbers":
            return "^[a-zA-Z0-9]+$"
        case "letters":
            return "^[a-zA-Z]+$"
        case "upperLetterAndNumbers":
            return "^[A-Z0-9]+$"
        case "vinCode":
            return "^[A-Z0-9]+$"
        case "amount":
            return "^[0-9 ]+([.][0-9|]{1,2})?$"
        case "exchangeRate":
            return "^[0-9]+([.][0-9|]{1,4})?$"
        case "residencyCode":
            return "^[1-2]+[0-9]"
        case "KZTAccount":
            return "^[KZ]+[a-zA-Z0-9]+$"
        case "name":
            return "^[ ,а-яА-ЯёЁa-zA-Z,-,әіңғүұқөӘІҢҒҮҰҚӨ]+$"
        case "shortName":
            return "^[ ,а-яА-ЯёЁa-zA-Z,-.,әіңғүұқөӘІҢҒҮҰҚӨ]+$"
        case "password":
            return "/(?=^.{2,}$)((?=.*\\d)|(?=.*\\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$/g"
        case "link":
            return "/((([A-Za-z]{3,9}:(?:\\/\\/)?)(?:[\\-;:&=\\+\\$,\\w]+@)?[A-Za-z0-9.-]+|(?:www.|[\\-;:&=\\+\\$,\\w]+@)[A-Za-z0-9.\\-]+)((?:\\/[\\+~%\\/\\.\\w\\-_]*)?\\??(?:[\\-\\+=&;%@\\.\\w_]*)#?(?:[\\.\\!\\/\\\\w]*))?)/"
        default:
            return nil
        }
    }
}
