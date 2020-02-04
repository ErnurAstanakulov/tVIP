//
//  CurrencyType.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 8/1/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation

enum CurrencyType: String, Equatable, CaseIterable {
    case usd = "USD"
    case kgs = "KGS"
    case rub = "RUB"
    case eur = "EUR"
    case gbp = "GBP"
    case kzt = "KZT"
    case chf = "CHF"
    case czk = "CZK"
    case aud = "AUD"
    case cad = "CAD"
    case aed = "AED"
    case jpy = "JPY"
    case cny = "CNY"
}

extension CurrencyType {
    
    var currencyCode: String { return rawValue }
    
    var symbol: String {
        switch self {
        case .kzt: return "₸"
        case .eur: return "€"
        case .gbp: return "£"
        case .kgs: return "C"
        case .rub: return "₽"
        case .usd: return "$"
        case .chf: return "₣"
        case .cny: return "¥"
        default: return rawValue
        }
    }
    
    var emoji: String {
        switch self {
        case .kzt: return "🇰🇿"
        case .eur: return "🇪🇺"
        case .gbp: return "🇬🇧"
        case .kgs: return "🇰🇬"
        case .rub: return "🇷🇺"
        case .usd: return "🇺🇸"
        case .chf: return "🇸🇪"
        case .czk: return "🇨🇿"
        case .aud: return "🇦🇺"
        case .cad: return "🇨🇦"
        case .aed: return "🇦🇪"
        case .jpy: return "🇯🇵"
        case .cny: return "🇨🇳"
        }
    }
    
    init(currencyCode: String) {
        if let currencyType = CurrencyType(rawValue: currencyCode) {
            self = currencyType
        } else {
            fatalError("Unexpected \"currencyCode\" value")
        }
    }
}
