//
//  TransferAbstractDocumentsProtocol.swift
//  TransfersVIP
//
//  Created by psuser on 03/09/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

protocol TransferAbstractDocumentsProtocol: class {
    var documentActionsService: DocumentActionsService { get }
    var presenter: TransferWorkPresenterInput { get }
    
    var totalRows: Int { get set }
    var count: Int { get set }
    var pageToLoad: Int { get set }
    var page: Pages? { get set }
    func setPage(page: Pages)
    
    var workDocuments: [TransferProtocol] { get set }
    func getWorkDocuments()
    
    init(
        presenter: TransferWorkPresenterInput,
        documentActionsService: DocumentActionsService
    )
}
extension TransferAbstractDocumentsProtocol {
    
    var workDocuments: [TransferProtocol] {
        return []
    }
    
    func getWorkDocuments() {
        guard let page = page else { fatalError("page must have value") }
        let documentTypes: [Constants.DocumentType] = [.accountTransfer, .domesticTransfer, .internationTransfer, .standingOrder, .paymentOrder, .exposedOrder,.paymentsRevokes, .invoice, .demand, .fortex]

        documentActionsService.loadWorkDocuments(pageToLoad: pageToLoad, page: page, documentTypes: documentTypes) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let workDocuments):
                self.pageToLoad += 1
                workDocuments.rows.forEach {self.workDocuments.append($0) }
                self.count = workDocuments.rows.count
                self.totalRows = workDocuments.total.count
                dump("WORK DOCUMENTS")
                dump(self.workDocuments.count)
                self.presenter.setWorkDocuments(documents: self.workDocuments)
            case .failure(let error):
                self.presenter.showError(message: error.localizedDescription)
            }
        }
    }
}





























import Alamofire


/// Provider of the default action implementations
class DefaultDocumentActionsProvider {
    
    /// Completion callback type for remote action
    typealias CompletionCallback = (_ success: Bool, _ errorMessage: String?) -> Void
    
    // Docuemnt data:
    var documentId: Int?
    var documentIds: [Int]?
    var documentType: Constants.DocumentType?
    var signFactors: [String]?
    
    private var signConfirmationsOrder = 0
    
    /// Get default remote action
    /// (requires `documentId` and `documentType`)
    ///
    /// - Parameter action: action type
    /// - Returns: function
    func getRemote(action: ParsedActions.Actions) -> ((_ completionCallback: @escaping CompletionCallback) -> Void)? {
        guard let documentId = documentId,
            let documentType = documentType?.rawValue else {
                return nil
        }
        
        let actionName = action.rawValue
        
        return { completionCallback in
            let url = baseURL + "api/workflow/documentAction"
            let parameters: [String: Any] = [
                "documentId": documentId,
                "documentType": documentType,
                "action": actionName
            ]
            
            sessionManager.request(
                url,
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default
                ).validate().responseString {[weak self] response in
                    log(serverResponse: response)
                    if response.result.isSuccess {
                        self?.setNeedsUpdateAccountsIfNeeded(for: action)
                        completionCallback(true, nil)
                    } else if let data = response.data,
                        let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? AnyDict,
                        let message = jsonData?["message"] as? String {
                        completionCallback(false, message)
                    } else {
                        completionCallback(false, contentErrorMessage)
                    }
            }
        }
    }
    
