//
//  MenuTabButton.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/5/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//


import UIKit

class MenuTabButton: UIView {
    
    var stackView = UIStackView()
    var iconImageView = UIImageView()
    var titleLabel = UILabel()
    
    convenience init() {
        self.init(frame: CGRect.zero)
        setupViews()
    }
}
extension MenuTabButton: ViewInitalizationProtocol {
    func addSubviews() {
        addSubview(stackView)
        
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(titleLabel)
    }
    
    func setupConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    func stylizeViews() {
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
    }
}
