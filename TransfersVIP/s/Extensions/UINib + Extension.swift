//
//  UIView + Extension.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 2/1/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import UIKit

public extension UINib {
    public class func view<T: UIView >(_ view: T.Type, owner: AnyObject? = nil) -> T? {
        let stringClass = String(describing: view)
        let nib = self.nibName(stringClass)
        let view = nib?.instantiate(withOwner: owner, options: nil).first as? T
        return view
    }
    
    public class func controller<T: UIViewController>(controller: T.Type, owner: AnyObject? = nil) -> T? {
        let stringClass = String(describing: controller)
        let nib = self.nibName(stringClass)
        let controller = nib?.instantiate(withOwner: owner, options: nil).first as? T
        return controller
    }
    
    public class func nibName(_ name: String) -> UINib? {
        return UINib(nibName: name, bundle: Bundle.main)
    }
}
