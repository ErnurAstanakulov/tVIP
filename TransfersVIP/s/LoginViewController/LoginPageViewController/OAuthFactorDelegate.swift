//
//  OAuthFactorDelegate.swift
//  DigitalBank
//
//  Created by psuser on 17/05/2019.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation
import UIKit
protocol OAuthFactorDelegate where Self: UIViewController {
    func fetchUserDataThenGoToMainPage()
    func pushToMainTabBarController()
    var viewModel: LoginViewModel { get }
}

extension OAuthFactorDelegate {
    
    func requestAuthFactorsForCustomer(at index: Int? = nil, and id: Int? = nil) {
        oAuthModel.setPasswordGrandType()
        oAuthModel.index = index
        oAuthModel.id = id
        viewModel.getAuthAccessToken(with: oAuthModel) { [weak self] success, factors, errorMessage in
            guard let viewController = self else { return }
            DispatchQueue.main.async {
                
                guard success else {
                    if let errorMessage = errorMessage {
                        viewController.presentErrorController(title: "Ошибка", message: errorMessage)
                    } else {
                        viewController.presentErrorController(title: "Ошибка", message: contentErrorMessage)
                    }
                    return
                }
                
                guard let factors = factors else {
                    viewController.presentErrorController(title: "Ошибка", message: contentErrorMessage)
                    return
                }
                
                switch factors.count {
                case 0: viewController.fetchUserDataThenGoToMainPage()
                default: viewController.displayList(titles: factors, canSkip: AuthorizationAdapter.shared.canSkip ?? false)
                }
            }
        }
    }
    
    internal func displayList(titles: [String], canSkip: Bool = false) {
//        let pickerListViewController: PickerListViewController
//        if canSkip {
//            let authFactorsPickerListViewController = AuthFactorsPickerListViewController()
//            authFactorsPickerListViewController.performOnSkipButtonPress = { [weak self, unowned authFactorsPickerListViewController] in
//                self?.viewModel.skipCurrentAuthFactor { success, errorMessage in
//
//                    guard let viewController = self else { return }
//                    DispatchQueue.main.async {
//                        guard success else {
//                            if let errorMessage = errorMessage {
//                                viewController.presentErrorController(title: "Ошибка", message: errorMessage)
//                            } else {
//                                viewController.presentErrorController(title: "Ошибка", message: contentErrorMessage)
//                            }
//                            return
//                        }
//
//                        authFactorsPickerListViewController.dismiss(animated: true) {
//                            viewController.fetchUserDataThenGoToMainPage()
//                        }
//                    }
//                }
//            }
//
//            pickerListViewController = authFactorsPickerListViewController
//        } else {
//            pickerListViewController = PickerListViewController()
//        }
//        pickerListViewController.pickerDescription = "Выберите фактор аутентификации"
//        pickerListViewController.values = titles.filter { $0.count > 0 }
//        pickerListViewController.performOnPick = { [unowned pickerListViewController] index in
//            DispatchQueue.main.async {
//                let adapter = AuthorizationAdapter.shared
//                let authFactorRoles = adapter.authFactors?.map { $0.filter { $0.rawValue != adapter.lastAuthFactor }}.filter{ $0?.count ?? 0 > 0}
//                guard let authFactorRole = authFactorRoles, authFactorRole.count > index else {return}
//                let factorChains = authFactorRole[index]
//                let factors = factorChains.filter { $0.rawValue != adapter.lastAuthFactor }
//                oAuthModel.isMultiple = factors.count > 1 ? true : false
//                if let factorType = factors.first {
//                    switch factorType {
//                    case .Generator:
//                        pickerListViewController.dismiss(animated: true) {
//                            self.displayOTPForm()
//                        }
//                    case .SMS:
//                        pickerListViewController.dismiss(animated: true) {
//                            self.displaySMSForm()
//                        }
//                    default:
//                        self.displayAuthFactorIsNotAvilableMessage(factorTitle: titles[index])
//                        break
//                    }
//                }
//            }
//        }
//        pickerListViewController.performOnClose = performLogOut
//        pickerListViewController.modalPresentationStyle = .overCurrentContext
//        pickerListViewController.modalTransitionStyle = .crossDissolve
//        self.present(pickerListViewController, animated: true)
    }
    
