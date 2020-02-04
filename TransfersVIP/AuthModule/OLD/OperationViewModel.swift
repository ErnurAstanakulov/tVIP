//
//  OperationsCreatable.swift
//  DigitalBank
//
//  Created by Алем Утемисов on 07.05.2018.
//  Copyright © 2018 iosDeveloper. All rights reserved.
//

import Foundation
import ObjectMapper

class DocumentActionData {
    let type: ParsedActions.Actions
    let callback: () -> Void
    
    init(type: ParsedActions.Actions, callback: @escaping () -> Void) {
        self.type = type
        self.callback = callback
    }
}

enum ProductStatus: String, CaseIterable {
    case cardClosed = "9"
    case active = "1"
    case closed = "2"
    case blocked = "3"
}

protocol OperationViewModel {
    typealias Completion = (Bool, String?) -> Void
    var components: [OperationComponent] { set get }
    var visibleComponents: [OperationComponent] { get }
    var documentActionDataArray: [DocumentActionData]? { get set }
    var jsonParameters: [String: Any] { get }
    var componentsAreValid: Bool { get }
    var isEditing: Bool { get set }
    var documentNumber: String? { get }
    var viewController: OperationsTableViewControllerProtocol? { get set }
    func isValid(_ value: String?, typedText text: String, for component: OperationComponent) -> Bool
    func isValid(components: [OperationComponent]) -> Bool
    func dataSource(for component: OperationComponent) -> [OptionDataSource]?
    @discardableResult
    func switchedWithLoaded(to: Bool, component: OperationComponent, completion: Completion?) -> Bool
    @discardableResult
    func textfieldValueChangedWithLoaded(_ value: String?, component: OperationComponent, completion: Completion?) -> Bool
    @discardableResult
    func amountFieldValueChangeWithLoaded(_ value: String?, component: OperationComponent, completion: Completion?) -> Bool
    @discardableResult
    func optionSelectedWithLoaded(_ value: OptionDataSource?, component: OperationComponent, completion: Completion?) -> Bool
    func searchResults(for text: String, in component: OperationComponent, optionsDataSourceCallback: (([OptionDataSource]) -> Void)?)
    func requestDocumentNumber(onCompletion perform: @escaping (_ success: Bool, _ errorDescription: String?) -> Void)
    func saveDocument(isTemplate: Bool, onCompletion perform: @escaping (_ success: Bool, _ errorMessage: String?) -> Void)
    func getAccountStatusColor(with status: ProductStatus?, isCheckedValue: Bool) -> UIColor
    func optionSelectFile(fileURL: URL, component: OperationComponent, completion: Completion?)
    func optionUnselectFile(fileId: Int, component: OperationComponent, completion: Completion?)
}

extension OperationViewModel {
    
    var documentNumber: String? {
        return jsonParameters["number"] as? String
    }
    
    var visibleComponents: [OperationComponent] {
        return components.filter { $0.isVisible }
    }
    
    func switchedWithLoaded(to: Bool, component: OperationComponent, completion: ((Bool, String?) -> Void)?) -> Bool {
        component.setValue(newValue: to)
        changeValueDependencies(component: component, to: to)
        component.errorDescription = nil
        return false
    }
    
    func textfieldValueChangedWithLoaded(_ value: String?, component: OperationComponent, completion: ((Bool, String?) -> Void)?) -> Bool {
        component.setValue(newValue: value)
        changeValueDependencies(component: component, to: value?.isEmpty == false)
        component.errorDescription = nil
        return false
    }
    
    func amountFieldValueChangeWithLoaded(_ value: String?, component: OperationComponent, completion: ((Bool, String?) -> Void)?) -> Bool {
        guard let value = value else { return false }
        component.setValue(newValue: value)
        changeValueDependencies(component: component, to: !value.isEmpty)
        component.errorDescription = nil
        return false
    }
    
