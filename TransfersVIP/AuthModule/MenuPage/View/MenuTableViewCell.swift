//
//  MenuTableViewCell.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/12/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell, ReusableView {
    
    private var iconImageView = UIImageView()
    private var titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initialize()
    }
    
    
    
    private func initialize() {
        setupViews()
    }
}

extension MenuTableViewCell {
    var icon: UIImage? {
        get {
            return iconImageView.image
        }
        set {
            iconImageView.image = newValue
        }
    }
    
    var title: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }
}

extension MenuTableViewCell: ViewInitalizationProtocol {
    func addSubviews() {
        addSubview(iconImageView)
        addSubview(titleLabel)
    }
    
    func setupConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 36),
            iconImageView.heightAnchor.constraint(equalToConstant: 36)
        ]
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 13),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -30)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    func stylizeViews() {
        backgroundColor = .clear
        
        iconImageView.tintColor = AppColor.green.uiColor
        
        titleLabel.textColor = AppColor.gray.uiColor
        titleLabel.font = AppFont.semibold.uiFont
    }
}
