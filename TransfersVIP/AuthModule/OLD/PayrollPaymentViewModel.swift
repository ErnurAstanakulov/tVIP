//
//  PayrollPaymentViewModel.swift
//  TransfersVIP
//
//  Created by psuser on 24/09/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation
import RxSwift

class PayrollPaymentViewModel: ContributionViewModel {
    
    weak var viewController: OperationsTableViewControllerProtocol?
    var disposeBag = DisposeBag()
    var components = [OperationComponent]()
    var documentId: Int?
    
    var isEditing: Bool = true {
        didSet {
            components.forEach {
                if $0.type != .employees || ($0.type == .employees && !canViewEmployees) {
                    $0.set(uiProperty: .isUserInteractionEnabled(isEditing))
                }
                if !isEditing {
                    $0.placeholder =  "Не заполнено"
                }
            }
        }
    }
    var canViewEmployees: Bool = false {
        didSet {
            if canViewEmployees {
                component(by: .employees).set(uiProperty: .isUserInteractionEnabled(canViewEmployees))
            }
        }
    }
    var payDays: [String]?
    
    var sourceData: DomesticTransferSourсeData? {
        didSet {
            let accountantsCount = sourceData?.accountants.count ?? 0
            if accountantsCount <= 1 {
                component(by: .accountant).set(uiProperty: .isUserInteractionEnabled(false))
            }
            if initialDocument == nil {
                component(by: .documentNumber).setValue(newValue: sourceData?.documentNumber)
                component(by: .accountant).setValue(newValue: accountantsCount == 0 ? "Не предусмотрен" : sourceData?.accountants.first?.fullName)
            } else if initialDocument?.accountant == nil && accountantsCount == 0 {
                component(by: .accountant).setValue(newValue: "Не предусмотрен")
            }
            
            guard !(initialDocument?.isTemplate == true) else { return }
            
            if initialDocument?.valueDate == nil {
                component(by: .valueDate).setValue(newValue: sourceData?.payDays?.currentDate)
            }
            component(by: .director).setValue(newValue: sourceData?.directors.first?.fullName)
            if let accountViews = sourceData?.accountViews, accountViews.count == 1 && initialDocument == nil, let firstAccount = accountViews.first  {
                component(by: .accountNumber).setValue(newValue: firstAccount.number)
                component(by: .accountNumber).set(uiProperty: .isBlockedAccountFillTextColor(getAccountStatusColor(with: firstAccount.status?.statusCode, isCheckedValue: false)))
            }
            if let isUrgent = initialDocument?.priority {
                component(by: .valueDate).set(uiProperty: .isUserInteractionEnabled(!isUrgent))
            }
            if initialDocument?.number == nil {
                component(by: .documentNumber).setValue(newValue: sourceData?.documentNumber)
                component(by: .valueDate).setValue(newValue: sourceData?.payDays?.currentDate)
            }
            if let payDays = sourceData?.payDays?.dates {
                if payDays.count == 0 {
                    component(by: .valueDate).set(uiProperty: .isUserInteractionEnabled(false))
                } else {
                    component(by: .valueDate).set(uiProperty: .isUserInteractionEnabled(true))
                }
            }
        }
    }
    