    func changeValueDependencies(component: OperationComponent, to: Bool) {
        var filteredComponents = components.filter { $0.dependecy?.name == component.name && $0.dependecy?.condition == Dependency.Condition.visibility }
        filteredComponents.forEach { $0.isVisible = to }
        while filteredComponents.count > 0 {
            filteredComponents = components.filter { comp in
                filteredComponents.contains(where: { comp.dependecy?.name == $0.name })
            }
            filteredComponents.forEach { comp in
                let dependancyComponent = self.components.first(where: { $0.name == comp.dependecy?.name })
                if let isOn: Bool = dependancyComponent?.getValue() {
                    comp.isVisible = isOn && to
                } else {
                    comp.isVisible = dependancyComponent?.value != nil && dependancyComponent?.value?.isEmpty == false && to
                }
            }
        }
    }
    
    func isValid(components: [OperationComponent]) -> Bool {
        var result: Bool = true
        for component in components {
            guard let constraints = component.constraints else { continue }
            if let error = Validator.validatingError(text: component.value, constraint: constraints) {
                component.errorDescription = error
                result = false
            }
        }
        return result
    }
    
    func isValid(_ value: String?, typedText text: String, for component: OperationComponent) -> Bool {
        return true
    }
    
    func searchResults(for text: String, in component: OperationComponent, optionsDataSourceCallback: (([OptionDataSource]) -> Void)?) {}
    
    func optionSelectFile(fileURL: URL, component: OperationComponent, completion: Completion?) {}
    func optionUnselectFile(fileId: Int, component: OperationComponent, completion: Completion?) {}
    
    func getAccountStatusColor(with status: ProductStatus?, isCheckedValue: Bool) -> UIColor {
        let defaultColor: UIColor = isCheckedValue ? UIColor.green : UIColor.darkGray
        guard let status = status else { return defaultColor }
        return status == ProductStatus.blocked ? UIColor.red : defaultColor
    }
}

protocol OperationViewModelDataLoadable {
    func loadInitialData(onCompletion perform: @escaping (_ success: Bool, _ errorDescription: String?) -> Void)
}

import Foundation

class PaymentRevokeViewModel: OperationViewModel {
    
    weak var viewController: OperationsTableViewControllerProtocol?
    var components: [OperationComponent] = []
    var director: CompanyPerson?
    var documentTypes: [CodeByDocumentType]?
    var paymentsRevokes: [PaymentsRevokesModel]?
    var selectedDocumentId: Int?
    var documentRequisites: DocumentWithdrawModel? {
        didSet {
            if documentRequisites == nil {
                component(by: .requisites).isVisible = false
            } else {
                component(by: .requisites).isVisible = true
                component(by: .requisites).setValue(newValue: documentRequisites?.withdrawInfo)
            }
        }
    }
    let initialDocument: PaymentsRevokeDetail?
    
    var dataToSend: PaymentsRevokeDetailToSend? {
        guard let director = director,
            let documentNumber = component(by: .revokeNumber).value,
            let selectedDocumentId = selectedDocumentId
            else { return nil }
        let dataToSend = PaymentsRevokeDetailToSend()
        dataToSend.director = director
        dataToSend.number = documentNumber
        dataToSend.reason = component(by: .revokeReason).value
        dataToSend.withdrawID = selectedDocumentId
        return dataToSend
    }
    
    init(initialDocument: PaymentsRevokeDetail?) {
        self.initialDocument = initialDocument
        setupComponents()
        guard let initialDocument = initialDocument else { return }
        component(by: .revokeNumber).setValue(newValue: initialDocument.number)
        component(by: .documentDate).setValue(newValue: initialDocument.created)
        component(by: .type).setValue(newValue: initialDocument.originalDocument?.type?.label)
        component(by: .documentNumber).setValue(newValue: initialDocument.originalDocument?.number)
        component(by: .revokeReason).setValue(newValue: initialDocument.reason)
        director = initialDocument.director
        selectedDocumentId = initialDocument.originalDocument?.id
    }
    
    required convenience init() {
        self.init(initialDocument: nil)
    }
    
    func dataSource(for component: OperationComponent) -> [OptionDataSource]? {
        if self.component(by: .type) == component {
            return documentTypes?.compactMap { OptionDataSource(id: $0.code, title: $0.label) }
        } else if self.component(by: .documentNumber) == component {
            return paymentsRevokes?.compactMap { OptionDataSource(id: $0.id.description, title: $0.documentNumber) }
        }
        return nil
    }
    
