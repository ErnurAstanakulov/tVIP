//
//  SocialPaymentViewModel.swift
//  DigitalBank
//
//  Created by Алем Утемисов on 09.05.2018.
//  Copyright © 2018 iosDeveloper. All rights reserved.
//

import Foundation
import RxSwift

class SocialPaymentViewModel: OperationViewModel, ContributionViewModel {
    
    weak var viewController: OperationsTableViewControllerProtocol?
    var disposeBag = DisposeBag()
    var components: [OperationComponent] = []
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
    var keyPayDays:String { return "MAX_VALUE_DAYS_SOCIAL" }

    var sourceData: DomesticTransferSourсeData? {
        didSet {
            let accountantsCount = sourceData?.accountants.count ?? 0
            if accountantsCount <= 1 {
                component(by: .accountant).set(uiProperty: .isUserInteractionEnabled(false))
            }
            if initialDocument == nil {
                component(by: .director).setValue(newValue: sourceData?.directors.first?.fullName)
                component(by: .documentNumber).setValue(newValue: sourceData?.documentNumber)
                component(by: .accountant).setValue(newValue: accountantsCount == 0 ? "Не предусмотрен" : sourceData?.accountants.first?.fullName)
            } else if initialDocument?.accountant == nil && accountantsCount == 0 {
                component(by: .accountant).setValue(newValue: "Не предусмотрен")
            }
            
            guard !(initialDocument?.isTemplate == true) else { return }
            
            if initialDocument?.valueDate == nil {
                component(by: .valueDate).setValue(newValue: sourceData?.payDays?.currentDate)
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
    
    var autoFillByKnp: [TransferEmployee]?

    internal func setEmployees() {
        component(by: .employees).setValue(newValue: employees.isEmpty ? nil : "Сотрудники выбраны")
        component(by: .employees).errorDescription = nil
        for employee in employees {
            employee._social.subscribe(onNext: { [weak self, weak employee] (_) in
                guard  let self = self, let employee = employee else { return }
                let sum = self.calculateSumEmployees()
                self.component(by: .amount).setValue(newValue: sum.splittedAmount)
                employee.amount = Double(sum)
            }).disposed(by: disposeBag)
        }
    }
    
    var employees: [Employee] = [] {
        didSet {
            setEmployees()
        }
    }
    
    var initialDocument: DomesticTransfer? {
        didSet {
            component(by: .documentNumber).setValue(newValue: initialDocument?.number)
            component(by: .accountNumber).setValue(newValue: initialDocument?.account?.number)
            let amountFormatter = AmountFormatter()
            component(by: .accountNumber).description = amountFormatter.string(for: initialDocument?.account?.plannedBalance ?? "") ?? "0"
            component(by: .template).setValue(newValue: initialDocument?.templateName)
            component(by: .valueDate).setValue(newValue: initialDocument?.valueDate)
            component(by: .amount).setValue(newValue: String(format: "%2f", initialDocument?.amount ?? 0.00).splittedAmount)
            component(by: .urgentPayment).setValue(newValue: initialDocument?.priority)
            component(by: .paymentPurpose).setValue(newValue: initialDocument?.purpose)
            component(by: .knp).setValue(newValue: initialDocument?.purposeCode)
            component(by: .period).setValue(newValue: initialDocument?.employeeTransferPeriod)
            component(by: .accountant).setValue(newValue: initialDocument?.accountant?.fullName)
            component(by: .director).setValue(newValue: initialDocument?.director?.fullName)
            if let purposeLabel = initialDocument?.purposeCodeLabel {
                component(by: .descriptionKnp).setValue(newValue: purposeLabel)
                component(by: .descriptionKnp).isVisible = true
            }
            component(by: .additionalInfo).setValue(newValue: initialDocument?.info)
            if let bankResponse = initialDocument?.bankResponse {
                component(by: .bankResponse).setValue(newValue: bankResponse)
                component(by: .bankResponse).isVisible = true
            }
            employees.removeAll()
            initialDocument?.employees?.forEach { employee in
                let newEmployee = Employee()
                newEmployee.social = employee.amount
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
            component(by: .receiverName).setValue(newValue: initialDocument?.benefName)
            component(by: .iin).setValue(newValue: initialDocument?.benefTaxCode)
            component(by: .kbe).setValue(newValue: initialDocument?.benefResidencyCode)
            component(by: .receiverAccount).setValue(newValue: initialDocument?.benefAccount)
            component(by: .bankBik).setValue(newValue: initialDocument?.benefBankCode)
            component(by: .bankName).setValue(newValue: initialDocument?.bankName)
        }
    }
    
    var domesticTransferToSend: DomesticTransferToSend? {
        let domesticTransferToSend = DomesticTransferToSend()
        let accountNumber = component(by: .accountNumber).value
        let childOrganization = component(by: .childOrganizationName).value

        domesticTransferToSend.templateName = component(by: .template).value
        domesticTransferToSend.account = sourceData?.accountViews?.first(where: { $0.number == accountNumber })
        domesticTransferToSend.amount = component(by: .amount).value
        domesticTransferToSend.number = component(by: .documentNumber).value
        domesticTransferToSend.valueDate = component(by: .valueDate).value ?? ""
        domesticTransferToSend.domesticTransferType = documentType
        domesticTransferToSend.purpose = component(by: .paymentPurpose).value
        domesticTransferToSend.purposeText = component(by: .paymentPurpose).value
        domesticTransferToSend.priority = component(by: .urgentPayment).getValue() ?? domesticTransferToSend.priority
        domesticTransferToSend.info = component(by: .additionalInfo).value
        domesticTransferToSend.purposeCode = component(by: .knp).value
        domesticTransferToSend.isTemplate = initialDocument?.isTemplate
        domesticTransferToSend.benefName = component(by: .receiverName).value
        domesticTransferToSend.benefBankCode = component(by: .bankBik).value
        domesticTransferToSend.benefAccount = component(by: .receiverAccount).value
        domesticTransferToSend.benefResidencyCode = component(by: .kbe).value
        domesticTransferToSend.benefTaxCode = component(by: .iin).value
        if let value = component(by: .period).value {
            // Backend doesn't consider the day value in date (the first three characters)
            domesticTransferToSend.employeeTransferPeriod = value
        }
        var employeesToSend = [EmployeeSender]()
        for worker in employees {
            let employee = EmployeeSender(worker: worker)
            employee.amount = worker.amount
            if let items = employee.period?.components(separatedBy: "."), items.count == 2 {
                employee.period = items[0] + "." + items[1]
            }
            employeesToSend.append(employee)
        }
        domesticTransferToSend.employees = employeesToSend
        domesticTransferToSend.director = sourceData?.directors.first { $0.fullName == self.component(by: .director).value }
        domesticTransferToSend.accountant = sourceData?.accountants.first { $0.fullName == self.component(by: .accountant).value }
        domesticTransferToSend.isSubsidiaryOrganization = self.component(by: .childOrganization).getValue() ?? false
        domesticTransferToSend.subsidiaryOrganizationId = sourceData?.subsidiaryCustomers?.first(where: { $0.name == childOrganization })?.id
        return domesticTransferToSend
    }
    
    var documentType: String {
        return "SocialContribution"
    }
    
    var requisitesName: String {
        return "SOCIAL_COMPANY"
    }
    
    required init() {
        self.setupComponents()
        self.loadPayDays() { [weak self] (isSuccess, error) in
            if !isSuccess {
                self?.viewController?.presentErrorController(title: "Ошибка", message: contentErrorMessage)
                return
            }
        }
    }
    
    func dataSource(for component: OperationComponent) -> [OptionDataSource]? {
        guard let componenType = SocialPaymentComponent(rawValue: component.name) else { return nil }
        switch componenType {
        case .accountNumber:
            let amountFormatter = AmountFormatter()
            return sourceData?.accountViews?.compactMap {
                let balance = amountFormatter.string(for: $0.plannedBalance ?? 0.0) ?? "0.00"
                return OptionDataSource(
                    id: $0.number,
                    title: $0.number,
                    description: "\(balance) \($0.currency ?? "")",
                    color: getAccountStatusColor(with: $0.status?.statusCode,
                                                 isCheckedValue: false)
                )
            }
        case .template:
            return sourceData?.templates?.compactMap {
                OptionDataSource(
                    id: $0.id.description,
                    title: $0.templateName
                )
            }
        case .valueDate:
            if payDays != nil {
                return payDays!.map { OptionDataSource(id: $0, title: $0) }
            }
            return nil
        case .paymentPurpose:
            return sourceData?.paymentPurposes?.compactMap {
                OptionDataSource(
                    id: $0,
                    title: $0
                )
            }
        case .receiverName:
            return sourceData?.counterparties?.compactMap {
                OptionDataSource(
                    id: $0.counterparty?.name,
                    title: $0.counterparty?.name
                )
            }
        case .iin:
            return sourceData?.counterparties?.compactMap {
                OptionDataSource(
                    id: $0.counterparty?.bin,
                    title: $0.counterparty?.bin
                )
            }
        case .kbe:
            return sourceData?.KBE?.compactMap {
                OptionDataSource(
                    id: $0.code,
                    title: $0.code,
                    description: $0.label
                )
            }
        case .receiverAccount:
            guard let counterpartyName = self.component(by: .receiverName).value,
                let counterParty = sourceData?.counterparties?.first(where: { $0.counterparty?.name == counterpartyName }) else { return nil }
            return counterParty.accounts?.compactMap {
                OptionDataSource(
                    id: $0.iban,
                    title: $0.iban
                )
            }
        case .bankBik:
            return sourceData?.localBanks?.compactMap {
                OptionDataSource(
                    id: $0.nationalBankBik,
                    title: $0.nationalBankBik,
                    description: $0.bankName
                )
            }
        case .knp:
            return sourceData?.knp?.compactMap {
                OptionDataSource(
                    id: $0.code,
                    title: $0.code,
                    description: $0.label
                )
            }
        case .director:
            return sourceData?.directors.compactMap {
                OptionDataSource(
                    id: $0.fullName,
                    title: $0.fullName
                )
            }
        case .accountant:
            return sourceData?.accountants.compactMap {
                OptionDataSource(
                    id: $0.fullName,
                    title: $0.fullName
                )
            }
        case .childOrganizationName:
            return sourceData?.subsidiaryCustomers?.compactMap {
                OptionDataSource(
                    id: $0.name,
                    title: $0.name
                )
            }
        default:
            return nil
        }
    }
    
    func component(by socialPaymentComponent: SocialPaymentComponent) -> OperationComponent {
        return components.first(where: { $0.name == socialPaymentComponent.rawValue })!
    }
    
    func setAutoFillComponentsByKnp(model: TransferEmployee?) {
        self.component(by: .receiverName).setValue(newValue: model?.name ?? nil)
        self.component(by: .iin).setValue(newValue: model?.taxCode ?? nil)
        self.component(by: .receiverAccount).setValue(newValue: model?.account ?? nil)
        self.component(by: .bankBik).setValue(newValue: model?.bankCode ?? nil)
        self.component(by: .kbe).setValue(newValue: model?.residencyCode ?? nil)
        self.component(by: .bankName).setValue(newValue: model?.bankName ?? nil)
    }
    
    func optionSelectedWithLoaded(_ value: OptionDataSource?, component: OperationComponent, completion: ((Bool, String?) -> Void)?) -> Bool {
        switch component {
        case self.component(by: .accountNumber):
            component.description = value?.description
            guard let selectedAccount = sourceData?.accountViews?.first(where: { $0.number == value?.title }) else { return false }
            component.set(uiProperty: .isBlockedAccountFillTextColor(getAccountStatusColor(with: selectedAccount.status?.statusCode, isCheckedValue: true)))
        case self.component(by: .bankBik):
            self.component(by: .bankName).setValue(newValue: value?.description)
        case self.component(by: .knp):
            let autoFillModel = self.autoFillByKnp?.filter { $0.paymentPurposeCode?.code == value?.id }.first
            self.setAutoFillComponentsByKnp(model: autoFillModel)
            self.component(by: .descriptionKnp).setValue(newValue: value?.description)
            self.component(by: .paymentPurpose).setValue(newValue: value?.description)
        case self.component(by: .template):
            guard let valueId = value?.id, let id = Int(valueId) else { break }
            component.setValue(newValue: id)
            requestTemplate(withId: id, onCompletion: completion)
            return true
        case self.component(by: .childOrganizationName):
            let childOrganization = sourceData?.subsidiaryCustomers?.first { $0.name == value?.title }
            self.component(by: .binChildOrganization).setValue(newValue: childOrganization?.taxCode)
            self.component(by: .codeChildOrganization).setValue(newValue: childOrganization?.beneficiaryCode)
        case self.component(by: .amount):
            self.component(by: .amount).setValue(newValue: value?.description)
        default:
            break
        }
        component.setValue(newValue: value?.id)
        return false
    }
    
    func switchedWithLoaded(to: Bool, component: OperationComponent, completion: ((Bool, String?) -> Void)?) -> Bool {
        switch component {
        case self.component(by: .urgentPayment):
            let canEditValueDate = to
            self.component(by: .valueDate).setValue(newValue: payDays?.first)
            self.component(by: .valueDate).set(uiProperty: .isUserInteractionEnabled(!canEditValueDate))
        case self.component(by: .childOrganization):
            [self.component(by: .childOrganizationName),
             self.component(by: .binChildOrganization),
             self.component(by: .codeChildOrganization)].forEach { childElement in
                childElement.isVisible = to
                if !to { childElement.clearValue() }
            }
        default:
            break
        }
        component.setValue(newValue: to)
        changeValueDependencies(component: component, to: to)
        component.errorDescription = nil
        return false
    }
    
    func textfieldValueChangedWithLoaded(_ value: String?, component: OperationComponent, completion: ((Bool, String?) -> Void)?) -> Bool {
        component.setValue(newValue: value)
        changeValueDependencies(component: component, to: value?.isEmpty == false)
        component.errorDescription = nil
        
        switch component {
        case self.component(by: .documentNumber):
            guard let value = value else { break }
            let validateContext = ValidateDocumentNumberContext(number: value, documentType: Constants.DocumentType.domesticTransfer)
            validateContext.load(isSuccsess: { (response) in
                guard let number = response as? String, number != "ok" else { return }
                component.errorDescription = "Предлагаемый порядковый номер \(number)"
                completion?(true, nil)
            })
        case self.component(by: .knp):
            let knp = sourceData?.knp?.compactMap { OptionDataSource(id: $0.code, title: $0.code, description: $0.label) }.first(where: { $0.title == value })
            return optionSelectedWithLoaded(knp, component: component, completion: completion)
        default:
            break
        }
        return false
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

    func setupComponents() {
        func str(_ component: SocialPaymentComponent) -> String { return component.rawValue }
        let optionsPlaceholder = "Выберите из списка"
        let textFieldPlaceholder = "Введите данные"
        let constraints = AppState.sharedInstance.config?.documents?.domesticTransfer?.socialContribution?.constraints
        
        components = [
            .init(
                type: ComponentType.searchTextField,
                name: SocialPaymentComponent.template.rawValue,
                title: "Шаблоны",
                placeholder: optionsPlaceholder
            ),
            .init(
                type: .textfield,
                name: str(.documentNumber),
                title: "Номер документа",
                placeholder: textFieldPlaceholder
            ),
            .init(
                type: ComponentType.options,
                name: SocialPaymentComponent.accountNumber.rawValue,
                title: "Счет списания",
                placeholder: optionsPlaceholder,
                constraints: constraints?.account
            ),
            .init(
                type: ComponentType.searchTextField,
                name: SocialPaymentComponent.knp.rawValue,
                title: "КНП",
                placeholder: textFieldPlaceholder,
                constraints: constraints?.purposeCode
            ),
            .init(
                type: .switcher,
                name: str(.childOrganization),
                title: "За дочернюю организацию"
            ),
            .init(
                type: .searchTextField,
                name: str(.childOrganizationName),
                title: "Наименование дочерной организации",
                isVisible: false
            ),
            .init(
                type: .label,
                name: str(.binChildOrganization),
                title: "БИН/ИИН дочерной организации",
                isVisible: false
            ),
            .init(
                type: .label,
                name: str(.codeChildOrganization),
                title: "Код дочерной организации",
                isVisible: false
            ),
            .init(
                type: ComponentType.label,
                name: SocialPaymentComponent.receiverName.rawValue,
                title: "Наименование получателя",
                placeholder: textFieldPlaceholder,
                constraints: constraints?.benefName
            ),
            .init(
                type: ComponentType.label,
                name: SocialPaymentComponent.iin.rawValue,
                title: "БИН/ИИН получателя",
                placeholder: textFieldPlaceholder,
                constraints: constraints?.benefTaxCode
            ),
            .init(
                type: ComponentType.label,
                name: SocialPaymentComponent.kbe.rawValue,
                title: "КБЕ получателя",
                placeholder: textFieldPlaceholder,
                constraints: constraints?.benefResidencyCode
            ),
            .init(
                type: ComponentType.label,
                name: SocialPaymentComponent.receiverAccount.rawValue,
                title: "Счет получателя",
                placeholder: textFieldPlaceholder,
                constraints: constraints?.benefAccount
            ),
            .init(
                type: ComponentType.label,
                name: SocialPaymentComponent.bankBik.rawValue,
                title: "БИК банка",
                placeholder: textFieldPlaceholder,
                constraints: constraints?.benefBankCode
            ),
            .init(
                type: ComponentType.label,
                name: SocialPaymentComponent.bankName.rawValue,
                title: "Наименование банка",
                placeholder: textFieldPlaceholder
            ),
            .init(
                type: ComponentType.switcher,
                name: SocialPaymentComponent.urgentPayment.rawValue,
                title: "Срочный платеж"
            ),
            .init(
                type: ComponentType.searchTextField,
                name: SocialPaymentComponent.valueDate.rawValue,
                title: "Дата валютирования",
                placeholder: optionsPlaceholder,
                constraints: constraints?.valueDate
            ),
            .init(
                type: .date,
                name: str(.period),
                title: "Период",
                placeholder: "Выберите дату",
                uiProperties: [.useMonthAndYearDateFormat(true)]
            ),
            .init(
                type: ComponentType.label,
                name: SocialPaymentComponent.amount.rawValue,
                title: "Сумма списания",
                description: "Считается автоматически",
                constraints: constraints?.amount
            ),
            .init(
                type: ComponentType.label,
                name: SocialPaymentComponent.descriptionKnp.rawValue,
                title: "Описание КНП",
                dependency: Dependency(
                    name: SocialPaymentComponent.knp.rawValue,
                    condition: .visibility)
            ),
            .init(
                type: ComponentType.searchTextField,
                name: SocialPaymentComponent.paymentPurpose.rawValue,
                title: "Назначение платежа",
                placeholder: optionsPlaceholder,
                constraints: constraints?.purpose
            ),
            .init(
                type: ComponentType.textfield,
                name: SocialPaymentComponent.additionalInfo.rawValue,
                title: "Дополнительная информация",
                placeholder: textFieldPlaceholder,
                constraints: constraints?.info
            ),
            .init(
                type: .label,
                name: str(.bankResponse),
                title: "Сообщение из банка",
                isVisible: false
            ),
            .init(
                type: ComponentType.employees,
                name: SocialPaymentComponent.employees.rawValue,
                title: "Сотрудники",
                placeholder: "Выберите сотрудников"
            ),
            .init(
                type: .options,
                name: str(.director),
                title: "Руководитель",
                placeholder: optionsPlaceholder,
                constraints: constraints?.director
            ),
            .init(
                type: .options,
                name: str(.accountant),
                title: "Гл. бухгалтер",
                placeholder: optionsPlaceholder
            )
        ]
    }
    
    var initialDataUrl: String {
        return baseURL + "api/payment/domestic-transfer/source-field?fieldList=ACCOUNTS%2CCOMPANY_PERSONS%2CSUBSIDIARY_CUSTOMER%2CPAYMENT_DATES%2CKNP%2CPURPOSES%2CTEMPLATES%2CCONSTRAINTS%2CCUSTOMER%2CDOCUMENT_NUMBER%2CSOCIAL_COMPANY&domesticTransferType=SocialContribution"
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
    
    func isEmployeesValid() -> String? {
        guard !employees.isEmpty else {
            return "Список сотрудников не заполнен"
        }
        for employee in employees {
            if employee.social == 0.0 {
                return "Сумма для сотрудников не заполнена"
            }
        }
        return nil
    }
}

enum SocialPaymentComponent: String {
    case template
    case documentNumber
    case accountNumber
    case receiverName
    case iin
    case kbe
    case receiverAccount
    case bankBik
    case bankName
    case urgentPayment
    case paymentType
    case paymentTypeDescription
    case valueDate
    case amount
    case knp
    case descriptionKnp
    case paymentPurpose
    case additionalInfo
    case bankResponse
    case employees
    case period
    case accountant
    case director
    case childOrganization
    case childOrganizationName
    case binChildOrganization
    case codeChildOrganization
}

