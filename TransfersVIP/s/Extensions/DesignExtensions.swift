//
//  DesignExtensions.swift
//  DigitalBank
//
//  Created by Misha Korchak on 08.06.17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import UIKit

// Color palette

extension UIColor {
    class var untBlack: UIColor {
        return UIColor(red: 32.0 / 255.0, green: 26.0 / 255.0, blue: 25.0 / 255.0, alpha: 1.0)
    }
    
    class var untGreyishBrownTwo: UIColor {
        return UIColor(red: 99.0 / 255.0, green: 89.0 / 255.0, blue: 87.0 / 255.0, alpha: 1.0)
    }
    
    class var mainOrange: UIColor {
        return UIColor(red: 255, green: 161, blue: 13, alpha: 1)
    }
    
    class var mainGrey: UIColor {
        return UIColor(red: 244, green: 241, blue: 239, alpha: 1)
    }
}

// Text styles

extension UIFont {
    class func untTextStyleFont() -> UIFont? {
        return UIFont.systemFont(ofSize: 16)
    }
    
    class func untTextStyle2Font() -> UIFont? {
        return UIFont.systemFont(ofSize: 16)
    }
    
    class func untTextStyle4Font() -> UIFont? {
        return UIFont.systemFont(ofSize: 13.3)
    }
    
    class func untTextStyle3Font() -> UIFont? {
        return UIFont.systemFont(ofSize: 12)
    }
    
    class func untTextStyle5Font() -> UIFont? {
        return UIFont.systemFont(ofSize: 14)
    }
}