    func optionSelectedWithLoaded(_ value: OptionDataSource?, component: OperationComponent, completion: ((Bool, String?) -> Void)?) -> Bool {
        if self.component(by: .type) == component {
            component.setValue(newValue: value?.title)
            documentRequisites = nil
            self.component(by: .documentNumber).clearValue()
            loadDocumentNumbers(code: value?.id, onCompletion: completion)
            return true
        } else if self.component(by: .documentNumber) == component {
            component.setValue(newValue: value?.title)
            selectedDocumentId = Int(value?.id ?? "")
            documentRequisites = nil
            loadRequisitesByDocument(id: selectedDocumentId, onCompletion: completion)
            return true
        }
        component.setValue(newValue: value?.id)
        return false
    }
    
    func component(by paymentRevokeComponent: PaymentRevokeComponent) -> OperationComponent {
        return components.first(where: { $0.name == paymentRevokeComponent.rawValue })!
    }
    
    var documentActionDataArray: [DocumentActionData]? = nil
    
    var jsonParameters: [String: Any] {
        if let json = dataToSend?.toJSON() {
            return json
        }
        
        return [:]
    }
    
    var componentsAreValid: Bool {
        return isValid(components: components)
    }
    
    var isEditing = true {
        didSet {
            components.forEach { component in
                component.set(uiProperty: .isUserInteractionEnabled(isEditing))
                if !isEditing {
                    component.placeholder = "(не заполнено)"
                }
            }
        }
    }
}

enum PaymentRevokeComponent: String {
    case revokeNumber
    case documentDate
    case type
    case documentNumber
    case requisites
    case revokeReason
}
extension PaymentRevokeViewModel: OperationViewModelDataLoadable {
    
}
extension PaymentRevokeViewModel {
    
    func setupComponents() {
        components = [
            OperationComponent(type: .textfield, name: PaymentRevokeComponent.revokeNumber.rawValue, title: "№ Отзыва", placeholder: "Введите данные", constraints: BaseConstraint(isRequired: true)),
            OperationComponent(type: .label, name: PaymentRevokeComponent.documentDate.rawValue, title: "Дата документа", constraints: BaseConstraint(isRequired: true), value: initialDocument?.created ?? Date().stringWith(format: Constants.DateFormats.shortDot)),
            OperationComponent(type: .options, name: PaymentRevokeComponent.type.rawValue, title: "Тип документа", placeholder: "Выберите из списка", constraints: BaseConstraint(isRequired: true)),
            OperationComponent(type: .searchTextField, name: PaymentRevokeComponent.documentNumber.rawValue, title: "Номер основного документа", placeholder: "Выберите из списка", constraints: BaseConstraint(isRequired: true)),
            OperationComponent(type: .label, name: PaymentRevokeComponent.requisites.rawValue, title: "Реквизиты", isVisible: initialDocument != nil, value: initialDocument?.withdrawInfo),
            OperationComponent(type: .textfield, name: PaymentRevokeComponent.revokeReason.rawValue, title: "Причина отзыва", placeholder: "Введите данные", constraints: BaseConstraint(isRequired: true))
        ]
    }
    
    public func loadInitialData(onCompletion perform: @escaping (_ success: Bool, _ errorDescription: String?) -> Void) {
        let personsContext = PaymentsRevokesDetailPersonsContext()
        let typeContext = CodeByDocumentTypeContext()
        
        personsContext.load(isSuccsess: { response in
            guard let json = response as? [[AnyDict]] else {
                perform(false, nil)
                return
            }
            self.director = json.first?.compactMap{ CompanyPerson(JSON: $0) }.first
            
            typeContext.load(isSuccsess: { result in
                guard let json = result as? [AnyDict] else {
                    perform(false, nil)
                    return
                }
                self.documentTypes = json.compactMap{ CodeByDocumentType(JSON: $0) }
                
                if let code = self.initialDocument?.originalDocument?.type?.code {
                    self.loadDocumentNumbers(code: code, onCompletion: perform)
                } else {
                    self.requestDocumentNumber(onCompletion: perform)
                }
            }, ifFailed: { error in
                if let serverError = error as? ContextError {
                    perform(false, serverError.errorDescription)
                } else {
                    perform(false, error?.localizedDescription)
                }
            })
        }, ifFailed: { error in
            if let serverError = error as? ContextError {
                perform(false, serverError.errorDescription)
            } else {
                perform(false, error?.localizedDescription)
            }
        })
        
    }
    
