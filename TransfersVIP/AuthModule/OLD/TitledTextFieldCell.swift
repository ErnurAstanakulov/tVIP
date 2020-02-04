//
//  TitledTextFieldCell.swift
//  DigitalBank
//
//  Created by Алем Утемисов on 06.05.2018.
//  Copyright © 2018 iosDeveloper. All rights reserved.
//

import UIKit

class TitledTextFieldCell: UITableViewCell {
    
    let titledTextFieldView: TitledTextFieldView = TitledTextFieldView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubview(titledTextFieldView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        titledTextFieldView.addConstaintsToFill()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titledTextFieldView.canEdit = true
        titledTextFieldView.iconImageView.image = nil
        titledTextFieldView.titleLabel.text = nil
        titledTextFieldView.valueTextField.text = nil
        titledTextFieldView.valueTextField.autocapitalizationType = .none
        titledTextFieldView.errorText = nil
        titledTextFieldView.descriptionText = nil
        titledTextFieldView.performOnEdit = nil
        titledTextFieldView.performOnEndEditing = nil
        titledTextFieldView.performOnBeginEditing = nil
        titledTextFieldView.performTextValidation = nil
        titledTextFieldView.valueTextField.keyboardType = .default
        isUserInteractionEnabled = true
        titledTextFieldView.iconImageView.isHidden = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
