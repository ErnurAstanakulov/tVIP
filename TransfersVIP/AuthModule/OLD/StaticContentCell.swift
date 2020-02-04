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
//
//  StaticContentCell.swift
//  Payments
//
//  Created by Zhalgas Baibatyr on 23/04/2018.
//

import UIKit

class StaticContentView: UIView {
    
    let titleLabel = UILabel()
    let valueLabel = UILabel()
    let errorLabel = UILabel()
    let iconImageView = UIImageView()
    let stackView = UIStackView()
    
    var title: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
            if let text = newValue,
                !text.isEmpty {
                if !stackView.arrangedSubviews.contains(titleLabel) {
                    stackView.addArrangedSubview(titleLabel)
                }
            } else {
                stackView.removeArrangedSubview(titleLabel)
            }
        }
    }
    
    var value: String? {
        get {
            return valueLabel.text
        }
        set {
            valueLabel.text = newValue
            if let text = newValue,
                !text.isEmpty {
                if !stackView.arrangedSubviews.contains(valueLabel) {
                    stackView.addArrangedSubview(valueLabel)
                }
            } else {
                stackView.removeArrangedSubview(valueLabel)
            }
        }
    }
    
    var error: String? {
        get {
            return errorLabel.text
        }
        set {
            errorLabel.text = newValue
            if let text = newValue,
                !text.isEmpty {
                if !stackView.arrangedSubviews.contains(errorLabel) {
                    stackView.addArrangedSubview(errorLabel)
                }
            } else {
                stackView.removeArrangedSubview(errorLabel)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        setupViews()
    }
}

extension StaticContentView: ViewInitalizationProtocol {
    func addSubviews() {
        addSubview(stackView)
        addSubview(iconImageView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(valueLabel)
    }
    
    func setupConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            iconImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -26),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 12),
            iconImageView.heightAnchor.constraint(equalToConstant: 12)
        ]
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 26),
            stackView.rightAnchor.constraint(equalTo: iconImageView.leftAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    func stylizeViews() {
        backgroundColor = .clear
        isUserInteractionEnabled = false
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        
        iconImageView.contentMode = .scaleAspectFit
        
        titleLabel.textColor = AppColor.dark.uiColor
        titleLabel.font = AppFont.light.with(size: 14)
        titleLabel.numberOfLines = 0
        
        valueLabel.isUserInteractionEnabled = false
        valueLabel.textColor = AppColor.green.uiColor
        valueLabel.font = AppFont.regular.with(size: 16)
        valueLabel.backgroundColor = .clear
        valueLabel.tintColor = UIColor.green
        valueLabel.numberOfLines = 0
        valueLabel.lineBreakMode = .byWordWrapping
        
        errorLabel.textColor = UIColor.red
        errorLabel.font = AppFont.light.with(size: 14)
        errorLabel.numberOfLines = 0
    }
}
