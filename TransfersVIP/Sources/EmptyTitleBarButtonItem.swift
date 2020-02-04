//
//  EmptyTitleBarButtonItem.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 6/28/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

class EmptyTitleBarButtonItem: UIBarButtonItem {
    
    override init() {
        super.init()
        title = ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
