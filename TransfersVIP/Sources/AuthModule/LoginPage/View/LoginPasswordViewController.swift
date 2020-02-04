//
//  LoginPasswordViewController.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/5/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

protocol LoginPasswordPageDelegate: class {
    func onPressSingIn(_ viewController: LoginPasswordViewController)
}

class LoginPasswordViewController: UIViewController {

    weak var delegate: LoginPasswordPageDelegate?
    
    private var scrollView = UIScrollView()
    private var containerView = UIView()
    
    private(set) var loginHeaderView = LoginHeaderView()
    
    private var loginFormStackView = UIStackView()
    private var usernameTextField = UITextField()
    private var passwordTextField = UITextField()
    private var signInButton = UIButton()
    private var forgotPasswordButton = UIButton()
    
    override func loadView() {
        super.loadView()
        setupViews()
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    @objc func onPressSignIn() {
        delegate?.onPressSingIn(self)
    }
    
    @objc func endEditing() {
        view.endEditing(true)
    }
}

extension LoginPasswordViewController {
    var username: String? {
        get {
            return usernameTextField.text
        }
    }
    
    var password: String? {
        get {
            return passwordTextField.text
        }
    }
}

extension LoginPasswordViewController: ViewInitalizationProtocol {
    func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        containerView.addSubview(loginHeaderView)
        containerView.addSubview(loginFormStackView)
        
        loginFormStackView.addArrangedSubview(usernameTextField)
        loginFormStackView.addArrangedSubview(passwordTextField)
        loginFormStackView.addArrangedSubview(signInButton)
        loginFormStackView.addArrangedSubview(forgotPasswordButton)
    }
    
    func setupConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()
        scrollView.addConstaintsToFill()
        
        containerView.addConstaintsToFill()
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        let containerViewHeightAnchor = containerView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -statusBarHeight + -tabBarHeight)
        containerViewHeightAnchor.priority = UILayoutPriority(999)
        containerViewHeightAnchor.isActive = true
        
        loginHeaderView.addConstaintsToHorizontal()
        layoutConstraints += [
            loginHeaderView.topAnchor.constraint(equalTo: containerView.topAnchor),
            loginHeaderView.heightAnchor.constraint(greaterThanOrEqualToConstant: LoginHeaderView.MIN_HEIGHT)
        ]
        
        loginFormStackView.addConstaintsToHorizontal(padding: 25)
        layoutConstraints += [
            loginFormStackView.topAnchor.constraint(equalTo: loginHeaderView.bottomAnchor),
            loginFormStackView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -25)
        ]
        let stackViewCenterYAnchor = loginFormStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: tabBarHeight)
        stackViewCenterYAnchor.priority = UILayoutPriority(rawValue: 999)
        stackViewCenterYAnchor.isActive = true
        
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordButton.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    func stylizeViews() {
        view.backgroundColor = .clear
        
        loginHeaderView.tabBar.languageTitle = "Русский"
        loginHeaderView.tabBar.backButtonVisible = false
        
        loginFormStackView.axis = .vertical
        loginFormStackView.alignment = .fill
        loginFormStackView.distribution = .equalSpacing
        loginFormStackView.spacing = 14
        
        usernameTextField.backgroundColor = .white
        usernameTextField.textAlignment = .center
        usernameTextField.placeholder = "Логин"
        usernameTextField.textContentType = .name
        usernameTextField.autocorrectionType = .no
        usernameTextField.autocapitalizationType = .none
        usernameTextField.tintColor = AppColor.green.uiColor
        usernameTextField.decorator.apply(Style.roundCorner())
        
        passwordTextField.backgroundColor = .white
        passwordTextField.textAlignment = .center
        passwordTextField.placeholder = "Пароль"
        passwordTextField.tintColor = AppColor.green.uiColor
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocorrectionType = .no
        passwordTextField.autocapitalizationType = .none
        passwordTextField.decorator.apply(Style.roundCorner())
        passwordTextField.returnKeyType = .go

        signInButton.backgroundColor = AppColor.green.uiColor
        signInButton.setTitleColor(.white, for: .normal)
        signInButton.setTitle("Войти", for: .normal)
        signInButton.decorator.apply(Style.roundCorner())
        
        forgotPasswordButton.setTitle("Забыли пароль?", for: .normal)
        forgotPasswordButton.setTitleColor(.gray, for: .normal)
        forgotPasswordButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        forgotPasswordButton.isHidden = true
    }
    
    func extraTasks() {
        signInButton.addTarget(self, action: #selector(onPressSignIn), for: .touchUpInside)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
    }
}

extension LoginPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            textField.resignFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            onPressSignIn()
        }
        return true
    }
}
