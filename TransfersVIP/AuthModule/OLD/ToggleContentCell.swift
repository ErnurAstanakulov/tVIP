//
//  ToggleContentCell.swift
//  DigitalBank
//
//  Created by Алем Утемисов on 06.05.2018.
//  Copyright © 2018 iosDeveloper. All rights reserved.
//

import UIKit

class ToggleContentCell: UITableViewCell {
    
    let toggleContentView = ToggleContentView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubview(toggleContentView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        toggleContentView.addConstaintsToFill()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
