//
//  UIToolbar+extension.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/4/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

extension UIToolbar {
    static func inputAccessoryView(
        hideKeyboardTarget: Any,
        hideKeyboardAction: Selector,
        optionalActionTarget: Any,
        optionalActionAction: Selector
        ) -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = AppColor.dark.uiColor
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        let hideKeyboardBarButtonItem = UIBarButtonItem(
            image: AppImage.hideKeyboardIcon.uiImage?.fitted(in: CGSize(width: 25, height: 25)),
            style: .plain,
            target: hideKeyboardTarget,
            action: hideKeyboardAction
        )
        hideKeyboardBarButtonItem.imageInsets.left += 4
        
        let spaceBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        let optionalActiontBarButtonItem = UIBarButtonItem(
            title: nil,
            style: .plain,
            target: optionalActionTarget,
            action: optionalActionAction
        )
        optionalActiontBarButtonItem.setTitlePositionAdjustment(.init(horizontal: -10, vertical: 0), for: .default)
        
        let toolBarItems = [hideKeyboardBarButtonItem, spaceBarButtonItem, optionalActiontBarButtonItem]
        toolBar.setItems(toolBarItems, animated: false)
        
        return toolBar
    }
    
    func set(optionalActionButtonTitle: String?) {
        items?[2].isEnabled = !(optionalActionButtonTitle?.isEmpty ?? true)
        items?[2].title = optionalActionButtonTitle
    }
}
