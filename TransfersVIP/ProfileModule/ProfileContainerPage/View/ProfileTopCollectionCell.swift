//
//  ProfileTopCollectionCell.swift
//  TransfersVIP
//
//  Created by psuser on 10/14/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import UIKit

class ProfileTopCollectionCell: UICollectionViewCell {
    
    private var titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        setupViews()
    }
    
    override var isSelected: Bool {
        didSet {
            setTextColor(isSelected)
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            setTextColor(isHighlighted)
        }
    }
    
    public func fillTitle(_ name: String) {
        titleLabel.text = name
    }
    
    private func setTextColor(_ isSelected: Bool) {
        titleLabel.textColor = isSelected ? AppColor.green.uiColor : AppColor.gray.uiColor
    }
}
extension ProfileTopCollectionCell: ViewInitalizationProtocol {
    func addSubviews() {
        addSubview(titleLabel)
    }
    
    func setupConstraints() {
        titleLabel.addConstaintsToFill()
    }
    
    func stylizeViews() {
        titleLabel.textColor = AppColor.gray.uiColor
        titleLabel.textAlignment = .center
        titleLabel.font = AppFont.regular.with(size: 14)
    }
}

