//
//  TextFieldViewCellDelegate.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/3/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation

protocol TextFieldViewCellDelegate: class {
    func update(description: String, forCellAt indexPath: IndexPath)
    func shouldBeginEditing(description: String, forCellAt indexPath: IndexPath)
    func didBeginEditing(description: String, forCellAt indexPath: IndexPath)
    func didEndEditing(description: String, forCellAt indexPath: IndexPath)
    func didPressOptionalActionKeyboardButton(description: String, forCellAt indexPath: IndexPath)
    func update(optionalDescription: String, forCellAt indexPath: IndexPath)
}

extension TextFieldViewCellDelegate {
    func update(description: String, forCellAt indexPath: IndexPath) {}
    func shouldBeginEditing(description: String, forCellAt indexPath: IndexPath) {}
    func didBeginEditing(description: String, forCellAt indexPath: IndexPath) {}
    func didEndEditing(description: String, forCellAt indexPath: IndexPath) {}
    func didPressOptionalActionKeyboardButton(description: String, forCellAt indexPath: IndexPath) {}
    func update(optionalDescription: String, forCellAt indexPath: IndexPath) {}
}
