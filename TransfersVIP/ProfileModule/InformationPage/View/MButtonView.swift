//
//  MButtonView.swift
//  TransfersVIP
//
//  Created by psuser on 10/16/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import UIKit

class MButtonView: UIView {
    
    var delegate: EditButtonDelegate?
    let editButton = UIButton()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareForReuse() {
        titleLabel.text = nil
        descriptionLabel.text = nil
    }
    
    @objc func onPressButton(sender: UIButton) {
        delegate?.onPressButton(sender)
    }
}

extension MButtonView: ViewInitalizationProtocol {
    
    func addSubviews() {
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(editButton)
    }
    
    func setupConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 18)
        ]
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: editButton.leadingAnchor, constant: -16),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ]
        
        editButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            editButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            editButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            editButton.widthAnchor.constraint(equalToConstant: 24),
            editButton.heightAnchor.constraint(equalToConstant: 24)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    func stylizeViews() {
        // titleLabel
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = .gray
        titleLabel.isUserInteractionEnabled = false
        titleLabel.numberOfLines = 0
        
        editButton.imageView?.contentMode = .scaleAspectFit
        editButton.setImage(AppImage.pencilEdit.uiImage?.withRenderingMode(.alwaysTemplate), for: .normal)
        editButton.setImage(AppImage.pencilEdit.uiImage, for: .selected)
        editButton.tintColor = .black
        
        descriptionLabel.textColor = AppColor.green.uiColor
        descriptionLabel.font = AppFont.semibold.with(size: 14)
        descriptionLabel.numberOfLines = 0
        
    }
    
    func extraTasks() {
        editButton.addTarget(self, action: #selector(onPressButton), for: .touchUpInside)
    }
}
