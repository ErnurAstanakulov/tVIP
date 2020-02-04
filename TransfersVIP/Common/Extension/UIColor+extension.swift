//
//  UIColor+extension.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/5/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

extension UIColor {
    
    /// Initialize from integral RGB values (+ alpha channel in range 0-100)
    convenience init(rgb: UInt8..., alpha: UInt = 100) {
        self.init(
            red:   CGFloat(rgb[0]) / 255.0,
            green: CGFloat(rgb[1]) / 255.0,
            blue:  CGFloat(rgb[2]) / 255.0,
            alpha: CGFloat(min(alpha, UInt(100))) / 100.0
        )
    }
}
