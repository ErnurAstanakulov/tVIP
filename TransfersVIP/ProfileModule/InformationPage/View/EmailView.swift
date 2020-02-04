//
//  EmailView.swift
//  TransfersVIP
//
//  Created by psuser on 10/16/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import UIKit

class EmailView: UIView {
    
    private var stackView = UIStackView()
    private var containerView = UIView()
    private var titleLabel = UILabel()
    
    public var saveButton = UIButton()
    private var currentTextField = UITextField()
    private var newTextField = UITextField()
    private var repeatTextField = UITextField()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var newEmail: String? {
        return newTextField.text
    }
    
    public var passwordEmail: String? {
        return repeatTextField.text
    }
    
    public var currentEmail: String? {
        get {
            return currentTextField.text
        }
        set {
            currentTextField.text = newValue
        }
    }
}

extension EmailView: ViewInitalizationProtocol {
    func addSubviews() {
        addSubview(containerView)
        containerView.addSubview(stackView)
        containerView.addSubview(titleLabel)
        
        stackView.addArrangedSubview(currentTextField)
        stackView.addArrangedSubview(newTextField)
        stackView.addArrangedSubview(repeatTextField)
        stackView.addArrangedSubview(saveButton)
    }
    
    func setupConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        containerView.addConstaintsToFill()
        stackView.addConstaintsToHorizontal(padding: 25)
        
        titleLabel.addConstaintsToHorizontal(padding: 18)
        layoutConstraints += [
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            titleLabel.heightAnchor.constraint(equalToConstant: 25)
        ]
        
        layoutConstraints += [
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 18),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30)
        ]
        
        [currentTextField, newTextField, repeatTextField, saveButton].forEach { (element) in
            element.translatesAutoresizingMaskIntoConstraints = false
            element.heightAnchor.constraint(equalToConstant: 40).isActive = true
            element.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            heightAnchor.constraint(equalToConstant: 300)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    func stylizeViews() {
        backgroundColor = .white
        
        titleLabel.text = "Изменение почты"
        titleLabel.font = AppFont.semibold.with(size: 18)
        titleLabel.textColor = AppColor.gray.uiColor
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 14
        
        currentTextField.backgroundColor = .white
        currentTextField.textAlignment = .center
        currentTextField.placeholder = "Текущий email"
        currentTextField.textContentType = .emailAddress
        currentTextField.autocorrectionType = .no
        currentTextField.tintColor = AppColor.green.uiColor
        currentTextField.keyboardType = .emailAddress
        currentTextField.borderStyle = .none
        currentTextField.decorator.apply(Style.roundCorner(), Style.border(width: 1.0))
        
        newTextField.backgroundColor = .white
        newTextField.textAlignment = .center
        newTextField.placeholder = "Новый email"
        newTextField.textContentType = .emailAddress
        newTextField.autocorrectionType = .no
        newTextField.tintColor = AppColor.green.uiColor
        newTextField.keyboardType = .emailAddress
        newTextField.borderStyle = .none
        newTextField.decorator.apply(Style.roundCorner(), Style.border(width: 1.0))
        
        repeatTextField.backgroundColor = .white
        repeatTextField.textAlignment = .center
        repeatTextField.placeholder = "Введите пароль"
        repeatTextField.textContentType = .name
        repeatTextField.autocorrectionType = .no
        repeatTextField.tintColor = AppColor.green.uiColor
        repeatTextField.isSecureTextEntry = true
        repeatTextField.borderStyle = .none
        repeatTextField.decorator.apply(Style.roundCorner(), Style.border(width: 1.0))
        
        saveButton.backgroundColor = AppColor.green.uiColor
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.decorator.apply(Style.roundCorner(), Style.shadow())
    }
}
