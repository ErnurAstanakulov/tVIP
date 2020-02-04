//
//  LoginHeaderView.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/15/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

class LoginHeaderView: UIView {
    
    public static var MIN_HEIGHT: CGFloat = 210
    public static var VIEW_HEIGHT: CGFloat = 250
    
    private(set) var tabBar = LoginTabBar()
    private var logoImageView = UIImageView()
    
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
}

extension LoginHeaderView: ViewInitalizationProtocol {
    func addSubviews() {
        addSubview(tabBar)
        addSubview(logoImageView)
    }
    
    func setupConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        tabBar.addConstaintsToHorizontal()
        layoutConstraints += [
            tabBar.topAnchor.constraint(equalTo: topAnchor),
            tabBar.heightAnchor.constraint(equalToConstant: LoginTabBar.VIEW_HEIGHT)
        ]
        
        logoImageView.addConstaintsToHorizontal(padding: 65)
        logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    func stylizeViews() {
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = AppImage.logoNew.uiImage
    }
}
