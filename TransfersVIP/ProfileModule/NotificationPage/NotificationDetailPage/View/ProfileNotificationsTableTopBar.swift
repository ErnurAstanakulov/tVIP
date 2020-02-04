//
//  ProfileNotificationsTableTopBar.swift
//  TransfersVIP
//
//  Created by psuser on 10/22/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import UIKit

class ProfileNotificationsTableTopBar: UIView, TopBarViewProtocol {
    
    var backButtonAction: (() -> ())?
    
    var leftSideImageView = UIImageView()
    var backButton = UIImageView()
    var titleLabel = UILabel()
    var headerTitleLabel = UILabel()
    
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

extension ProfileNotificationsTableTopBar: ViewInitalizationProtocol {
    func addSubviews() {
        addSubview(backButton)
        addSubview(titleLabel)
        addSubview(headerTitleLabel)
    }
    
    func setupConstraints() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        backButton.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        
        headerTitleLabel.addConstaintsToHorizontal(padding: 25)
        headerTitleLabel.topAnchor.constraint(equalTo: backButton.topAnchor, constant: 8).isActive = true
        headerTitleLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true

        titleLabel.addConstaintsToHorizontal(padding: 25)
        titleLabel.topAnchor.constraint(equalTo: headerTitleLabel.bottomAnchor, constant: 8).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
        leftSideImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func stylizeViews() {
        titleLabel.textColor = .white
        titleLabel.font = AppFont.semibold.with(size: 16)
        titleLabel.numberOfLines = 0
        
        headerTitleLabel.textColor = .white
        headerTitleLabel.font = AppFont.semibold.with(size: 18)
        headerTitleLabel.numberOfLines = 0
        
        backButton.image = AppImage.arrowBack.uiImage?.withRenderingMode(.alwaysTemplate)
        backButton.tintColor = .white
        backButton.contentMode = .scaleAspectFit
        backButton.isUserInteractionEnabled = true
    }
    
    func extraTasks() {
        backButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPressBackButton)))
    }
}