    func requestDocumentNumber(onCompletion perform: @escaping (_ success: Bool, _ errorDescription: String?) -> Void) {
        let url = "\(baseURL)api/customer/documents/generate-number"
        sessionManager.request(url, method: .get).validate().responseString { response in
            log(serverResponse: response)
            guard let documentNumber = response.result.value else { perform(false, response.error?.localizedDescription); return }
            self.component(by: .revokeNumber).setValue(newValue: documentNumber)
            perform(true, nil)
        }
    }
    
    func loadDocumentNumbers(code: String?, onCompletion perform: ((_ success: Bool, _ errorDescription: String?) -> Void)?){
        guard let code = code else { perform?(false, nil); return }
        let context = PaymentsRevokeDetailContextByType()
        context.code = code
        context.execute(isSuccsess: { (response) in
            guard let json = response as? [[String : Any]] else { perform?(false, nil); return }
            var revokes: [PaymentsRevokesModel] = []
            json.forEach {
                if let document = PaymentsRevokesModel(JSON: $0) {
                    revokes.append(document)
                }
            }
            self.paymentsRevokes = revokes
            perform?(true, nil)
        }) { (error) in
            if let serverError = error as? ContextError {
                perform?(false, serverError.errorDescription)
            } else {
                perform?(false, error?.localizedDescription)
            }
        }
    }
    
    func loadRequisitesByDocument(id: Int?, onCompletion perform: ((_ success: Bool, _ errorDescription: String?) -> Void)?){
        guard let id = id else { perform?(false, nil); return }
        let context = PaymentsRevokesDocToWithdrawContext()
        context.id = id
        context.execute(isSuccsess: { (response) in
            guard let json = response as? [String : Any] else { perform?(false, nil); return }
            self.documentRequisites = DocumentWithdrawModel(JSON: json)
            perform?(true, nil)
        }) { (error) in
            if let serverError = error as? ContextError {
                perform?(false, serverError.errorDescription)
            } else {
                perform?(false, error?.localizedDescription)
            }
        }
    }
    
    func saveDocument(isTemplate: Bool, onCompletion perform: @escaping (_ success: Bool, _ errorMessage: String?) -> Void) {
        guard let document = dataToSend else { return }
        let saveNewContext = PaymentsRevokePostNewContext()
        saveNewContext.data = document
        saveNewContext.load(isSuccsess: { _ in
            perform(true, nil)
        }, ifFailed: { error in
            if let serverError = error as? ContextError {
                perform(false, serverError.errorDescription)
            } else {
                perform(false, error?.localizedDescription)
            }
        })
    }
    
    func resaveTransfer(onCompletion perform: @escaping (_ success: Bool, _ errorDescription: String?) -> Void) {
        guard let document = dataToSend else { return }
        let changeContext = PaymentsRevokePostContext()
        changeContext.id = initialDocument?.id
        changeContext.data = document
        changeContext.load(isSuccsess: { _ in
            perform(true, nil)
        }, ifFailed: { error in
            if let serverError = error as? ContextError {
                perform(false, serverError.errorDescription)
            } else {
                perform(false, error?.localizedDescription)
            }
        })
    }
    
}

class PaymentsRevokePostContext: Context { // FIXME: Doesn`t work properly, should put data into httpBody
    var id: Int!
    var data: PaymentsRevokeDetailToSend!
    
    override func urlString() -> String {
        return baseURL + "api/customer/documents/document-withdraw/" + String(id)
    }
    
    override func HTTPHeaders() -> [String : String]? {
        return ["content-type":"application/json"]
    }
    
