//
//  UILabel + Extension.swift
//  DigitalBank
//
//  Created by iosDeveloper on 7/31/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import UIKit

extension UILabel {
    func getHeight() -> CGFloat {
        let constraint = CGSize(width: self.frame.size.width, height: CGFloat.greatestFiniteMagnitude)
        let context = NSStringDrawingContext()
        let boundingBox: CGSize? = self.text?.boundingRect(with: constraint, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.font], context: context).size
        let size = CGSize(width: ceil(boundingBox?.width ?? 0), height: ceil(boundingBox?.height ?? 0))
        return size.height
    }
}
