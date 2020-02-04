//
//  DetailPickerView.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/3/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

class DetailPickerView: UIView {
    
//    var detail: Detail? {
//        didSet {
//            guard let detail = detail else { return }
//            titleLabel.text = detail.title
//            descriptionLabel.text = detail.description
//        }
//    }
    
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        stylize()
        addSubviews()
        setViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func stylize() {
        // stackView
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 2
        
        // titleLabel
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        
        // descriptionLabel
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .black
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
    }
    
    private func addSubviews() {
        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
    }
    
    private func setViewConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
}
