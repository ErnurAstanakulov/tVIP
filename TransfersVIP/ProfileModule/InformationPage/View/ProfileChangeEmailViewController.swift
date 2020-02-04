//
//  ProfileEmailViewController.swift
//  TransfersVIP
//
//  Created by psuser on 10/14/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import UIKit

class ProfileChangeEmailViewController: CodeBasedAuthFactorViewController {
    
    weak var delegate: ProfileChangeEmailDelegate?
    private let emailView = EmailView()
    
    override func loadView() {
        super.loadView()
        setContainerSubview(emailView)
        emailView.saveButton.addTarget(self, action: #selector(onPressSaveButton), for: .touchUpInside)
    }
    
    override func setupConstraints() {
        containerView.addConstaintsToHorizontal()
        containerView.heightAnchor.constraint(equalToConstant: emailView.frame.height)
        
        containerViewCenterYAnchorConstraint = containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 300)
        containerViewCenterYAnchorConstraint?.isActive = true
    }
    
    override func hideCenterConstant() {
        containerViewCenterYAnchorConstraint?.constant = emailView.frame.height
    }
    
    @objc private func onPressSaveButton(_ sender: UIButton) {
        delegate?.onPressSaveButton(self)
    }
}

extension ProfileChangeEmailViewController {
    var password: String? {
        return emailView.passwordEmail
    }
    
    var newEmail: String? {
        return emailView.newEmail
    }
    
    var currentEmail: String? {
        get {
            return emailView.currentEmail
        }
        set {
            emailView.currentEmail = newValue
        }
    }
}
