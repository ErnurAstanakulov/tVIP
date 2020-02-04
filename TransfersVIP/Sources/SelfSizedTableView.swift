//
//  SelfSizedTableView.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 8/6/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

class SelfSizedTableView: UITableView {
    var maxHeight: CGFloat = UIScreen.main.bounds.size.height
    
    override func reloadData() {
        super.reloadData()
        invalidateIntrinsicContentSize()
        layoutIfNeeded()
    }
    
    override var intrinsicContentSize: CGSize {
        let height = min(contentSize.height, maxHeight)
        return CGSize(width: contentSize.width, height: height)
    }
}

