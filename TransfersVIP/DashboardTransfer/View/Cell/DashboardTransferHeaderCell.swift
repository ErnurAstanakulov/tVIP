//
//  DashboardTransferHeaderCell.swift
//  TransfersVIP
//
//  Created by psuser on 29/08/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import UIKit

class DashboardTransferHeaderCell: UICollectionViewCell {
    
    let roundedView = UIView()
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    private func setTextColor(_ isSelected: Bool) {
        titleLabel.textColor = isSelected ? AppColor.green.uiColor : AppColor.gray.uiColor
    }
}

extension DashboardTransferHeaderCell: ViewInitalizationProtocol {
    func addSubviews() {
        addSubview(roundedView)
        roundedView.addSubview(titleLabel)
    }
    
    func setupConstraints() {
        roundedView.addConstaintsToFill()
        titleLabel.addConstaintsToFill()
    }
    
    func stylizeViews() {
        roundedView.backgroundColor = AppColor.white.uiColor
        roundedView.layer.cornerRadius = frame.height / 2.0
        roundedView.layer.masksToBounds = true
        titleLabel.textColor = AppColor.gray.uiColor
        titleLabel.font = AppFont.regular.uiFont
        titleLabel.textAlignment = .center
    }
    
    
}
