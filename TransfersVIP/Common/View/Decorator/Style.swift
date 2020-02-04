//
//  Style.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/10/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

struct Style {
    static func roundCorner() -> Decoration<UIView> {
        return { view in
            view.layoutIfNeeded()
            view.layer.cornerRadius = view.bounds.height / 2
            view.layer.masksToBounds = true
        }
    }
    
    static func corner(radius: CGFloat) -> Decoration<UIView> {
        return { (view: UIView) in
            view.layoutIfNeeded()
            view.layer.cornerRadius = radius
        }
    }
    
    static func round() -> Decoration<UIView> {
        return { (view: UIView) in
            view.layoutIfNeeded()
            view.layer.cornerRadius = view.bounds.height / 2
        }
    }
    
    static func shadow() -> Decoration<UIView> {
        return { (view: UIView) in
            view.layoutIfNeeded()
            view.layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
            view.layer.shadowOffset = CGSize(width: 0, height: 3)
            view.layer.shadowOpacity = 1.0
            view.layer.shadowRadius = 4
            view.layer.masksToBounds = false
        }
    }
    
    static func border(width: CGFloat) -> Decoration<UIView> {
        return { (view: UIView) in
            view.layoutIfNeeded()
            view.layer.borderColor = AppColor.light.uiColor.cgColor
            view.layer.borderWidth = width
        }
    }
}
