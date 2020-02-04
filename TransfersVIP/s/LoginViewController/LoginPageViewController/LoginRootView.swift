//
//  LoginRootView.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 5/2/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import UIKit

class LoginRootView: UIView {
    
    @IBOutlet var loginButton: UIButton!
    
    //tag 1 - RUS, //tag 2 - KZT, //tag 1 - ENG
    @IBOutlet var changeLanguegeButtons: [UIButton]!
    @IBOutlet var touchEnterButton: UIButton!
    @IBOutlet var menuButton: UIButton!
    
    @IBOutlet var bankLogoStackView: UIView!
    @IBOutlet var logoImageView: UIImageView!
    
    @IBOutlet var privateAccountLabel: UILabel!
    @IBOutlet var loginTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var ratesImageView: UIImageView!
    @IBOutlet var buyRateLabel: UILabel!
    @IBOutlet var buyRateValueLabel: UILabel!
    @IBOutlet var saleRateLabel: UILabel!
    @IBOutlet var saleRateValueLabel: UILabel!
    
    @IBOutlet var touchEnterLabel: UILabel!
    @IBOutlet var menuTitleLabel: UILabel!
    
    //MARK: Overriden func
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.hideExchangeRates(true)
        
        self.prepareLoginTextField()
        self.preparePassTextField()
        self.prepareLoginButton()
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        [loginTextField, passwordTextField].forEach { field in
//            field?.inputAccessoryView = nil
//            field?.reloadInputViews()
//        }
//    }
    
    //MARK: Private func
    
    private func prepareLoginTextField() {
//        let personaledWhite = AppData.Color.personaledWhite.uiColor
//        let proactiveGreen = AppData.Color.proactiveGreen.uiColor
//        let arialRegular = AppData.Font.arialRegular
//        prepareTextField(
//                         textField: loginTextField,
//                         backgroundColor: personaledWhite,
//                         tintColor: proactiveGreen,
//                         borderColor: proactiveGreen,
//                         font: arialRegular,
//                         returnKeyType: .next,
//                         isSecure: false
//                        )
    }
    
    private func preparePassTextField() {
//        let personaledWhite = AppData.Color.personaledWhite.uiColor
//        let proactiveGreen = AppData.Color.proactiveGreen.uiColor
//        let arialRegular = AppData.Font.arialRegular
//        prepareTextField(
//                         textField: passwordTextField,
//                         backgroundColor: personaledWhite,
//                         tintColor: proactiveGreen,
//                         borderColor: proactiveGreen,
//                         font: arialRegular,
//                         returnKeyType: .send,
//                         isSecure: true
//                        )
//        if #available(iOS 10.0, *) {
//            passwordTextField.textContentType = UITextContentType(rawValue: "")
//        }
    }
    
    private func prepareTextField(textField: UITextField,
                                  backgroundColor: UIColor,
                                  tintColor: UIColor,
                                  borderColor: UIColor,
                                  font: UIFont,
                                  returnKeyType: UIReturnKeyType,
                                  isSecure: Bool) {
        textField.backgroundColor = backgroundColor
        textField.tintColor = tintColor
        textField.textColor = .black
        textField.layer.borderColor = borderColor.cgColor
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = isSecure
        textField.autocorrectionType = .no
        textField.returnKeyType = returnKeyType
        textField.keyboardType = .asciiCapable
        textField.autocapitalizationType = .none
        textField.inputAccessoryView = nil
        textField.font = font
        textField.clearButtonMode = .always
    }
    
    private func prepareLoginButton() {
        let button = self.loginButton
        button?.layer.cornerRadius = self.loginButton.bounds.height / 2
        button?.layer.masksToBounds = true
//        button?.backgroundColor = AppData.Color.proactiveGreen.uiColor
//        button?.setTitleColor(AppData.Color.personaledWhite.uiColor, for: .normal)
    }
    
    //MARK: Public func 
    
    public func hideExchangeRates(_ value: Bool) {
        let alpha: CGFloat = value ? 1 : 0
        [ratesImageView, buyRateValueLabel, saleRateValueLabel].forEach { view in
            (view as! UIView).alpha = alpha
        }
    }
    
    public func fillLanguageFromAppState() {
        let type = AppState.sharedInstance.language
//        let availableLanguages = AppState.sharedInstance.loginPagelocalization
//        let language = availableLanguages?.languageFrom(state: type)
//
//        loginButton.setTitle(language?.loginToEnter, for: .normal)
//        loginButton.titleLabel?.text = language?.loginToEnter
//
//        loginTextField.placeholder = language?.usersExcelCreatorLogin
//        passwordTextField.placeholder = language?.loginPassword
//
//        buyRateLabel.text = language?.exchangeRatesPurchase
//        saleRateLabel.text = "language?.sale"
////        saleRateLabel.textColor = AppData.Color.technolygedBlackGray.uiColor
////        touchEnterLabel.text = "Войти с помощью отпечатка пальца"
//        menuTitleLabel.text = language?.mobileMenu
//        privateAccountLabel.text = language?.mobileLogin
//        ratesImageView.backgroundColor = AppData.Color.personaledOrange.uiColor
    }
}
