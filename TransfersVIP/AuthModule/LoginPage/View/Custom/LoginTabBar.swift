//
//  LoginTabBar.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/16/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

protocol LoginTabBarDelegate: class {
    func onPressBackButton(_ view: LoginTabBar)
    func onPressLanguageButton(_ view: LoginTabBar)
}

extension LoginTabBarDelegate {
    func onPressBackButton(_ view: LoginTabBar) {}
    func onPressLanguageButton(_ view: LoginTabBar) {}
}

class LoginTabBar: UIView {
    weak var delegate: LoginTabBarDelegate?
    
    public static var VIEW_HEIGHT: CGFloat = 75
    
    private var backView = UIImageView()
    private var languageView = UIView()
    
    private var stackView = UIStackView()
    private var dropDownImageView = UIImageView()
    private var languageTitleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initilize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initilize()
    }
    
    private func initilize() {
        setupViews()
    }
    
    @objc private func onPressBackButton() {
        delegate?.onPressBackButton(self)
    }
    
    @objc private func onPressLanguageButton() {
        delegate?.onPressLanguageButton(self)
    }
}

extension LoginTabBar {
    public var languageTitle: String? {
        get {
            return languageTitleLabel.text
        }
        set {
            languageTitleLabel.text = newValue
        }
    }
    
    public var backButtonVisible: Bool {
        get {
            return !backView.isHidden
        }
        set {
            backView.isHidden = !newValue
        }
    }
}

extension LoginTabBar: ViewInitalizationProtocol {
    func addSubviews() {
        addSubview(backView)
        addSubview(languageView)
        
        languageView.addSubview(stackView)
        
        stackView.addArrangedSubview(languageTitleLabel)
        stackView.addArrangedSubview(dropDownImageView)
    }
    
    func setupConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        backView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            backView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            backView.centerYAnchor.constraint(equalTo: centerYAnchor),
            backView.widthAnchor.constraint(equalToConstant: 35),
            backView.heightAnchor.constraint(equalToConstant: 35)
        ]
        
        languageView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            languageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            languageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            languageView.heightAnchor.constraint(equalToConstant: 25)
        ]
        
        stackView.addConstaintsToHorizontal(padding: 10)
        stackView.addConstaintsToVertical(padding: 5)
        
        dropDownImageView.translatesAutoresizingMaskIntoConstraints = false
        dropDownImageView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        dropDownImageView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    func stylizeViews() {
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        
        backView.image = AppImage.arrowBack.uiImage
        backView.contentMode = .scaleAspectFit
        backView.isUserInteractionEnabled = true
        
        dropDownImageView.image = AppImage.arrowDown.uiImage
        dropDownImageView.tintColor = AppColor.dark.uiColor
        
        languageTitleLabel.font = AppFont.regular.with(size: 12)
        languageTitleLabel.textColor = AppColor.dark.uiColor
        
        languageView.backgroundColor = .white
        languageView.decorator.apply(Style.roundCorner())
        
        backView.isHidden = true
    }
    
    func extraTasks() {
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPressBackButton)))
        languageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPressLanguageButton)))
    }
}
