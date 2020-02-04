//
//  BasePresenterInputProtocol.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 6/27/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation

protocol Loadable {
    func startLoading()
    func stopLoading()
}

protocol StatusPresentableProtocol {
    func showError(error: AppError, completion: VoidCompletion?)
    func showSuccess(message: String, completion: (() -> Void)?)
    func showOption(message: String, onOptionSelect perform: @escaping (_ isOkOptionSelected: Bool) -> Void)
}

protocol StatusPresenter: UISetable, Loadable {
    func showError(message: String)
    func showSuccess(message: String)
}

protocol BasePresenterInputProtocol: StatusPresentableProtocol, Loadable, ViewLoadable {
    var baseView: BaseViewInputProtocol { get }
}

extension BasePresenterInputProtocol {
    
    func showError(error: AppError, completion: VoidCompletion? = nil) {
        baseView.hideActivityIndicator()
        baseView.setUI(interactionEnabled: true)
        baseView.showError(message: error.description, completion: completion)
    }
    
    func showError(message: String) {
        baseView.hideActivityIndicator()
        baseView.setUI(interactionEnabled: true)
        baseView.showError(message: message)
    }
    
    func showSuccess(message: String, completion: (() -> Void)? = nil) {
        baseView.hideActivityIndicator()
        baseView.setUI(interactionEnabled: true)
        baseView.showSuccess(message: message, completion: completion)
    }
    
    func showOption(message: String, onOptionSelect perform: @escaping (_ isOkOptionSelected: Bool) -> Void) {
        baseView.hideActivityIndicator()
        baseView.setUI(interactionEnabled: true)
        baseView.showOption(message: message, onOptionSelect: perform)
    }
    
    func startLoading() {
        baseView.showActivityIndicator()
        baseView.setUI(interactionEnabled: false)
    }
    
    func stopLoading() {
        baseView.hideActivityIndicator()
        baseView.setUI(interactionEnabled: true)
    }
    
}
