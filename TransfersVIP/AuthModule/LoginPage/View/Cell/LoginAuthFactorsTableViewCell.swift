//
//  LoginAuthFactorsTableViewCell.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/15/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

class LoginAuthFactorsTableViewCell: UITableViewCell, ReusableView {
    
    private var containerView = UIView()
    private var titlesLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.initilize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initilize()
    }
    
    private func initilize() {
        setupViews()
    }
    
    public func set(authFactors: [String]) {
        titlesLabel.text = prepareTitle(authFactors)
    }
    
    private func prepareTitle(_ authFactors: [String]) -> String {
        if (authFactors.count == 1) {
            return authFactors[0]
        }
        return " • " + authFactors.joined(separator: "\n • ")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titlesLabel.text = nil
    }
}

extension LoginAuthFactorsTableViewCell: ViewInitalizationProtocol {
    func addSubviews() {
        addSubview(containerView)
        containerView.addSubview(titlesLabel)
    }
    
    func setupConstraints() {
        containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 45).isActive = true
        
        containerView.addConstaintsToHorizontal(padding: 25)
        containerView.addConstaintsToVertical(padding: 7)
        
        titlesLabel.addConstaintsToVertical(padding: 9)
        titlesLabel.addConstaintsToHorizontal(padding: 20)
    }
    
    func stylizeViews() {
        selectionStyle = .none
        backgroundColor = .clear
        
        containerView.backgroundColor = .white
        containerView.decorator.apply(Style.corner(radius: 20), Style.shadow())
        
        titlesLabel.numberOfLines = 0
        titlesLabel.textColor = AppColor.dark.uiColor
    }
}
