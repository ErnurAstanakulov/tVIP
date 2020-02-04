//
//  TextView.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/3/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

class MTextView: UITextView {
    
    var canPaste = true

    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(paste(_:)) && !canPaste {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
}