    /// Default send document to server action
    /// (requires `documentType`)
    /// Applicable for saving of a new and existing document
    var sendDocumentToServerAction: ((_ parameters: [String: Any], _ completionCallback: @escaping CompletionCallback) -> Void)? {
        guard let documentType = documentType else {
            return nil
        }
        
        let urlDocumentType: String
        switch documentType {
        case .accountTransfer: urlDocumentType = "api/payment/account-transfer"
        case .domesticTransfer: urlDocumentType = "api/payment/domestic-transfer"
        case .internationTransfer: urlDocumentType = "api/payment/international-transfer"
        case .standingOrder: urlDocumentType = "api/standing-order"
        case .paymentOrder: return nil
        case .exposedOrder: urlDocumentType = "api/exposedorder"
        case .paymentsRevokes: urlDocumentType = "api/customer/documents/document-withdraw"
        case .invoice: urlDocumentType = "api/invoice"
        case .demand: urlDocumentType = "api/demand"
        case .fortex: urlDocumentType = "api/fortex"
        }
        
        let urlDocumentIdentifier: String
        if let documentId = documentId {
            if documentType == .exposedOrder || documentType == .demand {
                urlDocumentIdentifier = ""
            } else {
                urlDocumentIdentifier = String(documentId)
            }
        } else if documentType == .demand {
            urlDocumentIdentifier = ""
        } else {
            urlDocumentIdentifier = "new"
        }
        
        let urlString = baseURL + urlDocumentType + "/" + urlDocumentIdentifier
        
        return { [weak self, documentId] parameters, completionCallback in
            let method: HTTPMethod
            var requestParameters = parameters
            if let documentId = documentId, documentType == .exposedOrder || documentType == .demand {
                method = .put
                requestParameters["id"] = documentId
            } else {
                method = .post
            }
            
            let request = sessionManager.request(
                urlString,
                method: method,
                parameters: requestParameters,
                encoding: JSONEncoding.default
            )
            
            request.validate().response { dataResponse in
                defaultLog(defaultResponse: dataResponse)
                guard let statusCode = dataResponse.response?.statusCode, 200..<300 ~= statusCode else {
                    let errorMessage: String
                    if let data = dataResponse.data,
                        let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                        let dict  = jsonObject as? [String: Any],
                        let message = dict["message"] as? String {
                        if message == Constants.ServerError.internalError.rawValue {
                            errorMessage = "Сервер не отвечает. Попробуйте позже!"
                        } else if message == Constants.ServerError.validation.rawValue {
                            errorMessage = dict["description"] as? String ?? "Проверьте правильность заполнения полей"
                        }  else {
                            errorMessage = message
                        }
                    } else {
                        errorMessage = contentErrorMessage
                    }
                    completionCallback(false, errorMessage)
                    return
                }
                self?.setNeedsUpdateAccountsIfNeeded(for: .edit)
                completionCallback(true, nil)
            }
        }
    }
    
    /// Action to view document history
    /// (requires `documentId` and `navigationController`)
    var openDocumentHistoryPageAction: ((_ navigationController: UINavigationController) -> Void)? {
        guard let documentId = documentId else {
            return nil
        }
        
        return { navigationController in
//            if let controller = UINib.controller(controller: DocumetnHistoryViewController.self) {
//                controller.documentID = documentId
//                navigationController.pushViewController(controller, animated: true)
//            } else {
//                navigationController.topViewController?.presentErrorController(title: "Ошибка", message: contentErrorMessage)
//            }
        }
    }
    
    /// Action to launch document signing process
    /// (requires `signFactors`)
    var documentSigningAction: ((_ viewController: UIViewController, _ completionCallback: @escaping CompletionCallback) -> Void)? {
        guard let signFactors = signFactors else {
            return nil
        }
        
        return { [unowned self] viewController, completionCallback in
            if !signFactors.isEmpty {
                self.signConfirmationsOrder = 0
                self.showNextSigningForm(from: viewController, completionCallback: completionCallback)
            } else {
                viewController.presentErrorController(title: "Ошибка", message: contentErrorMessage)
            }
        }
    }
    
    /// Show next document signing form
    ///
    /// - Parameters:
    ///   - viewController: view controller to present signing form
    ///   - completionCallback: on completion callback
    private func showNextSigningForm(from viewController: UIViewController, completionCallback: @escaping CompletionCallback) {
        guard let factors = signFactors else {
            return
        }
        
        guard factors.count >= signConfirmationsOrder + 1 else {
            completionCallback(true, nil)
           // AppState.sharedInstance.documentPageTypesToUpdate.insert(AppState.DocumentPageType.working.rawValue)
            return
        }
        
        guard let authentificationType = Constants.AuthentificationType(rawValue: factors[signConfirmationsOrder]) else { return }
        
        switch authentificationType {
        case .generator: displayOTPForm(for: viewController, completionCallback: completionCallback)
        case .sms: displaySMSForm(for: viewController, completionCallback: completionCallback)
        default: break
        }
    }
    
    /// Display OTP form for document signing
    ///
    /// - Parameters:
    ///   - viewController: view controller to present OTP form
    ///   - completionCallback: on completion callback
    private func displayOTPForm(for viewController: UIViewController, completionCallback: @escaping CompletionCallback) {
        guard let documentIds = documentIds else {
            return
        }
      
    }
    
    /// Display SMS form for document signing
    ///
    /// - Parameters:
    ///   - viewController: view controller to present SMS form
    ///   - completionCallback: on completion callback
    private func displaySMSForm(for viewController: UIViewController, completionCallback: @escaping CompletionCallback) {
        guard let documentIds = documentIds else {
            return
        }
    }
    
    private func setNeedsUpdateAccountsIfNeeded(for actionType: ParsedActions.Actions) {
        switch actionType {
        case .remove, .edit:
            AppState.sharedInstance.shouldUpdateAccounts = true
        default:
            break
        }
    }
}

