//
//  TextFieldCellInputType.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/3/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

enum TextFieldCellInputType {
    case keyboard(type: UIKeyboardType)
    case picker(components: [String], row: Int)
    case pickerDetailed(components: [Detail], row: Int)
    case datePicker
}
