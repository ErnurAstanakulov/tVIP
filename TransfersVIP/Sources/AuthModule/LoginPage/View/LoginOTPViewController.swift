//
//  LoginOTPViewController.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/10/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

protocol LoginOTPDelegate: class, LoginPageSkipable {
    func onPressSendButton(_ viewController: LoginOTPViewController)
    func onPressSynchronizeButton(_ viewController: LoginOTPViewController)
}

class LoginOTPViewController: BaseViewController {
    weak var delegate: LoginOTPDelegate?
    
    private var scrollView = UIScrollView()
    private var containerView = UIView()
    
    private(set) var loginHeaderView = LoginHeaderView()
    
    private var stackView = UIStackView()
    private var titleLabel = UILabel()
    private var tokenTextField = UITextField()
    private var sendButton = UIButton()
    private var synchronizeButton = UIButton()
    private var skipButton = UIButton()
    
    override func loadView() {
        super.loadView()
        setupViews()
    }
    
    @objc private func onPressSendButton(_ sender: UIButton) {
        delegate?.onPressSendButton(self)
    }
    
    @objc private func onPressSynchronizeButton(_ sender: UIButton) {
        delegate?.onPressSynchronizeButton(self)
    }
    
    @objc private func onPressSkipButton(_ sender: UIButton) {
        delegate?.onPressSkip(self)
    }
    
    @objc func endEditing() {
        view.endEditing(true)
    }
}

extension LoginOTPViewController {
    var token: String? {
        return tokenTextField.text
    }
    
    var canSkip: Bool {
        get {
            return skipButton.isHidden
        }
        set {
            skipButton.isHidden = !newValue
        }
    }
}

extension LoginOTPViewController: ViewInitalizationProtocol {
    func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        containerView.addSubview(loginHeaderView)
        containerView.addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(tokenTextField)
        stackView.addArrangedSubview(sendButton)
        stackView.addArrangedSubview(synchronizeButton)
        stackView.addArrangedSubview(skipButton)
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
        
        stackView.addConstaintsToHorizontal(padding: 25)
        layoutConstraints += [
            stackView.topAnchor.constraint(equalTo: loginHeaderView.bottomAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -25)
        ]
        let stackViewCenterYAnchor = stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: tabBarHeight)
        stackViewCenterYAnchor.priority = UILayoutPriority(rawValue: 999)
        stackViewCenterYAnchor.isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        tokenTextField.translatesAutoresizingMaskIntoConstraints = false
        tokenTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        synchronizeButton.translatesAutoresizingMaskIntoConstraints = false
        synchronizeButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    func stylizeViews() {
        view.backgroundColor = .clear
        
        loginHeaderView.tabBar.languageTitle = "Русский"
        loginHeaderView.tabBar.backButtonVisible = true
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 14
        
        titleLabel.text = "Автономный генератор (ОТП)"
        titleLabel.textAlignment = .center
        titleLabel.font = AppFont.regular.with(size: 16)
        titleLabel.textColor = AppColor.dark.uiColor
        
        tokenTextField.backgroundColor = .white
        tokenTextField.textAlignment = .center
        tokenTextField.placeholder = "Токен"
        tokenTextField.textContentType = .name
        tokenTextField.autocorrectionType = .no
        tokenTextField.tintColor = AppColor.green.uiColor
        tokenTextField.decorator.apply(Style.roundCorner())
        
        sendButton.backgroundColor = AppColor.green.uiColor
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.setTitle("Отправить", for: .normal)
        sendButton.decorator.apply(Style.roundCorner(), Style.shadow())
        
        synchronizeButton.backgroundColor = .white
        synchronizeButton.setTitleColor(AppColor.dark.uiColor, for: .normal)
        synchronizeButton.setTitle("Синхронизировать ", for: .normal)
        synchronizeButton.decorator.apply(Style.roundCorner(), Style.shadow())
        
        skipButton.setTitle("Пропустить", for: .normal)
        skipButton.setTitleColor(.gray, for: .normal)
        skipButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
    }
    
    func extraTasks() {
        sendButton.addTarget(self, action: #selector(onPressSendButton), for: .touchUpInside)
        synchronizeButton.addTarget(self, action: #selector(onPressSynchronizeButton), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(onPressSkipButton), for: .touchUpInside)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
    }
}
