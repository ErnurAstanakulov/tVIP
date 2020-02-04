//
//  OperationsTableTopBar.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 8/18/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

class OperationsTableTopBar: UIView, TopBarViewProtocol {
    
    var backButtonAction: (() -> ())?
    
    var leftSideImageView = UIImageView()
    var backButton = UIImageView()
    var titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        setupTopBarView()
        setupViews()
    }
    
    @objc private func onPressBackButton() {
        backButtonAction?()
    }
}

extension OperationsTableTopBar: ViewInitalizationProtocol {
    func addSubviews() {
        addSubview(backButton)
        addSubview(titleLabel)
    }
    
    func setupConstraints() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        backButton.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        
        titleLabel.addConstaintsToHorizontal(padding: 25)
        titleLabel.topAnchor.constraint(equalTo: backButton.topAnchor, constant: 8).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
        leftSideImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func stylizeViews() {
        titleLabel.textColor = .white
        titleLabel.font = AppFont.semibold.with(size: 14)
        titleLabel.numberOfLines = 0
        
        backButton.image = AppImage.arrowBack.uiImage?.withRenderingMode(.alwaysTemplate)
        backButton.tintColor = .white
        backButton.contentMode = .scaleAspectFit
        backButton.isUserInteractionEnabled = true
    }
    
    func extraTasks() {
        backButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPressBackButton)))
    }
}