    var domesticTransferToSend: DomesticTransferToSend? {
        
        let accountNumber = component(by: .accountNumber).value
        let childOrganization = component(by: .childOrganizationName).value
        
        var employeesToSend = [EmployeeSender]()
        for worker in employees {
            let employee = EmployeeSender(worker: worker)
            employee.amount = worker.payroll
            if let items = employee.period?.components(separatedBy: "."), items.count == 2 {
                employee.period = items[0] + "." + items[1]
            }
            employeesToSend.append(employee)
        }
        
        let domesticTransferToSend = DomesticTransferToSend()
        domesticTransferToSend.number = component(by: .documentNumber).value
        domesticTransferToSend.domesticTransferType = documentType
        domesticTransferToSend.isTemplate = initialDocument?.isTemplate
        domesticTransferToSend.templateName = component(by: .template).value
        domesticTransferToSend.account = sourceData?.accountViews?.first(where: { $0.number == accountNumber })
        domesticTransferToSend.benefName = component(by: .companyName).value
        domesticTransferToSend.benefTaxCode = component(by: .companyTaxCode).value
        domesticTransferToSend.benefResidencyCode = component(by: .kbeCode).value
        domesticTransferToSend.benefAccount = component(by: .companyAccount).value
        domesticTransferToSend.benefBankCode = component(by: .companyBankCode).value
        domesticTransferToSend.priority = component(by: .urgentPaymentIndicator).getValue() ?? false
        domesticTransferToSend.valueDate = component(by: .valueDate).value
        domesticTransferToSend.amount = component(by: .amount).value
        domesticTransferToSend.purposeCode = component(by: .knpCode).value
        domesticTransferToSend.purpose = component(by: .purpose).value
        domesticTransferToSend.purposeText = component(by: .purpose).value
        domesticTransferToSend.info = component(by: .additionalInfo).value
        domesticTransferToSend.employees = employeesToSend
        domesticTransferToSend.director = sourceData?.directors.first { $0.fullName == self.component(by: .director).value }
        domesticTransferToSend.accountant = sourceData?.accountants.first { $0.fullName == self.component(by: .accountant).value }
        domesticTransferToSend.isSubsidiaryOrganization = self.component(by: .childOrganization).getValue() ?? false
        domesticTransferToSend.subsidiaryOrganizationId = sourceData?.subsidiaryCustomers?.first(where: { $0.name == childOrganization })?.id
        return domesticTransferToSend
    }
    
    var initialDocument: DomesticTransfer? {
        didSet {
            component(by: .template).setValue(newValue: initialDocument?.templateName)
            component(by: .documentNumber).setValue(newValue: initialDocument?.number)
            component(by: .accountNumber).setValue(newValue: initialDocument?.account?.number)
            
            let amountFormatter = AmountFormatter()
            component(by: .accountNumber).description = amountFormatter.string(for: initialDocument?.account?.plannedBalance ?? 0.0)
            component(by: .companyName).setValue(newValue: initialDocument?.benefName)
            component(by: .companyTaxCode).setValue(newValue: initialDocument?.benefTaxCode)
            component(by: .kbeCode).setValue(newValue: initialDocument?.benefResidencyCode)
            component(by: .companyAccount).setValue(newValue: initialDocument?.benefAccount)
            component(by: .companyBankCode).setValue(newValue: initialDocument?.benefBankCode)
            component(by: .companyBankName).setValue(newValue: initialDocument?.bankName)
            component(by: .urgentPaymentIndicator).setValue(newValue: initialDocument?.priority ?? false)
            component(by: .valueDate).setValue(newValue: initialDocument?.valueDate)
            component(by: .amount).setValue(newValue: String(format: "%2f", initialDocument?.amount ?? 0.00).splittedAmount)
            component(by: .knpCode).setValue(newValue: initialDocument?.purposeCode)
            if (initialDocument?.purposeCodeLabel) != nil {
                component(by: .knpDescription).setValue(newValue: initialDocument?.purposeCodeLabel)
                component(by: .knpDescription).isVisible = true
            }
            component(by: .purpose).setValue(newValue: initialDocument?.purpose)
            component(by: .additionalInfo).setValue(newValue: initialDocument?.info)
            if let bankResponse = initialDocument?.bankResponse {
                component(by: .bankResponse).setValue(newValue: bankResponse)
                component(by: .bankResponse).isVisible = true
            }
            component(by: .director).setValue(newValue: initialDocument?.director?.fullName)
            component(by: .accountant).setValue(newValue: initialDocument?.accountant?.fullName)
            employees.removeAll()
            initialDocument?.employees?.forEach { employee in
                let newEmployee = Employee()
                newEmployee.payroll = employee.amount
                newEmployee.fillFromEmployee(employee)
                employees.append(newEmployee)
            }
            component(by: .childOrganization).setValue(newValue: initialDocument?.isSubsidiaryOrganization ?? false)
            if let childOrganizationName = initialDocument?.subsidiaryCustomerShortData?.name {
                component(by: .childOrganizationName).setValue(newValue: childOrganizationName)
                component(by: .childOrganizationName).isVisible = true
            }
            if let taxCode = initialDocument?.subsidiaryCustomerShortData?.taxCode {
                component(by: .binChildOrganization).setValue(newValue: taxCode)
                component(by: .binChildOrganization).isVisible = true
            }
            if let codeChildOrganization = initialDocument?.subsidiaryCustomerShortData?.beneficiaryCode {
                component(by: .codeChildOrganization).setValue(newValue: codeChildOrganization)
                component(by: .codeChildOrganization).isVisible = true
            }
        }
    }
    
