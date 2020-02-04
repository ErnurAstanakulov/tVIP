//
//  ToggleContentCell.swift
//  Payments
//
//  Created by Zhalgas Baibatyr on 23/04/2018.
//

import UIKit

class ToggleContentView: UIView {
    
    private var stackView = UIStackView()
    
    var titleLabel = UILabel()
    var toggle = UISwitch()
    var subtitleLabel = UILabel()
    
    var performOnSwitch: ((_ isOn: Bool) -> Void)?
    
    var errorDescription: String? {
        set {
            subtitleLabel.text = newValue
            if let errorStr = newValue, !errorStr.isEmpty {
                stackView.addArrangedSubview(subtitleLabel)
            } else {
                stackView.removeArrangedSubview(subtitleLabel)
            }
        }
        get {
            return subtitleLabel.text
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
    
    @objc private func switchChanged(sender: UISwitch!) {
        performOnSwitch?(sender.isOn)
    }
}

extension ToggleContentView: ViewInitalizationProtocol {
    func addSubviews() {
        addSubview(stackView)
        addSubview(toggle)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
    }
    
    func setupConstraints() {
        var layoutConstratins = [NSLayoutConstraint]()
        
        stackView.addConstaintsToVertical(padding: 8)
        layoutConstratins += [
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            stackView.trailingAnchor.constraint(equalTo: toggle.leadingAnchor, constant: -8)
        ]
        
        toggle.addConstaintsToVertical(padding: 8)
        layoutConstratins += [
            toggle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25)
        ]
        
        NSLayoutConstraint.activate(layoutConstratins)
    }
    
    func stylizeViews() {
        backgroundColor = .clear
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        
        titleLabel.textColor = AppColor.dark.uiColor
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.font = AppFont.light.with(size: 14)
        titleLabel.numberOfLines = 0
        
        subtitleLabel.textColor = UIColor.darkGray
        subtitleLabel.font = AppFont.regular.with(size: 14)
        
        toggle.onTintColor = UIColor.green
        toggle.tintColor = UIColor.green
    }
    
    func extraTasks() {
        toggle.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
    }
}
