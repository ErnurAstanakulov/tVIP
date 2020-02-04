//
//  ProfileOrganizationView.swift
//  TransfersVIP
//
//  Created by psuser on 10/16/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import UIKit

class ProfileOrganizationView: UIView {
    
    private var titleLabel = UILabel()
    private var organizationLabel = UILabel()
    private var statusButton = UIButton()
    
    public var isBlocked: Bool = false {
        didSet {
            stylizeViews()
        }
    }
    
    var organization: Organization? {
        willSet {
            titleLabel.text = newValue?.name
            organizationLabel.text = newValue?.bin
            isBlocked = newValue?.isBlocked ?? false
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension ProfileOrganizationView: ViewInitalizationProtocol {
    func addSubviews() {
        addSubview(titleLabel)
        addSubview(organizationLabel)
        addSubview(statusButton)
    }
    
    func setupConstraints() {
        var layoutConstraints: [NSLayoutConstraint] = []
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        layoutConstraints += [
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ]
        
        statusButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            statusButton.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            statusButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            statusButton.leadingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -125),
            statusButton.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor)
        ]
        
        organizationLabel.addConstaintsToHorizontal(padding: 25)
        layoutConstraints += [
            organizationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            organizationLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    func stylizeViews() {
        
        titleLabel.textColor = !isBlocked ? AppColor.gray.uiColor : AppColor.lightGray.uiColor
        titleLabel.font = AppFont.regular.with(size: 10)
        
        organizationLabel.textColor = !isBlocked ? AppColor.green.uiColor : AppColor.lightGray.uiColor
        organizationLabel.font = AppFont.regular.with(size: 14)
        
        statusButton.isUserInteractionEnabled = false
        statusButton.setImage(AppImage.blockOrganization.uiImage?.withRenderingMode(.alwaysTemplate), for: .normal)
        let selectedColor = !isBlocked ? AppColor.gray.uiColor : UIColor.red
        statusButton.tintColor = selectedColor
        statusButton.setTitleColor(selectedColor, for: .normal)
        statusButton.setTitle(isBlocked ? "Заблокировано" : "Доступно", for: .normal)
        statusButton.titleLabel?.font = AppFont.light.with(size: 10)
        statusButton.contentHorizontalAlignment = .right
        statusButton.imageEdgeInsets.right = 5
        statusButton.titleEdgeInsets.left = 5
        
    }
    
    
}

