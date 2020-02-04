//
//  CurrencyImage.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/12/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

enum CurrencyImage: String, CaseIterable {
    case AUD
    case AED
    case USD
    case EUR
    case JPY
    case ESP
    case CAD
    case CNY
    case RUB
    case KZT
    case GBP
    case CHF
    case UAH
    case SWE
    case KGS
    case CZK
    case SGD
    case HRD
    case TRY
    case HUF
    case BYN
    case PLN
    case ZAR
    case AZN
    case GEL
    case DKK
    case INR
    case SAR
    case TJR
    case THB
    case UZS
    case KRW
    
    static func getBy(isoCode: String) -> CurrencyImage? {
        for currency in CurrencyImage.allCases {
            if (currency.rawValue == isoCode) {
                return currency
            }
        }
        return nil
    }
    
    func toCircle() -> UIImage? {
        return UIImage(named: self.rawValue + "_circle")
    }
}

extension CurrencyImage: ImageProtocol {
    var bundle: Bundle? {
        return nil
    }
}
