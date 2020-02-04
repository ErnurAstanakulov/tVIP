//
//  TransferWorkIteractor.swift
//  TransfersVIP
//
//  Created by psuser on 31/08/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import UIKit

class TransferWorkIteractor {
    private(set) var presenter: TransferWorkPresenterInput
    typealias CompletionCallback = (_ success: Bool, _ errorMessage: String?) -> Void
    let documentActionsService: DocumentActionsService
    var page: Pages?
    private var documentIds: [Int]?
    private var authFactors: [Constants.AuthentificationType] = []
    var totalRows: Int = 0
    var count: Int = 0
    var pageToLoad: Int = 0
    var isDataSourceLoaded = false
    var localDataSource: [TransferProtocol] = []
    var workDocuments: [TransferProtocol] = []
    
    required init(
        presenter: TransferWorkPresenterInput,
        documentActionsService: DocumentActionsService
    ) {
        self.presenter = presenter
        self.documentActionsService = documentActionsService
    }
}
extension TransferWorkIteractor: TransferWorkIteractorInput {
    
    func setPage(page: Pages) {
        self.page = page
    }
    
    func showAlert(id: Int, _ selectedDocument: WorkDocumentsModel) {
        
        var actions = selectedDocument.actions!
        if actions.contains(.print) { actions.remove(object: .print) }
        
        if let index = actions.index(of: .remove) {
            actions.remove(at: index)
            actions.append(.remove)
        }
        
        var documentActions: [UIAlertAction] = []
        actions.forEach({ action in
            let style: UIAlertAction.Style = action == .remove ? .destructive : .default
            let documentAction = UIAlertAction(title: ParsedActions.localizationForAction(action).rawValue, style: style, handler: { [unowned self] _ in
                switch action {
                case .toDraft, .submit, .remove, .sentToRBS, .sentToReceiver:
                    guard let type = selectedDocument.docType?.code else { return }
                    self.performRemoteAction(action, documentId: id, documentType: type)
                case .edit, .view:
                    self.showDocument(document: selectedDocument, createRegular: false, toEdit: action == .edit, isCopy: false)
                case .sign:
                    if let signFactors = selectedDocument.signFactors, !signFactors.isEmpty {
                        guard let authFactors = self.convertToFactorType(signFactors) else { fatalError("authFactors unknown")}
                        self.authFactors = authFactors
                        self.performAuthFactors(documentIds: [id], authFactors: authFactors)
                    } else {
                        guard let type = selectedDocument.docType?.code else { return }
                        self.performRemoteAction(action, documentId: id, documentType: type)
                    }
                case .creteCopy:
                    self.showDocument(document: selectedDocument, createRegular: false, toEdit: false, isCopy: true)
                case .history:
                    self.showHistoryViewController(id: selectedDocument.id)
                case .createStandingOrder:
                    // создать регулярный перевод
                    self.showDocument(document: selectedDocument, createRegular: true, toEdit: false, isCopy: false)
                case .sentForRevokation:
                    self.documentRevocation(document: selectedDocument)
                default:
                    self.presenter.showError(message: "Функционал в разработке")
                }
            })
            documentActions.append(documentAction)
        })
        self.presenter.showAlertController(action: documentActions)
    }
}

extension TransferWorkIteractor {
    
    func onRefresh() {
       pageToLoad = 0
       getWorkDocuments()
    }
    
    func performPagination(index: Int) {
        if (index == count - 1 && count != 0 && count < totalRows) {
            self.getWorkDocuments()
        }
    }
    
    private func loadGetRemoteAction(documentId: Int,
                                     action: ParsedActions.Actions,
                                     documentType: Constants.DocumentType,
                                     complation: @escaping CompletionCallback){
    
        
    }
    
}
extension TransferWorkIteractor: TransferAbstractDocumentActionsProtocol {
    
