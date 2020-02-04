//
//  ViewController.swift
//  DigitalBank
//
//  Created by iosDeveloper on 10/31/16.
//  Copyright © 2016 iosDeveloper. All rights reserved.
//


import UIKit
import Alamofire
import SwiftyRSA

public let pageSize = 5

public var containerSN = ""
var keyCertificatesDataSource = [Certificate]()
var oAuthModel = LoginOAuthModel()

class LoginViewController: UIViewController, ExtendedUIViewController, OAuthFactorDelegate {
   
    var viewController: UIViewController?
    
    let viewModel = LoginViewModel()
    
    var rootView: ANSRootView { return self.getView()! }
    
    private var shouldRepeatRatesAnimation = true
    
    private var request: DataRequest? {
        willSet(newRequest) {
            request?.cancel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addTapGesture()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.endEditing(true)
        
        self.shouldRepeatRatesAnimation = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addKeyboardEvents()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.shouldRepeatRatesAnimation = false
        
        removeKeyboardEvents()
    }
    
    //MARK: Actions
    
    //DESC: Action to change language. sender.tag 1 = russian, tag 2 = kozak , tag 3 = english
    @IBAction func changeLanguegeButtonsActison(_ sender: UIButton) {
        guard !sender.isSelected else { return }
       
        switch sender.tag {
        case 1: AppState.sharedInstance.language = .RUS
        case 2: AppState.sharedInstance.language = .KZT
        case 3: AppState.sharedInstance.language = .ENG
        default: break
        }
        
        
        sender.isSelected = true
    }
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        signIn()
    }
    
    @objc private func passwordRecoveryButtonPressed() {
       
    }
    
    @IBAction func menuAction(_ sender: UIButton) {
        let controller = UIStoryboard.controllerFromMainStorybourd(cls: LoginSideMenuTableViewController.self)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: Private functions
    
    fileprivate func signIn() {
        let login = "sber5"
        let password = "Qwert123!"
    
        RSAManager.requestPublicKey { [unowned self] publicKey in
            guard let publicKey = publicKey,
                  let encryptedLogin = RSAManager.encrypt(string: login, using: publicKey),
                  let encryptedPassword = RSAManager.encrypt(string: password, using: publicKey) else {
                DispatchQueue.main.async {
                    self.rootView.isLoadingViewVisible = false
                    self.presentErrorController(title: "Ошибка", message: "Возникла проблема при аутентификации")
                }
                return
            }
            oAuthModel.resetParameters()
            oAuthModel.userName = encryptedLogin
            oAuthModel.password = encryptedPassword
            AuthorizationAdapter.shared.encryptedLogin = encryptedLogin
            AuthorizationAdapter.shared.encryptedPassword = encryptedPassword
            self.viewModel.getAuthAccessToken(with: oAuthModel) { [weak self] success, customers, errorMessage in
                
                guard let viewController = self else {
                    return
                }
                
                DispatchQueue.main.async {
                
                    viewController.rootView.isLoadingViewVisible = false
                    
                    guard success else {
                        if let errorMessage = errorMessage {
                            viewController.presentErrorController(title: "Ошибка", message: errorMessage)
                        } else {
                            viewController.presentErrorController(title: "Ошибка", message: contentErrorMessage)
                        }
                        return
                    }
                    
                    guard let customers = customers else {
                        viewController.presentErrorController(title: "Ошибка", message: contentErrorMessage)
                        return
                    }
                    
                    switch customers.count {
                    case 0:
                        viewController.presentErrorController(title: "Ошибка", message: contentErrorMessage)
                    case 1:
                        viewController.requestAuthFactorsForCustomer(at: 0)
                    default:
                        viewController.displayList(of: customers)
                    }
                }
            }
        }
    }
    
    private func displayList(of companyNames: [String]) {
//        let pickerListViewController = PickerListViewController()
//        pickerListViewController.pickerDescription = "Выберите компанию из списка"
//        pickerListViewController.values = companyNames
//        pickerListViewController.performOnPick = { [unowned self, unowned pickerListViewController] index in
//            DispatchQueue.main.async {
//                pickerListViewController.dismiss(animated: true) {
//                    self.requestAuthFactorsForCustomer(at: index)
//                }
//            }
//        }
//        pickerListViewController.performOnClose = performLogOut
//        pickerListViewController.modalPresentationStyle = .overCurrentContext
//        pickerListViewController.modalTransitionStyle = .crossDissolve
//        present(pickerListViewController, animated: true)
    }

    //DESC: Tap gesture on rootView to remove keyboard
    
    private func addTapGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(sender: )))
        self.view.addGestureRecognizer(gesture)
    }
    
    @objc func tapGestureAction(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // MARK: Keyboard related events observation
    
    /// Start observing keyboard events
    private func addKeyboardEvents() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(applicationWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    /// Stop observing keyboard events
    private func removeKeyboardEvents() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    /// Perform when keyboard will show
    ///
    /// - Parameter notification: notification container
    @objc private func keyboardWillShow(notification: Notification) {
        guard let infoNSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardFrame = infoNSValue.cgRectValue
//        guard let buttonGlobalFrame = rootView.loginButton.superview?.convert(rootView.loginButton.frame, to: nil) else {
//            return
//        }
//
//        let coveredSpace = buttonGlobalFrame.maxY - keyboardFrame.origin.y
//        if coveredSpace > 0 {
//            view.frame.origin.y -= (coveredSpace + 16)
//        }
    }
    
    internal func fetchUserDataThenGoToMainPage() {
//        Loader.shared.show()
//        UserDataLoader.loadUserInfo {[unowned self] (success, errorMessage) in
//            Loader.shared.hide()
//            guard success else {
//                self.presentErrorController(title: errorMessage, message: nil)
//                return
//            }
//            self.pushToMainTabBarController()
//        }
    }
    
    internal func pushToMainTabBarController() {
//        navigationController?.pushViewController(NewMainTabBarController(), animated: true)
    }
    
    /// Perform when keyboard will hide
    ///
    /// - Parameter notification: notification container
    @objc private func keyboardWillHide(notification: Notification) {
        view.frame.origin = .zero
    }
    
    /// Perform when app will switch to the background
    ///
    /// - Parameter notification: notification container
    @objc private func applicationWillResignActive(notification: Notification) {
        view.endEditing(true)
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle { return .default }
}

extension LoginViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if textField ===  self.rootView.loginTextField {
//            _ = self.rootView.passwordTextField.becomeFirstResponder()
//        } else if textField == self.rootView.passwordTextField {
//            self.view.endEditing(true)
//        }
//
        return true
    }
}

public func performLogOut() {
    let logoutURL = baseURL + "api/customer/logout"
    sessionManager.request(logoutURL, method: .post).validate().responseJSON { dataResponse in
        log(serverResponse: dataResponse)
        AppState.sharedInstance.isLoggined = false
    }
    sessionManager.adapter?.closeSession()
}

public func performRefresh() {
    guard let adapter = sessionManager.adapter as? AppRequestAdapter,
          let encryptedUsername = adapter.encryptedUsername,
          let refreshToken = adapter.refreshToken
    else { return }
    let refreshURL = baseURL + "auth/oauth/token"
    let parameters: [String: Any] = [
        "grant_type": "refresh_token",
        "user_type": "customer",
        "username": encryptedUsername,
        "refresh_token": refreshToken
    ]
    var header: [String : String] {
        return [
            "Authorization": "Basic " + "MOBILE:".toBase64()
        ]
    }
    let request = sessionManager.request(refreshURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header)
    
    request.validate().responseJSON { dataResponse in
        log(serverResponse: dataResponse)
        if dataResponse.response?.statusCode != 200 {
            logOut()
            return
        }
    }
}

import Foundation
import ObjectMapper

class BaseModel: NSObject, Mappable {
    var id: Int!
    
    required init?(map: Map) {
        if map.JSON["id"] == nil {
            return nil
        }
        
        super.init()
    }
    
    public func mapping(map: Map) {
        id <- map["id"]
    }
    
    override init() {
        super.init()
    }
}

protocol SMBaseModel {
    var id: Int { get }
}


class Certificate: BaseModel {
    var validFrom: String?
    var validTo: String?
    var dn: String?
    var certificateSN: String?
    var isValid: Bool?
    var isTechnological: Bool?
    var ownerId: Int?
    var ownerFullName: String = ""
    var customerId: Int?
    var customerName: String = ""
    var certificate: String?
    var alg: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        validFrom <- map["validFrom"]
        validTo <- map["validTo"]
        dn <- map["dn"]
        certificateSN <- map["certificateSN"]
        isValid <- map["isValid"]
        isTechnological <- map["isTechnological"]
        ownerId <- map["ownerId"]
        ownerFullName <- map["ownerFullName"]
        customerId <- map["customerId"]
        customerName <- map["customerName"]
        certificate <- map["certificate"]
        alg <- map["alg"]
    }
}
public protocol ExtendedUIViewController where Self: UIViewController {}