    var documentType: String { return "Payroll" }
    
    var requisitesName: String { return "MEDICAL_INSURANCE_COMPANY" }
    
    var employees: [Employee] = [] {
        didSet {
            component(by: .employees).setValue(newValue: employees.isEmpty ? nil : "Сотрудники выбраны")
            component(by: .employees).errorDescription = nil
            employees.forEach {
                $0._payroll.subscribe(onNext: {[weak self] (_) in
                    let sum = self?.calculateSumEmployees()
                    self?.component(by: .amount).setValue(newValue: sum?.splittedAmount)
                }).disposed(by: disposeBag)
            }
        }
    }
    
    required init() {
        setupComponents()
        self.loadPayDays() { [weak self] (isSuccess, error) in
            if !isSuccess {
                self?.viewController?.presentErrorController(title: "Ошибка", message: contentErrorMessage)
                return
            }
        }
    }
    
    func setupComponents() {
        
        // Local function
        func str(_ component: PayrollPaymentComponent) -> String { return component.rawValue }
        
        let optionsPlaceholder = "Выберите из списка"
        let textFieldPlaceholder = "Введите данные"
        let constraints = AppState.sharedInstance.config?.documents?.domesticTransfer?.paymentOrder?.constraints
        
        components = [
            .init(type: .searchTextField, name: str(.template),                  title: "Шаблоны", placeholder: optionsPlaceholder),
            .init(type: .textfield, name: str(.documentNumber),         title: "Номер документа", placeholder: textFieldPlaceholder),
            .init(type: .options, name: str(.accountNumber),              title: "Счет списания", placeholder: optionsPlaceholder, constraints: constraints?.account),
            .init(type: .switcher, name: str(.childOrganization),                title: "За дочернюю организацию"),
            .init(type: .searchTextField, name: str(.childOrganizationName),                title: "Наименование дочерной организации", isVisible: false),
            .init(type: .label, name: str(.binChildOrganization), title: "БИН/ИИН дочерной организации", isVisible: false),
            .init(type: .label, name: str(.codeChildOrganization), title: "Код дочерной организации", isVisible: false),
            .init(type: .searchTextField, name: str(.companyName),                title: "Наименование получателя", placeholder: textFieldPlaceholder, constraints: constraints?.benefName),
            .init(type: .searchTextField, name: str(.companyTaxCode),              title: "БИН/ИИН получателя", placeholder: textFieldPlaceholder, constraints: constraints?.benefTaxCode),
            .init(type: .searchTextField, name: str(.kbeCode),                      title: "КБЕ получателя", placeholder: textFieldPlaceholder, constraints: constraints?.benefResidencyCode),
            .init(type: .searchTextField, name: str(.companyAccount),             title: "Счет получателя", placeholder: textFieldPlaceholder, constraints: constraints?.benefAccount, uiProperties: [.autocapitalizationType(.allCharacters)]),
            .init(type: .searchTextField, name: str(.companyBankCode),              title: "БИК банка получателя", placeholder: textFieldPlaceholder, constraints: constraints?.benefBankCode),
            .init(type: .label, name: str(.companyBankName),              title: "Наименование банка получателя"),
            .init(type: .switcher, name: str(.urgentPaymentIndicator),  title: "Срочный платеж"),
            .init(type: .options, name: str(.valueDate),                 title: "Дата валютирования", placeholder: optionsPlaceholder, constraints: constraints?.valueDate),
            .init(type: .label, name: str(.amount),                     title: "Сумма", description: "Считается автоматически", constraints: constraints?.amount),
            .init(type: .searchTextField, name: str(.knpCode),             title: "КНП", placeholder: textFieldPlaceholder, constraints: constraints?.purposeCode),
            .init(type: .label, name: str(.knpDescription),              title: "Описание КНП", dependency: Dependency(name: PayrollPaymentComponent.knpCode.rawValue, condition: .visibility), isVisible: false),
            .init(type: .searchTextField, name: str(.purpose),             title: "Назначение платежа", placeholder: "Введите данные", constraints: constraints?.purpose),
            .init(type: .textfield, name: str(.additionalInfo),         title: "Дополнительная информация", placeholder: textFieldPlaceholder, constraints: constraints?.info),
            .init(type: .label, name: str(.bankResponse),                title: "Сообщение из банка", isVisible: false),
            .init(type: .employees, name: str(.employees),                 title: "Сотрудники", placeholder: "Выберите сотрудников"),
            .init(type: .options, name: str(.director), title: "Руководитель", placeholder: optionsPlaceholder, constraints: constraints?.director),
            .init(type: .options, name: str(.accountant), title: "Гл. бухгалтер", placeholder: optionsPlaceholder)
        ]
    }
    