    func performRemoteAction(_ actionKey: ParsedActions.Actions, documentId: Int, documentType: Constants.DocumentType) {
        presenter.startLoading()
        documentActionsService.performRemoteAction(actionKey, documentId: documentId, documentType: documentType) { [weak self] (result) in
            guard let interactor = self else { return }
            interactor.presenter.stopLoading()
            switch result {
            case .success(_):
                interactor.presenter.reloadWorkDocuments()
            case .failure(let error):
                interactor.presenter.showError(message: error.localizedDescription)
            }
        }
    }
    
    func showDocument(document: WorkDocumentsModel, createRegular: Bool, toEdit: Bool, isCopy: Bool) {
        presenter.startLoading()
        documentActionsService.viewOrEditTransferDocument(document: document, isEdit: toEdit, isCopy: isCopy) { [weak self] (result) in
            guard let interactor = self else {return}
            interactor.presenter.stopLoading()
            switch result {
            case .success(let viewModel):
                interactor.presenter.setPaymentTransfer(viewModel: viewModel, with: "title")
            case .failure(let error):
                interactor.presenter.showError(message: error.localizedDescription)
            }
        }
    }
    
    private func performSigning(value: String, documentIds: [Int], authentificationType: Constants.AuthentificationType) {
        documentActionsService.performSigningByFactor(value: value, documentIds: documentIds, authentificationType: authentificationType) { [weak self] (result) in
            guard let interactor = self else {return}
            interactor.presenter.stopLoading()
            switch result {
            case .success(let signFactor):
                let filterFactors = interactor.authFactors.filter { $0 != authentificationType }
                switch signFactor {
                case .sms:
                    interactor.performAuthFactors(documentIds: documentIds, authFactors: filterFactors)
                case .generator:
                    interactor.performAuthFactors(documentIds: documentIds, authFactors: filterFactors)
                default: fatalError()
                }
            case .failure(let error):
                interactor.presenter.showError(message: error.localizedDescription)
            }
        }
    }
    
    func performAuthFactors(documentIds: [Int], authFactors: [Constants.AuthentificationType]) {
        guard authFactors.count > 0, let authentificationType = authFactors.first else {
            presenter.reloadWorkDocuments()
            return
        }
        self.documentIds = documentIds
        presenter.startLoading()
        documentActionsService.performAuthFactors(authentificationType: authentificationType) { [weak self] (result) in
            guard let interactor = self else {return}
            interactor.presenter.stopLoading()
            switch result {
            case .success(let signFactor):
                switch signFactor {
                case .sms: interactor.presenter.showSMSForm(false)
                case .generator: interactor.presenter.showOTPForm(false)
                default: fatalError()
                }
            case .failure(let error):
                interactor.presenter.showError(message: error.localizedDescription)
            }
        }
    }
    
    private func convertToFactorType(_ signFactors: [String]) -> [Constants.AuthentificationType]? {
        return signFactors.compactMap { Constants.AuthentificationType(rawValue: $0) }
    }
    
    func showHistoryViewController(id: Int) {
        presenter.showHistoryViewController(id: id)
    }
    
    func documentRevocation(document: WorkDocumentsModel) {
        documentActionsService.performRevocationTransferDocument(document: document) { [weak self] (result) in
            guard let interactor = self else { return }
            switch result {
            case .success(let viewModel):
                interactor.presenter.setPaymentTransfer(viewModel: viewModel, with: "Отзыв")
            case .failure(let error):
                interactor.presenter.showError(message: error.localizedDescription)
            }
        }
    }
    
    func synchronizeOTP() {
        
    }
    
    func onPassOTP(_ token: String) {
        guard let documentIds = documentIds else { fatalError() }
        performSigning(value: token, documentIds: documentIds, authentificationType: .generator)
    }
    
    func onPassSMS(_ code: String) {
        guard let documentIds = documentIds else { fatalError() }
        performSigning(value: code, documentIds: documentIds, authentificationType: .sms)
    }

}
