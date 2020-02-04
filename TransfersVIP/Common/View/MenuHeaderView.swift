//
//  MenuHeaderView.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/12/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

protocol MenuHeaderDelegate: class {
    func onPressBackButton()
}

extension MenuHeaderDelegate {
    func onPressBackButton() {}
}

class MenuHeaderView: UIView {

    weak var delegate: MenuHeaderDelegate?
    
    private var stackView = UIStackView()
    private var backImageView = UIImageView()
    private var titleLabel = UILabel()
    private var lineView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initilize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initilize()
    }
    
    private func initilize() {
        setupViews()
    }
    
    public func set(title: String) {
        titleLabel.text = title
    }
    
    public func setBackButton(isHidden: Bool) {
        backImageView.isHidden = isHidden
    }
    
    @objc private func onPressBackButton() {
        delegate?.onPressBackButton()
    }
}

extension MenuHeaderView: ViewInitalizationProtocol {
    func addSubviews() {
        addSubview(stackView)
        addSubview(lineView)
        
        stackView.addArrangedSubview(backImageView)
        stackView.addArrangedSubview(titleLabel)
    }
    
    func setupConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        
        lineView.addConstaintsToHorizontal()
        layoutConstraints += [
            lineView.bottomAnchor.constraint(equalTo: bottomAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1)
        ]
        
        backImageView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            backImageView.widthAnchor.constraint(equalToConstant: 36),
            backImageView.heightAnchor.constraint(equalToConstant: 36)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    func stylizeViews() {
        stackView.axis = .horizontal
        stackView.spacing = 13
        stackView.alignment = .center
        stackView.distribution = .fill
        
        backImageView.isHidden = true
        backImageView.isUserInteractionEnabled = true
        backImageView.tintColor = AppColor.gray.uiColor
        backImageView.image = AppImage.arrowBack.uiImage
        
        titleLabel.textAlignment = .left
        titleLabel.textColor = AppColor.gray.uiColor
        titleLabel.font = AppFont.semibold.uiFont.withSize(22)
        
        lineView.backgroundColor = AppColor.lineColor.uiColor
    }
    
    func extraTasks() {
        backImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPressBackButton)))
    }
}
