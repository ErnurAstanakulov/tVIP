//
//  TransferNewCell.swift
//  TransfersVIP
//
//  Created by psuser on 30/08/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import UIKit

class TransferNewCell: UITableViewCell {
    
    private var iconImageView = UIImageView()
    private var transferTitleLabel = UILabel()
    private var createTransferButton = UIButton()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    func fill(_ model: TransferNew) {
        transferTitleLabel.text = model.title
        iconImageView.image = model.icon
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit() {
        setupViews()
    }
}

extension TransferNewCell: ViewInitalizationProtocol {
    func addSubviews() {
        [iconImageView, transferTitleLabel, createTransferButton].forEach { addSubview($0) }
    }
    
    func setupConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()

        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
           iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 31),
           iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 11),
           iconImageView.widthAnchor.constraint(equalToConstant: 36),
           iconImageView.heightAnchor.constraint(equalToConstant: 36)
           
        ]
        
        transferTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            transferTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            transferTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            transferTitleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 15),
            transferTitleLabel.trailingAnchor.constraint(equalTo: createTransferButton.leadingAnchor, constant: -4)
        ]
        
        createTransferButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            createTransferButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28),
            createTransferButton.topAnchor.constraint(equalTo: topAnchor, constant: 11),
            createTransferButton.widthAnchor.constraint(equalToConstant: 36),
            createTransferButton.heightAnchor.constraint(equalToConstant: 36)
            
        ]
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    func stylizeViews() {
        createTransferButton.setImage(AppImage.createTransfer.uiImage, for: .normal)
        createTransferButton.contentVerticalAlignment = .fill
        createTransferButton.contentHorizontalAlignment = .fill
        createTransferButton.isUserInteractionEnabled = false
        transferTitleLabel.textColor = AppColor.gray.uiColor
        transferTitleLabel.font = AppFont.regular.with(size: 14)
        selectionStyle = .none
    }
}
