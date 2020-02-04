//
//  BaseTransferInteractorInput.swift
//  TransfersVIP
//
//  Created by psuser on 25/09/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation
protocol BaseSetTransferInteractorInput {
    func setTemplateName(name: String?)
    func saveDocument()
    func saveDocumentAsRoughCopy()
}
protocol BaseTransferInteractorInput: class {
    associatedtype viewModelType: OperationViewModel
    var viewModel: viewModelType { get set }
    var presenter: BasePresenterInput { get }
    var networkService: NetworkService { get }
    var documentActionsManager: DocumentActionsService { get }
    var defaultActions: [DocumentActionData] { get }
    
    func setAlertTableViewByCells(isDraft: Bool, message: String)
    func saveDocument()
    func setErrorMessage(message: String?)
    func performActionWithClose(shouldUpdateAccounts: Bool)
    func saveDocumentAsRoughCopy()
    func saveDocumentAsTemplate()
    func setTemplateName(name: String?)
    init(
        presenter: BasePresenterInput,
        networkService: NetworkService,
        documentActionsManager: DocumentActionsService,
        viewModel: viewModelType
    )
}
extension BaseTransferInteractorInput {
    
    var defaultActions: [DocumentActionData] {
        return [
            .init(type: .edit, callback: saveDocument),
            .init(type: .editTemplate, callback: saveDocumentAsTemplate)
        ]
    }
    
    func saveDocument() {
        guard viewModel.componentsAreValid else {
            self.setAlertTableViewByCells(isDraft: true, message: "Обязательные поля не заполнены, сохранить как черновик?")
            return
        }
        let new = DocumemtState.new
        documentActionsManager.redBalanceValidate(viewModel: viewModel) { [weak self] result in
            guard let interactor = self else { return }
            switch result {
            case .success():
                if let documentNumber = interactor.viewModel.documentNumber, !documentNumber.isEmpty {
                    sendDocumentToServer(interactor: interactor)
                } else {
                    interactor.viewModel.requestDocumentNumber { [weak interactor] success, errorMessage in
                        guard let interactor = self else { return }
                        guard success else {
                            interactor.setErrorMessage(message: errorMessage)
                            return
                        }
                        sendDocumentToServer(interactor: interactor)
                    }
                }
            case .failure(let error):
                interactor.setAlertTableViewByCells(isDraft: false, message: error.localizedDescription)
            }
        }
        
        // Local function
        func sendDocumentToServer(interactor: Self) {
            interactor.documentActionsManager.sendDocumentToServer(viewModel: interactor.viewModel, with: new) { [weak interactor] result in
                switch result {
                case .success(): interactor?.performActionWithClose(shouldUpdateAccounts: true)
                case .failure(let error):
                    let message: String
                    if let networkError = error as? NetworkError {
                        message = networkError.description
                    } else {
                        message = error.localizedDescription
                    }
                    interactor?.setErrorMessage(message: message)
                }
            }
        }
    }
    
    func setAlertTableViewByCells(isDraft: Bool, message: String) {
        presenter.setAlertTableViewByCells(isDraft: isDraft, message: message)
    }
    
    func setErrorMessage(message: String?) {
        presenter.setErrorMessage(message: message)
    }
    
    func performActionWithClose(shouldUpdateAccounts: Bool) {
        presenter.performActionWithClose(shouldUpdateAccounts: shouldUpdateAccounts)
    }
    
    func saveDocumentAsRoughCopy() {
        let draft = DocumemtState.draft
        documentActionsManager.sendDocumentToServer(viewModel: viewModel, with: draft) { [weak self] result in
            guard let interactor = self else { return }
            switch result {
            case .success():
                interactor.performActionWithClose(shouldUpdateAccounts: false)
            case .failure(let error):
                interactor.setAlertTableViewByCells(isDraft: false, message: error.localizedDescription)
                //interactor.presenter.showError(error)
            }
        }
    }
    
    func saveDocumentAsTemplate() {
        // should be viewModel == viewModel is InternationalTransferViewModel
        guard viewModel.componentsAreValid || viewModel is DomesticTransferViewModel  else {
            setErrorMessage(message: "Проверьте правильность заполнения полей")
            return
        }
        let name = viewModel.jsonParameters["templateName"] as? String
        presenter.setTemplateAlert(existTemplateName: name)
    }
    
    func setTemplateName(name: String?) {
        guard let name = name else {
            setErrorMessage(message: "Проверьте правильность заполнения полей")
            return
        }
        let template = DocumemtState.template(name)
        documentActionsManager.sendDocumentToServer(viewModel: viewModel, with: template) { [weak self] result in
            guard let interactor = self else { return }
            switch result {
            case .success():
                interactor.performActionWithClose(shouldUpdateAccounts: false)
            case .failure(let error):
                interactor.setAlertTableViewByCells(isDraft: false, message: error.localizedDescription)
                //interactor.presenter.showError(error)
            }
        }
        
    }
}
