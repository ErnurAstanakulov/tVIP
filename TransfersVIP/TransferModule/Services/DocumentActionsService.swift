//
//  DocumentsActionService.swift
//  TransfersVIP
//
//  Created by psuser on 23/09/2019.
//  Copyright © 2019 psuser. All rights reserved.
//
import Alamofire

typealias RedBalanceParam = (amount: String, id: Int)
typealias TransferDocument = PageableResponse<WorkDocumentsModel>

enum ViewModelParameter {
    case RedBalance
    case NetworContext
}

protocol DocumentActionsServiceInput {
    var documentType: Constants.DocumentType? { get set }
    func redBalanceValidate(
        viewModel: OperationViewModel,
        onCompletion pass: @escaping (_ result: Result<Void>) -> Void
    )
    func sendDocumentToServer(
        viewModel: OperationViewModel,
        with state: DocumemtState,
        onCompletion pass: @escaping (_ result: Result<Void>) -> Void
    )
    func viewOrEditTransferDocument(
        document: WorkDocumentsModel,
        isEdit: Bool,
        isCopy: Bool,
        onCompletion pass: @escaping (_ result: Result<OperationViewModel>) -> Void
    )
    func performRemoteAction(
        _ actionKey: ParsedActions.Actions,
        documentId: Int,
        documentType: Constants.DocumentType,
        onCompletion pass: @escaping (_ result: Result<Void>) -> Void
    )
    func performSigningByFactor(
        value: String,
        documentIds: [Int],
        authentificationType: Constants.AuthentificationType,
        onCompletion pass: @escaping (_ result: Result<Constants.AuthentificationType>) -> Void
    )
    func performAuthFactors(
        authentificationType: Constants.AuthentificationType,
        onCompletion pass: @escaping (_ result: Result<Constants.AuthentificationType>) -> Void
    )
    func performRevocationTransferDocument(
        document: WorkDocumentsModel,
        onCompletion pass: @escaping (_ result: Result<PaymentRevokeViewModel>) -> Void
    )
}

protocol WorkDocumentActionsServiceInput {
    func loadWorkDocuments(
        pageToLoad: Int,
        page: Pages,
        documentTypes: [Constants.DocumentType],
        onCompletion pass: @escaping (_ result: Result<TransferDocument>) -> ()
    )
}

class DocumentActionsService: DocumentActionsServiceInput {
    
    let networkService: NetworkService
    var documentType: Constants.DocumentType?

    init(
        networkService: NetworkService,
        _ documentType: Constants.DocumentType? = nil
    ) {
        self.networkService = networkService
        self.documentType = documentType
    }
    
    func redBalanceValidate(
        viewModel: OperationViewModel,
        onCompletion pass: @escaping (_ result: Result<Void>) -> Void
    ) {
        guard let model: RedBalanceParam = getViewModelParameter(type: .RedBalance, viewModel: viewModel) else {
            let error: NetworkError = .serverError(description: contentErrorMessage)
            pass(.failure(error))
            return
        }

        let networkContext = ValidateRedBalanceNetworkContext(amount: model.amount, with: model.id)
        networkService.load(context: networkContext) { (networkResponse) in
            let errorText = networkResponse.json?["errorText"] as? String
            guard networkResponse.isSuccess,
                  let text = errorText,
                  text.isEmpty
            else {
                
                let error: NetworkError = (errorText != nil) ? .serverError(description: errorText ?? "") : networkResponse.networkError ?? .unknown
                
                pass(.failure(error))
                return
            }
            pass(.success(()))
        }
    }
    
    func sendDocumentToServer(
        viewModel: OperationViewModel,
        with state: DocumemtState,
        onCompletion pass: @escaping (_ result: Result<Void>) -> Void
    ) {
        guard let documentType = documentType else {
            let error: NetworkError = .serverError(description: contentErrorMessage)
            pass(.failure(error))
            return
        }
        
        let jsonParameters = viewModel.jsonParameters
        let networkContext: NetworkContext
        switch documentType {
        case .accountTransfer: networkContext = AccountPaymentTransferNetworkContext(parameters: jsonParameters)
        case .domesticTransfer: networkContext = DomesticPaymentTransferNetworkContext(parameters: jsonParameters, state: state)
        case .internationTransfer: networkContext = InternationalPaymentTransferNetworkContext(parameters: jsonParameters, state: state)
        case .standingOrder: networkContext = StandingOrderPaymentTransferNetworkContext(parameters: jsonParameters, state: state)
        case .paymentOrder: return
        case .exposedOrder: networkContext = ExposedOrderPaymentTransferNetworkContext(parameters: jsonParameters, state: state)
        case .paymentsRevokes: networkContext = RevokesPaymentTransferNetworkContext(parameters: jsonParameters, state: state)
        case .invoice: networkContext = InvoicePaymentTransferNetworkContext(parameters: jsonParameters, state: state)
        default: return
        }
        
        networkService.load(context: networkContext) { (networkResponse) in
            guard networkResponse.isSuccess else {
                let message = networkResponse.json?["message"] as? String
                let error: NetworkError = (message != nil) ? .serverError(description: message ?? "") : networkResponse.networkError ?? .unknown
                pass(.failure(error))
                return
            }
            pass(.success(()))
        }
    }
    
