//
//  BasePresenterInput.swift
//  TransfersVIP
//
//  Created by psuser on 10/1/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

protocol BasePresenterInput: class {
    func setAlertTableViewByCells(isDraft: Bool, message: String)
    func setErrorMessage(message: String?)
    func performActionWithClose(shouldUpdateAccounts: Bool)
    func setTemplateAlert(existTemplateName: String?)
    var view: BaseTransferViewControllerInput? { get }
}
extension BasePresenterInput {
    func setAlertTableViewByCells(isDraft: Bool, message: String) {
        view?.setAlertTableViewByCells(isDraft: isDraft, message: message)
    }
    
    func setErrorMessage(message: String?) {
        view?.setErrorMessage(message: message)
    }
    
    func performActionWithClose(shouldUpdateAccounts: Bool) {
        view?.performActionWithClose(shouldUpdateAccounts: shouldUpdateAccounts)
    }
    
    func setTemplateAlert(existTemplateName: String?) {
        view?.setTemplateAlert(existTemplateName: existTemplateName)
    }
}
