//
//  ToolBar + Extension.swift
//  DigitalBank
//
//  Created by iosDeveloper on 7/28/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import UIKit

extension UIToolbar {
    
    static func toolbarPiker(target: Any, action: Selector) -> UIToolbar {
        
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Скрыть", style: UIBarButtonItem.Style.plain, target: target, action: action)
//        doneButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.untTextStyle5Font()!], for: .normal)
        doneButton.tintColor = UIColor.untGreyishBrownTwo
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
}
