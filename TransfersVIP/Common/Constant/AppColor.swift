//
//  AppColor.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/5/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

enum AppColor {
    case white
    case black
    case green
    case lightGray
    case light
    case title
    case gray
    case dark
    case lineColor
}

extension AppColor: ColorProtocol {
    var uiColor: UIColor {
        switch self {
        case .white:
            return UIColor(rgb: 255, 255, 255)
        case .black:
            return UIColor(rgb: 0, 0, 0)
        case .green:
            return UIColor(rgb: 42, 151, 63)
        case .lightGray:
            return UIColor(rgb: 229,229,229)
        case .light:
            return UIColor(rgb: 240, 240, 240)
        case .gray:
            return UIColor(rgb: 119, 119, 119)
        case .dark:
            return UIColor(rgb: 22, 22, 22)
        case .lineColor:
            return UIColor(rgb: 230, 230, 230)
        case .title:
            return UIColor(rgb: 196, 196, 196)
        }
    }
}