    override func load(isSuccsess: @escaping Context.SuccessfulLoaded, ifFailed: Context.LoadingError?) {
        var request = URLRequest(url: URL(string: urlString())!)
        request.allHTTPHeaderFields = HTTPHeaders()
        request.httpBody = try? JSONSerialization.data(withJSONObject: data.toJSON())
        request.httpMethod = "POST"
        let validateRequest = sessionManager.request(request).validate()
        validateRequest.responseJSON { (serverResponse) in
            guard let result = serverResponse.result.value else {
                ifFailed.map { $0(serverResponse.result.error) }
                return
            }
            
            isSuccsess(result)
        }
    }
    
}

import Alamofire
class PaymentsRevokePostNewContext: Context{
    var data: PaymentsRevokeDetailToSend!
 
    override func HTTPMethod() -> HTTPMethod {
        return .post
    }
    
    override func urlString() -> String {
        return baseURL + "api/customer/documents/document-withdraw/new"
    }
    
    override func HTTPHeaders() -> [String : String]? {
        return ["content-type":"application/json"]
    }
    
    override func load(isSuccsess: @escaping Context.SuccessfulLoaded, ifFailed: Context.LoadingError?) {
        var request = URLRequest(url: URL(string: urlString())!)
        request.allHTTPHeaderFields = HTTPHeaders()
        request.httpBody = try? JSONSerialization.data(withJSONObject: data.toJSON())
        request.httpMethod = "POST"
        let validateRequest = sessionManager.request(request).validate()
        validateRequest.responseJSON { (serverResponse) in
            guard let result = serverResponse.result.value else {
                ifFailed.map { $0(serverResponse.result.error) }
                return
            }
            
            isSuccsess(result)
        }
    }
    
}

class CodeByDocumentTypeContext: Context {
    override func urlString() -> String {
        return baseURL + "/api/codes/doc-withdraw/by/DocumentType"
    }
}

class CodeByDocumentType: BaseModel {
    var deleted: Bool?
    var category: String?
    var code: String?
    var label: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        deleted <- map["deleted"]
        category <- map["category"]
        code <- map["code"]
        label <- map["label"]
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
}

class PaymentsRevokeDetail: NSObject, Mappable {
    var id: Int?
    var accountant: CompanyPerson?
    var actions: ParsedActions?
    var bankResponse: Any?
    var created: String?
    var custTaxCode: String?
    var director: CompanyPerson?
    var documentId: Int?
    var manager: CompanyPerson?
    var number: String?
    var originalDocument: OriginalDocument?
    var reason: String?
    var state: State?
    var type: Type?
    var withdrawInfo: String?
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        id <- map["id"]
        accountant <- map["accountant"]
        var actionsJSON: AnyDict = [:]
        actionsJSON <- map["actions"]
//        actions = ParsedActions(actionsJSON)
        bankResponse <- map["bankResponse"]
        created <- map["created"]
        custTaxCode <- map["custTaxCode"]
        director <- map["director"]
        documentId <- map["documentId"]
        manager <- map["manager"]
        number <- map["number"]
        originalDocument <- map["originalDocument"]
        reason <- map["reason"]
        state <- map["state"]
        type <- map["type"]
        withdrawInfo <- map["withdrawInfo"]
    }
    class Actions: Mappable { // WorkDocumentsModel actions implement
        var edit: Any?
        var remove: Any?
        var submit: Any?
        init(edit: Any?, remove: Any?, submit: Any?) {
            self.edit = edit
            self.remove = remove
            self.submit = submit
        }
        required init?(map: Map) {}
        func mapping(map: Map) {
            edit <- map["edit"]
            remove <- map["remove"]
            submit <- map["submit"]
            
        }
    }
    class OriginalDocument: BaseModel {
        var accountant: CompanyPerson?
        var bankResponse: Any?
        var created: String?
        var director: CompanyPerson?
        var manager: CompanyPerson?
        var number: String?
        var state: State?
        var type: Type?
        required init?(map: Map) {
            super.init(map: map)
        }
        init(accountant: CompanyPerson, bankResponse: Any?, created: String, director: CompanyPerson, id: Int, manager: CompanyPerson?, number: String, state: State, type: Type) {
            super.init()
            self.accountant = accountant
            self.bankResponse = bankResponse
            self.created = created
            self.director = director
            self.id = id
            self.manager = manager
            self.number = number
            self.state = state
            self.type = type
        }
        override func mapping(map: Map) {
            super.mapping(map: map)
            accountant <- map["accountant"]
            bankResponse <- map["bankResponse"]
            created <- map["created"]
            director <- map["director"]
            manager <- map["manager"]
            number <- map["number"]
            state <- map["state"]
            type <- map["type"]
        }
    }
    class State: BaseModel {// State and type are equal but if any model changes, it would be easier to fix
        var category: String?
        var code: String?
        var devared: Bool?
        var label: String?
        init(category: String, code: String, devared: Bool, id: Int, label: String) {
            super.init()
            self.category = category
            self.code = code
            self.devared = devared
            self.id = id
            self.label = label
        }
        required init?(map: Map) {
            super.init(map: map)
        }
        override func mapping(map: Map) {
            super.mapping(map: map)
            category <- map["category"]
            code <- map["code"]
            devared <- map["devared"]
            label <- map["label"]
        }
    }
    class `Type`: BaseModel {
        var category: String?
        var code: String?
        var devared: Bool?
        var label: String?
        init(category: String, code: String, devared: Bool, id: Int, label: String) {
            super.init()
            self.category = category
            self.code = code
            self.devared = devared
            self.id = id
            self.label = label
        }
        required init?(map: Map) {
            super.init(map: map)
        }
        override func mapping(map: Map) {
            super.mapping(map: map)
            category <- map["category"]
            code <- map["code"]
            devared <- map["devared"]
            id <- map["id"]
            label <- map["label"]
        }
    }
}

