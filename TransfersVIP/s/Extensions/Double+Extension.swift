//
//  Double+Extension.swift
//  DigitalBank
//
//  Created by Saltanat Aimakhanova on 11/15/18.
//  Copyright © 2018 iosDeveloper. All rights reserved.
//

import Foundation

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Double {
    func toString(withMaxPlaceCount placeCount: Int) -> String {
        if truncatingRemainder(dividingBy: 1) == 0 {
            return String(Int(self))
        } else {
            return String(rounded(toPlaces: placeCount))
        }
    }
}
