//
//  UIView+extension.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/5/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

extension UIView {
    func addConstaintsToHorizontal(padding: CGFloat = 0) {
        prepareForConstraints()
        self.leadingAnchor.constraint(equalTo: superview!.leadingAnchor, constant: padding).isActive = true
        self.trailingAnchor.constraint(equalTo: superview!.trailingAnchor, constant: -padding).isActive = true
    }
    
    func addConstaintsToVertical(padding: CGFloat = 0) {
        prepareForConstraints()
        self.topAnchor.constraint(equalTo: superview!.topAnchor, constant: padding).isActive = true
        self.bottomAnchor.constraint(equalTo: superview!.bottomAnchor, constant: -padding).isActive = true
    }
    
    func addConstaintsToFill(padding: CGFloat = 0) {
        prepareForConstraints()
        addConstaintsToHorizontal(padding: padding)
        addConstaintsToVertical(padding: padding)
    }
    
    private func prepareForConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        if superview == nil {
            assert(false, "You need to have a superview before you can add contraints")
        }
    }
}
