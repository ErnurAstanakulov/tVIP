//
//  FieldType.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/3/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

enum FieldType: Equatable {
    case text(keyboardType: UIKeyboardType?)
    case secureText(keyboardType: UIKeyboardType)
    case date
    case picker(components: [String])
    case pickerDetail(titles: [String], descriptions: [String])
    case switcher
    case file
    case options(isMultiSelect: Bool)
    case button
    case label
    case alert
    case notification
}
