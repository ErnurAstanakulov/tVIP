//
//  TopBarViewProtocol.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/31/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

protocol TopBarViewProtocol where Self: UIView {
    
    var leftSideImageView: UIImageView { get }
    
}

extension TopBarViewProtocol {
    
    func setupTopBarView() {
        addHeaderSubviews()
        setupHeaderConstraints()
        stylizeHeaderViews()
    }
    
    func addHeaderSubviews() {
        addSubview(leftSideImageView)
    }
    
    func setupHeaderConstraints() {
        leftSideImageView.addConstaintsToVertical()
        leftSideImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        leftSideImageView.widthAnchor.constraint(equalTo: leftSideImageView.heightAnchor).isActive = true
    }
    
    func stylizeHeaderViews() {
        backgroundColor = AppColor.green.uiColor
        
        leftSideImageView.image = AppImage.logo.uiImage?.withRenderingMode(.alwaysTemplate)
        leftSideImageView.tintColor = AppColor.lightGray.uiColor
        leftSideImageView.contentMode = .scaleAspectFit
    }
}

