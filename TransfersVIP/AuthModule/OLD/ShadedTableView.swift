//
//  ShadedTableView.swift
//  DigitalBank
//
//  Created by Vlad on 20.07.17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import UIKit

class ShadedTableView: UITableView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        prepare()
    }
    
    func prepare() {
        estimatedRowHeight = 70.0
        rowHeight = 70.0
        contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        separatorStyle = .singleLine
        separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
        backgroundColor = UIColor.colorFromHex(hex: "#F4F1EF")
        
        //Add shadow for all cells/headers/footers
        guard let wrapperView = subviews.first else { return }
        wrapperView.layer.shadowColor = UIColor.colorFromHex(hex: "#1b2434").cgColor
        wrapperView.layer.shadowOffset = CGSize(width: 0, height: 1)
        wrapperView.layer.shadowRadius = 4.0
        wrapperView.layer.shadowOpacity = 0.15
        wrapperView.layer.shouldRasterize = true
        wrapperView.layer.rasterizationScale = UIScreen.main.scale
        
        let view = UIView()
        view.backgroundColor = .clear
        tableFooterView = view
    }
}
