//
//  ProfileOrganizationCell.swift
//  TransfersVIP
//
//  Created by psuser on 10/16/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import UIKit

class ProfileOrganizationCell: UITableViewCell, ReusableView {
    
    private let view = ProfileOrganizationView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    func fill(_ organization: Organization) {
        view.organization = organization
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProfileOrganizationCell: ViewInitalizationProtocol {
    func addSubviews() {
        addSubview(view)
    }
    
    func setupConstraints() {
        view.addConstaintsToFill()
    }
    
    func stylizeViews() {
        backgroundColor = .clear
        view.backgroundColor = .white
    }
}
