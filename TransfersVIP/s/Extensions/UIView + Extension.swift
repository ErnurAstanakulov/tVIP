//
//  UIView + Extension.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 5/1/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import UIKit

extension UIView {
    //DESC: return snapshotView from self
    func snapshot() -> UIImageView {
        //Create the UIImage
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return UIImageView(image: image)
    }
    
    func xibContentView() -> UIView? {
        guard let contentView = loadViewFromNib() else { return nil }
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(contentView)
        
        return contentView
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let views = nib.instantiate(withOwner: self, options: nil)
        guard views.count > 0 else { return nil }
        let view = views[0] as? UIView
        
        return view
    }
    
    func applyBorderShadow() {
//        let frameLeyer = self.layer
//        frameLeyer.borderWidth = 0
//        frameLeyer.borderColor = UIColor.lightGray.cgColor
//
//        frameLeyer.shadowColor = UIColor.lightGray.cgColor
//        frameLeyer.shadowOpacity = 0.5
//        frameLeyer.shadowOffset = CGSize.zero
//        frameLeyer.shadowRadius = 2
//
//        frameLeyer.masksToBounds = false
    }
    
    private class func getAllSubviews<T: UIView>(view: UIView) -> [T] {
        return view.subviews.flatMap { subView -> [T] in
            var result = getAllSubviews(view: subView) as [T]
            if let view = subView as? T {
                result.append(view)
            }
            return result
        }
    }

    func getAllSubviews<T: UIView>() -> [T] {
        return UIView.getAllSubviews(view: self) as [T]
    }
    
}