public extension ExtendedUIViewController {
    
    /// Set status bar background color
    ///
    /// - Parameter backgroundColor: status bar background color
    public func setStatusBarBackground() {
        let statusBarView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        view.insertSubview(statusBarView, aboveSubview: view)
        statusBarView.translatesAutoresizingMaskIntoConstraints = false
        statusBarView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        statusBarView.heightAnchor.constraint(equalToConstant: UIApplication.shared.statusBarFrame.height).isActive = true
        statusBarView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        statusBarView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
    
    // MARK: Alert messages
    
    /// Customized alert message
    ///
    /// - Parameters:
    ///   - title: Alert title
    ///   - message: Text message to be displayed
    ///   - perform: Action to be performed on alert completion
    public func alert(title: String, message: String, onCompletion perform: (() -> Void)? = nil) {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let action = UIAlertAction(title: "OK", style: .default) { _ in perform?() }
//        alert.view.tintColor = AppData.Color.proactiveGreen.uiColor
//        alert.addAction(action)
//        present(alert, animated: true)
    }
    
    /// Customized alert message with button
    ///
    /// - Parameters:
    ///   - title: Alert title
    ///   - message: Text message to be displayed
    ///   - buttonTitle: Title of the button
    ///   - perform: Action to be performed on button tap
    public func alert(title: String, message: String, buttonTitle: String, onTap perform: @escaping () -> Void) {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let action = UIAlertAction(title: buttonTitle, style: .default) { _ in perform() }
//        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
//        alert.view.tintColor = AppData.Color.proactiveGreen.uiColor
//        alert.addAction(actionCancel)
//        alert.addAction(action)
//        present(alert, animated: true)
    }
    //
    //    /// Display loading animation and disable interaction with `view`
    //    public func enableLoadingState() {
    //        UIApplication.shared.keyWindow?.addSubview(LoadingStateView())
    //    }
    //
    //    /// Hide loading animation and get back to `view`
    //    public func disableLoadingState() {
    //        UIApplication.shared.keyWindow?.subviews.filter { $0 is LoadingStateView } .forEach { $0.removeFromSuperview() }
    //    }
}