    func viewOrEditTransferDocument(
        document: WorkDocumentsModel,
        isEdit: Bool,
        isCopy: Bool,
        onCompletion pass: @escaping (Result<OperationViewModel>) -> Void
    ) {
        
        guard let networkContext: NetworkContext = getNetworkContext(document: document, isCopy: isCopy) else {
            let error: NetworkError = .serverError(description: contentErrorMessage)
            pass(.failure(error))
            return
        }
        
        networkService.load(context: networkContext) { [weak self ] (networkResponse) in
            guard let self = self else { return }
            guard networkResponse.isSuccess,
                let model = networkResponse.json,
                let viewModel = self.getViewModel(of: document, model: model, isEdit: isEdit)
            else {
                pass(.failure(networkResponse.networkError ?? .unknown))
                return
            }

            self.loadInitialData(viewModel: viewModel) { (networkResponse) in
                switch networkResponse {
                case .success(_):
                    pass(.success(viewModel))
                case .failure(let error):
                    pass(.failure(error))
                }
                
            }
        }
    }
    
    func loadInitialData(viewModel: OperationViewModelDataLoadable,
                         onCompletion pass: @escaping (Result<Void>) -> Void) {
        viewModel.loadInitialData { [weak self] success, errorMessage in
            guard success else {
                let error = NetworkError.serverError(description: errorMessage ?? contentErrorMessage)
                pass(.failure(error))
                return
            }
            pass(.success(()))
        }

    }
    
    func performRemoteAction(
        _ actionKey: ParsedActions.Actions,
        documentId: Int,
        documentType: Constants.DocumentType,
        onCompletion pass: @escaping (_ result: Result<Void>) -> Void
    ) {
        let networkContext = WorkFlowDocumentNetworkContext(documentId: documentId, documentType: documentType.rawValue, actionName: actionKey.rawValue)
        networkService.load(context: networkContext) { [weak self] (networkResponse) in
            
            guard let self = self else {
                return
            }
            
            guard networkResponse.isSuccess else {
                pass(.failure(networkResponse.networkError ?? .unknown))
                return
            }
            
            self.setNeedsUpdateAccountsIfNeeded(for: actionKey)
            pass(.success(()))
        }
    }
    
    func performRevocationTransferDocument(
        document: WorkDocumentsModel,
        onCompletion pass: @escaping (_ result: Result<PaymentRevokeViewModel>) -> Void
    ) {
        
        let networkContext = LoadPaymentsDocumentWithDrawNetworkContext(id: document.id)
        
        networkService.load(context: networkContext) { [weak self] (networkResponse) in
            
            guard let self = self else {
                return
            }
            
            guard networkResponse.isSuccess,
                let json = networkResponse.json,
                let initialDocument = PaymentsRevokeDetail(JSON: json) else {
                pass(.failure(networkResponse.networkError ?? .unknown))
                return
            }
            let viewModel = PaymentRevokeViewModel(initialDocument: initialDocument)
            self.loadInitialData(viewModel: viewModel) { (networkResponse) in
                switch networkResponse {
                case .success(_):
                    pass(.success(viewModel))
                case .failure(let error):
                    pass(.failure(error))
                }
                
            }
        }
        
    }
    
    func performSigningByFactor(value: String, documentIds: [Int], authentificationType: Constants.AuthentificationType, onCompletion pass: @escaping (Result<Constants.AuthentificationType>) -> Void) {

        switch authentificationType {
        case .sms:
            loadSigningSMSAuthFactor(code: value, with: documentIds[0], onCompletion: pass)
        case .generator:
            loadSigningOTPAuthFactor(code: value, with: documentIds[0], onCompletion: pass)
        default:
            break
        }
    }
    
    private func loadSigningSMSAuthFactor(code: String, with id: Int, onCompletion pass: @escaping (Result<Constants.AuthentificationType>) -> Void) {
        let networkContext = SingingCheckSMSNetworkContext(code: code, with: id)
        networkService.load(context: networkContext) { (networkResponse) in
            
            guard networkResponse.isSuccess else {
                pass(.failure(NetworkError.dataLoad))
                return
            }
            pass(.success((.sms)))
        }
    }
    