    var documentActionDataArray: [DocumentActionData]? = nil
    
    var jsonParameters: [String: Any] {
        if let json = domesticTransferToSend?.toJSON() {
            return json
        }
        
        return [:]
    }
    
    var componentsAreValid: Bool {
        return isValid(components: components)
    }
    
    func isValid(components: [OperationComponent]) -> Bool {
        var result: Bool = true
        if let error = isEmployeesValid() {
            component(by: .employees).errorDescription = error
            result = false
        }
        for component in components {
            guard let constraints = component.constraints else { continue }
            if let error = Validator.validatingError(text: component.value, constraint: constraints) {
                component.errorDescription = error
                result = false
            }
        }
        return result
    }
}

extension PayrollPaymentViewModel: OperationViewModel {
    func optionSelectedWithLoaded(_ value: OptionDataSource?, component: OperationComponent, completion: ((Bool, String?) -> Void)?) -> Bool {
        switch component {
        case self.component(by: .accountNumber):
            component.description = value?.description
            guard let selectedAccount = sourceData?.accountViews?.first(where: { $0.number == value?.title }) else { return false }
            component.set(uiProperty: .isBlockedAccountFillTextColor(getAccountStatusColor(with: selectedAccount.status?.statusCode, isCheckedValue: true)))
        case self.component(by: .template):
            if let valueId = value?.id, let id = Int(valueId) {
                component.setValue(newValue: id)
                requestTemplate(withId: id, onCompletion: completion)
                return true
            }
        case self.component(by: .knpCode):
            self.component(by: .knpDescription).setValue(newValue: value?.description)
            self.component(by: .purpose).setValue(newValue: value?.description)
        case self.component(by: .valueDate):
            if let isUrgentPayment: Bool = self.component(by: .urgentPaymentIndicator).getValue(), isUrgentPayment {
                return false
            }
        case self.component(by: .companyName):
            let company = sourceData?.counterparties?.first { $0.counterparty?.bin == value?.description }
            self.component(by: .companyTaxCode).setValue(newValue: value?.description)
            self.onChange(company: company)
        case self.component(by: .companyTaxCode):
            let company = sourceData?.counterparties?.first { $0.counterparty?.bin == value?.id }
            self.component(by: .companyName).setValue(newValue: value?.description)
            self.onChange(company: company)
        case self.component(by: .companyAccount):
            if let accountNumber = value?.id {
                let localBank = getLocalBankFrom(accountNumber: accountNumber)
                self.component(by: .companyBankCode).setValue(newValue: localBank?.bankBik)
                self.component(by: .companyBankName).setValue(newValue: localBank?.bankName)
            }
        case self.component(by: .companyBankCode):
            self.component(by: .companyBankName).setValue(newValue: value?.description)
        case self.component(by: .childOrganizationName):
            let childOrganization = sourceData?.subsidiaryCustomers?.first { $0.name == value?.title }
            self.component(by: .binChildOrganization).setValue(newValue: childOrganization?.taxCode)
            self.component(by: .codeChildOrganization).setValue(newValue: childOrganization?.beneficiaryCode)
        default:
            break
        }
        
        component.setValue(newValue: value?.id)
        changeValueDependencies(component: component, to: value?.id.isEmpty == false)
        component.errorDescription = nil
        
        return false
    }
    
