//
//  FontProtocol.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/12/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

protocol FontProtocol {
    var uiFont: UIFont { get }
}

extension FontProtocol {
    func with(size: CGFloat) -> UIFont {
        return uiFont.withSize(size)
    }
}