class PaymentsRevokeDetailToSend: Mappable{
    var accountant: CompanyPerson?
    var director: CompanyPerson?
    var number: String?
    var reason: String?
    var withdrawID: Int?
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        accountant <- map["accountant"]
        director <- map["director"]
        number <- map["number"]
        reason <- map["reason"]
        withdrawID <- map["withdrawId"]
    }
}


class DocumentWithdrawModel: NSObject, Mappable {
    
    var created: String?
    var withdrawInfo: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        created <- map["created"]
        withdrawInfo <- map["withdrawInfo"]
    }
}
class PaymentsRevokesDocToWithdrawContext: Context{
    
    var id: Int!
    
    override func urlString() -> String {
        return baseURL + "/api/customer/documents/document-withdraw/doc-to-withdraw/" + String(id)
    }
    
}
class PaymentsRevokesDetailPersonsContext: Context{
    override func urlString() -> String {
        return baseURL + "/api/customer/documents/get-sorted-persons"
    }
}

import Foundation

class PaymentsRevokesModel: BaseModel {
    
    var documentNumber: String?
    var reason: String?
    var number: String?
    var documentType: String?
    var documentTypeCode: String?
    var status: String?
    var state: StateModel?
    var documentDate: String?
    var modelActions: [String : Any]?
    var signFactors: [String]? = nil
    
    var parsedActions: ParsedActions {
        return ParsedActions(modelActions)
    }
    
    var actions: [ParsedActions.Actions] {
        return parsedActions.aviableActions
    }
    
    var localizedActions: [ParsedActions.LocalizedActions] {
        return parsedActions.aviableLocalizedActions
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        documentNumber <- map["number"]
        reason <- map["reason"]
        number <- map["withdrawDocNum"]
        documentDate <- map["created"]
        modelActions <- map["actions"]
        documentType <- map["withdrawDocType.label"]
        documentTypeCode <- map["withdrawDocType.code"]
        status <- map["state.label"]
        
        if (status == nil) {
            status <- map["state.code"]
        }
        let sign =  modelActions?["sign"] as? [String: Any]
        signFactors = sign?["confirmation"] as? [String]
        
        state <- map["state"]
    }
}
class PaymentsRevokeDetailContextByType: Context{
    
    var code: String!
    
    override func parametres() -> [String : Any]? {
        return ["docType": code ?? ""]
    }
    override func urlString() -> String {
        return baseURL + "/api/customer/documents/by-doctype?"
    }
}
