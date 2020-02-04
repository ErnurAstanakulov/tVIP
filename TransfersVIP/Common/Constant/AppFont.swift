//
//  AppFont.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/12/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

enum AppFont {
    case light
    case regular
    case semibold
}

extension AppFont: FontProtocol {
    var uiFont: UIFont {
        switch self {
        case .light:
            return UIFont(name: "OpenSans-Light", size: 16) ?? .systemFont(ofSize: 16, weight: .light)
        case .regular:
            return UIFont(name: "OpenSans-Regular", size: 16) ?? .systemFont(ofSize: 16, weight: .regular)
        case .semibold:
            return UIFont(name: "OpenSans-Semibold", size: 16) ?? .systemFont(ofSize: 16, weight: .semibold)
        }
    }
}