    private func loadSigningOTPAuthFactor(code: String, with id: Int, onCompletion pass: @escaping (Result<Constants.AuthentificationType>) -> Void) {
        let networkContext = SingingCheckOTPNetworkContext(code: code, with: id)
        networkService.load(context: networkContext) { (networkResponse) in
            
            guard networkResponse.isSuccess else {
                pass(.failure(NetworkError.dataLoad))
                return
            }
            pass(.success((.generator)))
        }
    }
    
    func performAuthFactors(authentificationType: Constants.AuthentificationType, onCompletion pass: @escaping (Result<Constants.AuthentificationType>) -> Void) {
        
        switch authentificationType {
        case .sms:
            onChangeSMSAuthFactor(onCompletion: pass)
        case .generator:
            pass(.success((.generator)))
        default:
            break
        }
    }
    
    private func onChangeSMSAuthFactor(onCompletion pass: @escaping (Result<Constants.AuthentificationType>) -> Void) {
        let networkContext = SingingSMSNetworkContext()
        networkService.load(context: networkContext) { (networkResponse) in
            
            guard networkResponse.isSuccess else {
                pass(.failure(NetworkError.dataLoad))
                return
            }
            pass(.success((.sms)))
        }
    }
}
extension DocumentActionsService: WorkDocumentActionsServiceInput {
    func loadWorkDocuments(
        pageToLoad: Int,
        page: Pages,
        documentTypes: [Constants.DocumentType],
        onCompletion pass: @escaping (_ result: Result<TransferDocument>) -> ()
    ) {
        
        let networkContext = WorkDocumentsNetworkContext(pageToLoad, page: page, documentTypes: documentTypes)

        networkService.load(context: networkContext) { (networkResponse) in
          guard let pageableResponse: PageableResponse<WorkDocumentsModel> = networkResponse.decode() else {
                pass(.failure(NetworkError.dataLoad))
                return
            }
            pass(.success(pageableResponse))
        }
    }
}
extension DocumentActionsService {
    