    private func onChange(company: CounterpartyList?) {
        self.component(by: .kbeCode).setValue(newValue: company?.counterparty?.beneficiaryCode)
        self.component(by: .companyAccount).setValue(newValue: company?.accounts?.first?.iban)
        self.component(by: .companyBankCode).setValue(newValue: company?.accounts?.first?.bankCode)
        self.component(by: .companyBankName).setValue(newValue: company?.accounts?.first?.bankName)
    }
    
    func textfieldValueChangedWithLoaded(_ value: String?, component: OperationComponent, completion: ((Bool, String?) -> Void)?) -> Bool {
        component.setValue(newValue: value)
        changeValueDependencies(component: component, to: value?.isEmpty == false)
        component.errorDescription = nil
        
        switch component {
        case self.component(by: .companyAccount):
            if let value = value {
                let localBank = getLocalBankFrom(accountNumber: value)
                self.component(by: .companyBankCode).setValue(newValue: localBank?.bankBik)
                self.component(by: .companyBankName).setValue(newValue: localBank?.bankName)
            }
        case self.component(by: .companyBankCode):
            component.setValue(newValue: value?.uppercased())
            let bankName = sourceData?.localBanks?.first(where: { $0.bankBik == value?.uppercased() })?.bankName
            self.component(by: .companyBankName).setValue(newValue: bankName)
        case self.component(by: .documentNumber):
            guard let value = value else { break }
            let validateContext = ValidateDocumentNumberContext(
                number: value,
                documentType: Constants.DocumentType.domesticTransfer
            )
            validateContext.load(isSuccsess: { (response) in
                if let number = response as? String, number != "ok" {
                    component.errorDescription = "Предлагаемый порядковый номер \(number)"
                    completion?(true, nil)
                }
            })
        case self.component(by: .knpCode):
            let knp = sourceData?.knp?.compactMap { OptionDataSource(id: $0.code, title: $0.code, description: $0.label) }.first(where: { $0.title == value })
            return optionSelectedWithLoaded(knp, component: component, completion: completion)
        case self.component(by: .companyName):
            let company = sourceData?.counterparties?.first { $0.counterparty?.bin == value }
            self.component(by: .companyTaxCode).setValue(newValue: company?.counterparty?.bin)
            self.onChange(company: company)
        case self.component(by: .companyTaxCode):
            let company = sourceData?.counterparties?.first { $0.counterparty?.bin == value }
            self.component(by: .companyName).setValue(newValue: company?.counterparty?.name)
            self.onChange(company: company)
        default:
            break
        }
        return false
    }
    
    func switchedWithLoaded(to: Bool, component: OperationComponent, completion: ((Bool, String?) -> Void)?) -> Bool {
        
        if self.component(by: .urgentPaymentIndicator) == component {
            let canEditValueDate = to
            self.component(by: .valueDate).setValue(newValue: payDays?.first)
            self.component(by: .valueDate).set(uiProperty: .isUserInteractionEnabled(!canEditValueDate))
        }
        
        if self.component(by: .childOrganization) == component {
            [self.component(by: .childOrganizationName),
             self.component(by: .binChildOrganization),
             self.component(by: .codeChildOrganization)].forEach { childElement in
                childElement.isVisible = to
                if !to { childElement.clearValue() }
            }
        }
        
        component.setValue(newValue: to)
        changeValueDependencies(component: component, to: to)
        component.errorDescription = nil
        return false
    }
    
