//
//  NewSyncOTPFormView.swift
//  DigitalBank
//
//  Created by Zhalgas Baibatyr on 01/07/2018.
//  Copyright © 2018 iosDeveloper. All rights reserved.
//

import UIKit

class SyncOTPFormView: CodeBasedAuthFactorFormView {
    
    let secondCodeTextField = UITextField()
    
    override func setupViews() {
        super.setupViews()
        stackView.insertArrangedSubview(secondCodeTextField, at: 2)
    }
    
    override func stylize() {
        super.stylize()
        
        codeTextField.placeholder = "Первое значение"
        
        secondCodeTextField.keyboardType = .numberPad
        secondCodeTextField.font = AppData.Font.arialRegular
        secondCodeTextField.textColor = AppData.Color.technolygedBlackGray.uiColor
        secondCodeTextField.placeholder = "Второе значение"
        secondCodeTextField.backgroundColor = AppData.Color.personaledWhite.uiColor
        secondCodeTextField.tintColor = AppData.Color.proactiveGreen.uiColor
        secondCodeTextField.borderStyle = .roundedRect
        secondCodeTextField.clearButtonMode = .always
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        secondCodeTextField.translatesAutoresizingMaskIntoConstraints = false
        secondCodeTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        secondCodeTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
    }
    
}