    internal func displayOTPForm() {
//        let otpViewController = OTPViewController()
//        otpViewController.performOnCompletion = { [unowned otpViewController] success, errorMessage in
//            guard success else {
//                otpViewController.presentErrorController(title: "Ошибка", message: errorMessage)
//                return
//            }
//            self.checkOAuthFactor(with: otpViewController.otpFormView.codeTextField.text, isSMS: false)
//        }
//        otpViewController.performOnClose = performLogOut
//        otpViewController.modalPresentationStyle = .overFullScreen
//        otpViewController.modalTransitionStyle = .crossDissolve
//        self.present(otpViewController, animated: true)
    }
    
    internal func displaySMSForm() {
//        Loader.shared.show()
//        SMSViewModel.requestAuthSMSCode { [weak self] success, errorMessage in
//            Loader.shared.hide()
//            guard let viewController = self else { return }
//            guard success else {
//                viewController.presentErrorController(title: errorMessage, message: nil)
//                return
//            }
//
//            let smsViewController = SMSViewController()
//            smsViewController.performOnCompletion = { [unowned smsViewController] success, errorMessageOrCode in
//                guard success else {
//                    smsViewController.presentErrorController(title: "Ошибка", message: errorMessageOrCode)
//                    return
//                }
//
//                viewController.checkOAuthFactor(with: errorMessageOrCode, isSMS: true)
//            }
//            smsViewController.performOnClose = performLogOut
//            smsViewController.modalTransitionStyle = .crossDissolve
//            smsViewController.modalPresentationStyle = .overFullScreen
//            viewController.present(smsViewController, animated: true, completion: nil)
//        }
    }
    
    internal func checkOAuthFactor(with code: String?, isSMS: Bool) {
        oAuthModel.resetParameters()
        if isSMS {
            oAuthModel.sms = code
            oAuthModel.setSMSGrandType()
        } else {
            oAuthModel.generator = code
            oAuthModel.setOTPGrandType()
        }
        getAccessByOAuth()
    }
    
    internal func getAccessByOAuth() {
        
        viewModel.getAuthAccessToken(with: oAuthModel) { [weak self] success, factors, errorMessage in
            guard let viewController = self else {
                return
            }
            
            DispatchQueue.main.async {
                
                guard success else {
                    if let errorMessage = errorMessage {
                        viewController.presentErrorController(title: "Ошибка", message: errorMessage)
                    } else {
                        viewController.presentErrorController(title: "Ошибка", message: contentErrorMessage)
                    }
                    return
                }
                
                guard let factors = factors else {
                    viewController.presentErrorController(title: "Ошибка", message: contentErrorMessage)
                    return
                }
                
                if !oAuthModel.isMultiple {
                    viewController.viewModel.skipCurrentAuthFactor { success, errorMessage in
                        
                        DispatchQueue.main.async {
                            guard success else {
                                if let errorMessage = errorMessage {
                                    viewController.presentErrorController(title: "Ошибка", message: errorMessage)
                                } else {
                                    viewController.presentErrorController(title: "Ошибка", message: contentErrorMessage)
                                }
                                return
                            }
                            
                            viewController.fetchUserDataThenGoToMainPage()
                        }
                    }
                } else {
                    switch factors.count {
                    case 0: viewController.fetchUserDataThenGoToMainPage()
                    default: viewController.displayList(titles: factors, canSkip: AuthorizationAdapter.shared.canSkip ?? false)
                    }
                }
                
            }
        }
    }
    
    private func displayAuthFactorIsNotAvilableMessage(factorTitle: String) {
        let message = "Фактор аутентификации \(factorTitle) находится в стадии разработки"
        self.presentErrorController(title: "Ошибка", message: message)
        return
    }
    
}