    func dataSource(for component: OperationComponent) -> [OptionDataSource]? {
        guard let componentType = PayrollPaymentComponent(rawValue: component.name) else { return nil }
        switch componentType {
        case .template:
            return sourceData?.templates?.compactMap { OptionDataSource(id: $0.id.description, title: $0.templateName) }
        case .accountNumber:
            let amountFormatter = AmountFormatter()
            return sourceData?.accountViews?.compactMap {
                let balance = amountFormatter.string(for: $0.plannedBalance ?? 0.0) ?? "0.00"
                return OptionDataSource(id: $0.number, title: $0.number, description: "\(balance) \($0.currency ?? "")", color: getAccountStatusColor(with: $0.status?.statusCode, isCheckedValue: false))
            }
        case .valueDate:
            if payDays != nil {
                return payDays!.map { OptionDataSource(id: $0, title: $0) }
            }
            return nil
        case .knpCode:
            return sourceData?.knp?.compactMap { OptionDataSource(id: $0.code, title: $0.code, description: $0.label) }
        case .purpose:
            return sourceData?.paymentPurposes?.compactMap { OptionDataSource(id: $0, title: $0) }
        case .companyBankCode:
            return sourceData?.localBanks?.compactMap { OptionDataSource.init(id: $0.nationalBankBik, title: $0.nationalBankBik, description: $0.bankName) }
        case .companyName:
            return sourceData?.counterparties?.compactMap { OptionDataSource.init(id: $0.counterparty?.name, title: $0.counterparty?.name, description: $0.counterparty?.bin) }
        case .companyTaxCode:
            return sourceData?.counterparties?.compactMap { OptionDataSource.init(id: $0.counterparty?.bin, title: $0.counterparty?.bin, description: $0.counterparty?.name) }
        case .kbeCode:
            return sourceData?.KBE?.compactMap { OptionDataSource(id: $0.code, title: $0.code, description: $0.label) }
        case .companyAccount:
            return sourceData?.counterparties?.first { $0.counterparty?.bin == self.component(by: .companyTaxCode).value }?.accounts?.compactMap { OptionDataSource(id: $0.iban, title: $0.iban) }
        case .director:
            return sourceData?.directors.compactMap { OptionDataSource(id: $0.fullName, title: $0.fullName) }
        case .accountant:
            return sourceData?.accountants.compactMap { OptionDataSource(id: $0.fullName, title: $0.fullName) }
        case .childOrganizationName:
            return sourceData?.subsidiaryCustomers?.compactMap { OptionDataSource(id: $0.name, title: $0.name) }
        default:
            return nil
        }
    }
    
    func component(by payrollPaymentComponent: PayrollPaymentComponent) -> OperationComponent {
        return components.first(where: { $0.name == payrollPaymentComponent.rawValue })!
    }
    
}

enum PayrollPaymentComponent: String {
    case template
    case documentNumber
    case accountNumber
    
    // ChildOrganization
    case childOrganization
    case childOrganizationName
    case binChildOrganization
    case codeChildOrganization
    
    // Receiver
    case companyName
    case companyTaxCode
    case companyAccount
    case kbeCode
    case companyBankCode
    case companyBankName
    
    // Payment details
    case urgentPaymentIndicator
    case valueDate
    case amount
    case knpCode
    case knpDescription
    case purpose
    case additionalInfo
    case bankResponse
    
    case employees
    case director
    case accountant
}
//
//  PayrollPaymentViewModel+Extension.swift
//  DigitalBank
//
//  Created by Алем Утемисов on 05.06.2018.
//  Copyright © 2018 iosDeveloper. All rights reserved.
//

import Foundation

extension PayrollPaymentViewModel: OperationViewModelDataLoadable {
    var initialDataUrl: String {
        let fieldList = ["ACCOUNTS", "COUNTERPARTIES", "KBE", "LOCAL_BANKS", "COMPANY_PERSONS", "CONSTRAINTS", "CUSTOMER", "DOCUMENT_NUMBER", "KNP", "PAYMENT_DATES", "PURPOSES", "TEMPLATES", "SUBSIDIARY_CUSTOMER"]
        let url = baseURL + "api/payment/domestic-transfer/source-field?" +
            "domesticTransferType=" + documentType + "&" +
            "fieldList=" + fieldList.joined(separator: "%2C")
        return url
    }
    