    private func getViewModelParameter<Parameter>(_ id: Int? = nil, type: ViewModelParameter, viewModel: OperationViewModel) -> Parameter? {
        let model: Parameter
        switch viewModel {
        case is DomesticTransferViewModel:
            guard let viewModel = viewModel as? DomesticTransferViewModel else { return nil }
            switch type {
            case .RedBalance:
                guard let amount = viewModel.domesticTransferToSend?.amount,
                    let accountId = viewModel.domesticTransferToSend?.account?.id else { return nil }
                model = (amount, accountId) as! Parameter
                return model
            case .NetworContext:
                guard let id = id else { return nil }
                let networkContext = LoadAccountTransfersNetworkContext(id: id, isCopy: false)
                return networkContext as! Parameter
            default: return nil
            }
        case is PayrollPaymentViewModel:
            guard let viewModel = viewModel as? PayrollPaymentViewModel else { return nil }
            switch type {
            case .RedBalance:
                guard let amount = viewModel.domesticTransferToSend?.amount,
                    let accountId = viewModel.domesticTransferToSend?.account?.id else { return nil }
                model = (amount, accountId) as! Parameter
                return model
            default: return nil
            }
        case is PensionPaymentViewModel:
            guard let viewModel = viewModel as? PensionPaymentViewModel else { return nil }
            switch type {
            case .RedBalance:
                guard let amount = viewModel.domesticTransferToSend?.amount,
                    let accountId = viewModel.domesticTransferToSend?.account?.id else { return nil }
                model = (amount, accountId) as! Parameter
                return model
            default: return nil
            }
        case is SocialPaymentViewModel:
            guard let viewModel = viewModel as? SocialPaymentViewModel else {
                    return nil
            }
            switch type {
            case .RedBalance:
                guard let amount = viewModel.domesticTransferToSend?.amount,
                    let accountId = viewModel.domesticTransferToSend?.account?.id else { return nil }
                model = (amount, accountId) as! Parameter
                return model
            default: return nil
            }
        case is MedicalPaymentViewModel:
            guard let viewModel = viewModel as? MedicalPaymentViewModel else {
                    return nil
            }
            switch type {
            case .RedBalance:
                guard let amount = viewModel.domesticTransferToSend?.amount,
                    let accountId = viewModel.domesticTransferToSend?.account?.id else { return nil }
                model = (amount, accountId) as! Parameter
                return model
            default: return nil
            }
        case is InternalTransferViewModel:
            guard let viewModel = viewModel as? InternalTransferViewModel else {
                    return nil
            }
            switch type {
            case .RedBalance:
                guard let amount = viewModel.domesticTransferToSend?.amount,
                    let accountId = viewModel.domesticTransferToSend?.account?.id else { return nil }
                model = (amount, accountId) as! Parameter
                return model
            default: return nil
            }
        case is InternationalTransferViewModel:
            guard let viewModel = viewModel as? InternationalTransferViewModel else {
                    return nil
            }
            switch type {
            case .RedBalance:
                guard let amount = viewModel.transferToSend?.amount,
                      let accountId = viewModel.transferToSend?.account?.id else { return nil }
                model = (amount, accountId) as! Parameter
                return model
            default: return nil
            }
        case is ConversionViewModel:
            guard let viewModel = viewModel as? ConversionViewModel else {
                return nil
            }
            switch type {
            case .RedBalance:
                guard let isDebitSum = viewModel.conversionToSend?.fixDebitSum,
                      let amount = isDebitSum ? viewModel.conversionToSend?.amount : viewModel.conversionToSend?.creditSum,
                      let accountId = viewModel.conversionToSend?.account?.id else { return nil }
                model = (amount, accountId) as! Parameter
                return model
            default: return nil
            }
        default:
            fatalError("viewModel not set")
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
    
    private func getViewModel(of document: WorkDocumentsModel, model: [String: Any], isEdit: Bool) -> (OperationViewModel & OperationViewModelDataLoadable)? {
        guard let code = document.docType?.code else {
            return nil
        }
        var viewModel: (OperationViewModel & OperationViewModelDataLoadable)?
        switch code {
        case Constants.DocumentType.domesticTransfer:
            guard let subCode = document.domesticType?.code  else { return viewModel }
            switch subCode {
            case Constants.PaymentTypes.paymentOrder:
                let domesticViewModel = DomesticTransferViewModel()
                domesticViewModel.initialDocument = DomesticTransfer(JSON: model)
                domesticViewModel.isEditing = isEdit
                viewModel = domesticViewModel
            case Constants.PaymentTypes.payroll:
                let payrollViewModel = PayrollPaymentViewModel()
                payrollViewModel.initialDocument = DomesticTransfer(JSON: model)
                payrollViewModel.isEditing = isEdit
                viewModel = payrollViewModel
            case Constants.PaymentTypes.medicalContribution:
                let medicalViewModel = MedicalPaymentViewModel()
                medicalViewModel.initialDocument = DomesticTransfer(JSON: model)
                medicalViewModel.isEditing = isEdit
                viewModel = medicalViewModel
            case Constants.PaymentTypes.internalTransfer:
                let internalViewModel = InternalTransferViewModel()
                internalViewModel.initialDocument = DomesticTransfer(JSON: model)
                internalViewModel.isEditing = isEdit
                viewModel = internalViewModel
            case Constants.PaymentTypes.pensionContribution:
                let pensionViewModel = PensionPaymentViewModel()
                pensionViewModel.initialDocument = DomesticTransfer(JSON: model)
                pensionViewModel.isEditing = isEdit
                viewModel = pensionViewModel
            case Constants.PaymentTypes.socialContribution:
                let socialViewModel = SocialPaymentViewModel()
                socialViewModel.initialDocument = DomesticTransfer(JSON: model)
                socialViewModel.isEditing = isEdit
                viewModel = socialViewModel
            default:
                return viewModel
            }
        case Constants.DocumentType.accountTransfer:
            let conversionViewModel = ConversionViewModel()
            conversionViewModel.initialDocument = AccountTransfersFullModel(JSON: model)
            conversionViewModel.isEditing = isEdit
            viewModel = conversionViewModel
        case Constants.DocumentType.internationTransfer:
            let internaionalViewModel = InternationalTransferViewModel()
            internaionalViewModel.initialDocument = InternationalTransfer(JSON: model)
            internaionalViewModel.isEditing = isEdit
            viewModel = internaionalViewModel
        default:
            break
        }
        return viewModel
    }
    
    private func getNetworkContext(document: WorkDocumentsModel, isCopy: Bool) -> NetworkContext? {
        guard let code = document.docType?.code else { return nil }
        var networkContext: NetworkContext?
        switch code {
        case .domesticTransfer:
            networkContext = LoadDomesticTransferNetworkContext(id: document.id)
        case .accountTransfer:
            networkContext = LoadAccountTransfersNetworkContext(id: document.id, isCopy: isCopy)
        case .internationTransfer:
            networkContext = LoadInternationalTransferNetworkContext(id: document.id, isCopy: isCopy)
        case .exposedOrder:
            networkContext = LoadPaymentOutvoiceNetworkContext(id: document.id, isCopy: isCopy)
        case .standingOrder:
            networkContext = LoadStandingOrderNetworkContext(id: document.id, isCopy: isCopy)
        case .invoice:
            networkContext = LoadPaymentInvoiceNetworkContext(id: document.id, isCopy: isCopy)
        case .paymentsRevokes:
            networkContext = LoadPaymentsRevokeDetailNetworkContext(id: document.id, isCopy: isCopy)
        default:
            break
        }
        return networkContext
    }
}
