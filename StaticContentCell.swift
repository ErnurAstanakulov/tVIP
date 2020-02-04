//
//  StaticContentCell.swift
//  DigitalBank
//
//  Created by Алем Утемисов on 06.05.2018.
//  Copyright © 2018 iosDeveloper. All rights reserved.
//

import UIKit

class StaticContentCell: UITableViewCell {
    
    let staticContentView = StaticContentView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        setupViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        staticContentView.titleLabel.text = nil
        staticContentView.valueLabel.text = nil
        staticContentView.iconImageView.image = nil
    }
}

extension StaticContentCell: ViewInitalizationProtocol {
    func addSubviews() {
        addSubview(staticContentView)
    }
    
    func setupConstraints() {
        staticContentView.addConstaintsToFill()
    }
    
    func stylizeViews() {
        selectionStyle = .none
    }
}