    public func loadInitialData(onCompletion perform: @escaping (_ success: Bool, _ errorDescription: String?) -> Void) {
        sessionManager.request(initialDataUrl, method: .get).responseJSON {[weak self] (serverResponse) in
            log(serverResponse: serverResponse)
            
            guard let dictionary = serverResponse.result.value as? [String: Any],
                serverResponse.result.isSuccess && serverResponse.error == nil else {
                    perform(false, serverResponse.getServerError()?.messageForShow() ?? serverResponse.error?.localizedDescription)
                    return
            }
            self?.sourceData = DomesticTransferSourсeData(JSON: dictionary)
            perform(true, nil)
        }
    }
    
    func requestTemplate(withId id: Int, onCompletion perform: ((_ success: Bool, _ errorDescription: String?) -> Void)?) {
        let context = LoadDomesticTransferContext()
        context.ID = id.description
        context.execute(isSuccsess: { [weak self] (response) in
            guard let json = response as? [String: Any] else { perform?(false, nil); return }
            self?.initialDocument = DomesticTransfer(JSON: json)
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
        guard let document = domesticTransferToSend else { return }
        document.isTemplate = isTemplate
        let save = SaveDomesticTransferContext()
        save.finalDocument = document
        save.documentID = initialDocument?.id
        if isTemplate && initialDocument?.id != nil {
            save.reSaveTemplate = true
        }
        
        save.execute(isSuccsess: {(response) in
            perform(true, nil)
        }) { (error) in
            if let serverError = error as? ContextError {
                perform(false, serverError.errorDescription)
            } else {
                perform(false, error?.localizedDescription)
            }
        }
    }
    
    func requestDocumentNumber(onCompletion perform: @escaping (_ success: Bool, _ errorDescription: String?) -> Void) {
        let url = "\(baseURL)api/customer/documents/generate-number"
        sessionManager.request(url, method: .get).validate().responseString { [weak self] response in
            log(serverResponse: response)
            guard let documentNumber = response.result.value else { perform(false, response.error?.localizedDescription); return }
            self?.component(by: .documentNumber).setValue(newValue: documentNumber)
            perform(true, nil)
        }
    }
    
    func loadPayDays(onCompletion perform: @escaping (_ success: Bool, _ errorDescription: String?) -> Void) {
        let url = baseURL + "api/documents/mobile/paydays?benefBankCode=&paymentType=MAX_VALUE_DAYS_PAYROLL"
        sessionManager.request(url, method: .get).validate().responseJSON { [unowned self] response in
            log(serverResponse: response)
            if response.result.isSuccess && response.error == nil {
                guard let json = response.result.value as? [String: Any] else {
                    perform(false, "there is an error with json file")
                    return
                }
                guard let days = json["payDays"]  as? [String] else {
                    perform(false, "there is an error with json file")
                    return
                }
                self.payDays = days.map { fromServerDate($0) ?? $0 }
                perform(true, nil)
                return
            } else {
                perform(false, response.error?.localizedDescription ?? contentErrorMessage)
                return
            }
        }
    }
    
    func isEmployeesValid() -> String? {
        guard !employees.isEmpty else {
            return "Список сотрудников не заполнен"
        }
        for employee in employees {
            if employee.payroll == 0.0 {
                return "Сумма для сотрудников не заполнена"
            }
        }
        return nil
    }
    
    func set(accountNumber: String?, balance: String?) {
        component(by: .accountNumber).setValue(newValue: accountNumber)
        component(by: .accountNumber).description = balance
    }
    
    func getLocalBankFrom(accountNumber: String) -> LocalBank? {
        guard accountNumber.count > 6 else {
            return nil
        }
        
        let startIndex = accountNumber.index(accountNumber.startIndex, offsetBy: 4)
        let endIndex = accountNumber.index(accountNumber.startIndex, offsetBy: 7)
        let last3Characters = String(accountNumber[startIndex..<endIndex])
        return sourceData?.localBanks?.first { $0.bankCode == last3Characters }
    }
}
