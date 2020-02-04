//
//  ComponentUIProperty.swift
//  DigitalBank
//
//  Created by Zhalgas Baibatyr on 28/05/2018.
//  Copyright © 2018 iosDeveloper. All rights reserved.
//

import Foundation

enum ComponentUIProperty {
    case autocapitalizationType(UITextAutocapitalizationType)
    case useMonthAndYearDateFormat(Bool)
    case isUserInteractionEnabled(Bool)
    case isMultiLineEnabled(Bool)
    case isBlockedAccountFillTextColor(UIColor)
    
    func isEqual(property: ComponentUIProperty) -> Bool {
        switch (self, property) {
        case (.autocapitalizationType(_), .autocapitalizationType(_)):
            return true
        case (.useMonthAndYearDateFormat(_), .useMonthAndYearDateFormat(_)):
            return true
        case (.isUserInteractionEnabled(_), .isUserInteractionEnabled(_)):
            return true
        case (.isMultiLineEnabled(_), .isMultiLineEnabled(_)):
            return true
        case (.isBlockedAccountFillTextColor(_), .isBlockedAccountFillTextColor(_)):
            return true
        default:
            return false
        }
    }
}

extension ComponentUIProperty: Equatable {
    
    public static func == (lhs: ComponentUIProperty, rhs: ComponentUIProperty) -> Bool {
        switch (lhs, rhs) {
        case let (.autocapitalizationType(leftValue), .autocapitalizationType(rightValue)):
            return leftValue == rightValue
        case let (.useMonthAndYearDateFormat(leftValue), .useMonthAndYearDateFormat(rightValue)):
            return leftValue == rightValue
        case let (.isUserInteractionEnabled(leftValue), .isUserInteractionEnabled(rightValue)):
            return leftValue == rightValue
        case let (.isMultiLineEnabled(leftValue), .isMultiLineEnabled(rightValue)):
            return leftValue == rightValue
        default:
            return false
        }
    }
    
}
