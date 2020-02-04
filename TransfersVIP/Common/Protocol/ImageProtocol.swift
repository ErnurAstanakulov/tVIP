//
//  ImageProtocol.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/4/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

/// Protocol to access image from bundle
/// For **enum** extension with raw type **String**
public protocol ImageProtocol {
    
    /// Image asset value
    var rawValue: String { get }
    
    /// Image related bundle
    var bundle: Bundle? { get }
}

public extension ImageProtocol {
    
    /// Get value as **UIImage**
    var uiImage: UIImage? {
        if let bundle = bundle {
            return UIImage(named: rawValue, in: bundle, compatibleWith: nil)
        }
        return UIImage(named: rawValue)
    }
    
    /// Get value as **CGImage**
    var cgImage: CGImage? { return self.uiImage?.cgImage }
}
