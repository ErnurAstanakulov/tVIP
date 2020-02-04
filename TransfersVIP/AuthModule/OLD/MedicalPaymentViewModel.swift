   //
//  MedicalPaymentViewModel.swift
//  DigitalBank
//
//  Created by Zhalgas Baibatyr on 22.05.2018.
//  Copyright © 2018 InFin-It Solutions. All rights reserved.
//

import RxSwift
  
class MedicalPaymentViewModel: ContributionViewModel {

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
    var autoFillByKnp: [TransferEmployee]?
    
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
            if let accountViews = sourceData?.accountViews, accountViews.count == 1 && initialDocument == nil, let firstAccount = accountViews.first {
                component(by: .accountNumber).setValue(newValue: firstAccount.number)
                component(by: .accountNumber).description = firstAccount.balance?.description
                component(by: .accountNumber).set(uiProperty: .isBlockedAccountFillTextColor(getAccountStatusColor(with: firstAccount.status?.statusCode, isCheckedValue: false)))
            }
            if let isUrgent = initialDocument?.priority {
                component(by: .valueDate).set(uiProperty: .isUserInteractionEnabled(!isUrgent))
            }
            if initialDocument?.number == nil {
                component(by: .documentNumber).setValue(newValue: sourceData?.documentNumber)
                component(by: .valueDate).setValue(newValue: sourceData?.payDays?.currentDate)
            }
            component(by: .director).setValue(newValue: sourceData?.directors.first?.fullName)
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
            employee.amount = worker.medical
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
        if let value = component(by: .period).value {
            // Backend doesn't consider the day value in date (the first three characters)
            domesticTransferToSend.employeeTransferPeriod = value
        }
        domesticTransferToSend.employeeTransferCategory = component(by: .medicalInsuranceCategory).value
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
            component(by: .period).setValue(newValue: initialDocument?.employeeTransferPeriod)
            component(by: .medicalInsuranceCategory).setValue(newValue: initialDocument?.employeeTransferCategory)
            component(by: .knpCode).setValue(newValue: initialDocument?.purposeCode)
            if let purposeCodeLabel = initialDocument?.purposeCodeLabel {
                component(by: .knpDescription).setValue(newValue: purposeCodeLabel)
                component(by: .knpDescription).isVisible = true
            }
            component(by: .knpDescription).setValue(newValue: initialDocument?.purposeCodeLabel)
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
                newEmployee.medical = employee.amount
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
    
    var documentType: String { return "MedicalContribution" }
    
    var requisitesName: String { return "MEDICAL_INSURANCE_COMPANY" }
    
    var medicalInsuranceCategoryName: String { return "MEDICAL_INSURANCE_CATEGORIES" }

    var employees: [Employee] = [] {
        didSet {
            component(by: .employees).setValue(newValue: employees.isEmpty ? nil : "Сотрудники выбраны")
            component(by: .employees).errorDescription = nil
            for employee in employees {
                employee._medical.subscribe(onNext: {[weak self, weak employee] (_) in
                    guard  let self = self, let employee = employee else { return }
                    let sum = self.calculateSumEmployees()
                    self.component(by: .amount).setValue(newValue: sum.splittedAmount)
                    employee.amount = Double(sum) ?? 0.0
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
        func str(_ component: MedicalPaymentComponent) -> String { return component.rawValue }
        let optionsPlaceholder = "Выберите из списка"
        let textFieldPlaceholder = "Введите данные"
        let constraints = AppState.sharedInstance.config?.documents?.domesticTransfer?.paymentOrder?.constraints
        
        components = [
            .init(
                type: .searchTextField,
                name: str(.template),
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
                type: .options,
                name: str(.accountNumber),
                title: "Счет списания",
                placeholder: optionsPlaceholder,
                constraints: constraints?.account
            ),
            .init(
                type: .searchTextField,
                name: str(.knpCode),
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
                title: "БИН/ИИН дочерной организации", isVisible: false
            ),
            .init(
                type: .label,
                name: str(.codeChildOrganization),
                title: "Код дочерной организации", isVisible: false
            ),
            .init(
                type: .label,
                name: str(.companyName),
                title: "Наименование получателя",
                constraints: constraints?.benefName
            ),
            .init(
                type: .label,
                name: str(.companyTaxCode),
                title: "БИН/ИИН получателя",
                constraints: constraints?.benefTaxCode
            ),
            .init(
                type: .label,
                name: str(.kbeCode),
                title: "КБЕ получателя",
                constraints: constraints?.benefResidencyCode
            ),
            .init(
                type: .label,
                name: str(.companyAccount),
                title: "Счет получателя",
                constraints: constraints?.benefAccount
            ),
            .init(
                type: .label,
                name: str(.companyBankCode),
                title: "БИК банка получателя",
                constraints: constraints?.benefBankCode
            ),
            .init(
                type: .label,
                name: str(.companyBankName),
                title: "Наименование банка получателя"
            ),
            .init(
                type: .switcher,
                name: str(.urgentPaymentIndicator),
                title: "Срочный платеж"
            ),
            .init(
                type: .options,
                name: str(.valueDate),
                title: "Дата валютирования",
                placeholder: optionsPlaceholder,
                constraints: constraints?.valueDate
            ),
            .init(
                type: .label,
                name: str(.amount),
                title: "Сумма",
                description: "Считается автоматически",
                constraints: constraints?.amount
            ),
            .init(
                type: .date,
                name: str(.period),
                title: "Период",
                placeholder: "Выберите дату",
                uiProperties: [.useMonthAndYearDateFormat(true)]
            ),
            .init(
                type: .options,
                name: str(.medicalInsuranceCategory),
                title: "Тип отчисления",
                placeholder: optionsPlaceholder
            ),
            .init(
                type: .label,
                name: str(.knpDescription),
                title: "Описание КНП",
                dependency: Dependency(
                    name: MedicalPaymentComponent.knpCode.rawValue,
                    condition: .visibility
                ),
                isVisible: false),
            .init(
                type: .searchTextField,
                name: str(.purpose),
                title: "Назначение платежа", placeholder: "Введите данные", constraints: constraints?.purpose
            ),
            .init(
                type: .textfield,
                name: str(.additionalInfo),
                title: "Дополнительная информация",
                placeholder: textFieldPlaceholder,
                constraints: constraints?.info
            ),
            .init(
                type: .label,
                name: str(.bankResponse),
                title: "Сообщение из банка", isVisible: false
            ),
            .init(
                type: .employees,
                name: str(.employees),
                title: "Сотрудники", placeholder: "Выберите сотрудников"
            ),
            .init(
                type: .options,
                name: str(.director),
                title: "Руководитель", placeholder: optionsPlaceholder, constraints: constraints?.director
            ),
            .init(
                type: .options,
                name: str(.accountant),
                title: "Гл. бухгалтер", placeholder: optionsPlaceholder
            )
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

extension MedicalPaymentViewModel: OperationViewModel {

    func setAutoFillComponentsByKnp(model: TransferEmployee?) {
        self.component(by: .companyName).setValue(newValue: model?.name)
        self.component(by: .companyTaxCode).setValue(newValue: model?.taxCode)
        self.component(by: .companyAccount).setValue(newValue: model?.account)
        self.component(by: .companyBankCode).setValue(newValue: model?.bankCode)
        self.component(by: .medicalInsuranceCategory).setValue(newValue: model?.pensionCnType?.code)
        self.component(by: .kbeCode).setValue(newValue: model?.residencyCode)
        self.component(by: .companyBankName).setValue(newValue: model?.bankName)
    }
    
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
            let autoFillModel = self.autoFillByKnp?.filter { $0.paymentPurposeCode?.code == value?.id }.first
            self.setAutoFillComponentsByKnp(model: autoFillModel)
            self.component(by: .knpDescription).setValue(newValue: value?.description)
            self.component(by: .purpose).setValue(newValue: value?.description)
        case self.component(by: .valueDate):
            if let isUrgentPayment: Bool = self.component(by: .urgentPaymentIndicator).getValue(), isUrgentPayment {
                return false
            }
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
    
    func textfieldValueChangedWithLoaded(_ value: String?, component: OperationComponent, completion: ((Bool, String?) -> Void)?) -> Bool {
        component.setValue(newValue: value)
        changeValueDependencies(component: component, to: value?.isEmpty == false)
        component.errorDescription = nil
        if self.component(by: .documentNumber) == component {
            if let value = value {
                let validateContext = ValidateDocumentNumberContext(number: value, documentType: Constants.DocumentType.domesticTransfer)
                validateContext.load(isSuccsess: { (response) in
                    if let number = response as? String, number != "ok" {
                        component.errorDescription = "Предлагаемый порядковый номер \(number)"
                        completion?(true, nil)
                    }
                })
            }
        }
        if self.component(by: .knpCode) == component {
            let knp = sourceData?.knp?.compactMap { OptionDataSource(id: $0.code, title: $0.code, description: $0.label) }.first(where: { $0.title == value })
            return optionSelectedWithLoaded(knp, component: component, completion: completion)
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
        guard let componentType = MedicalPaymentComponent(rawValue: component.name) else { return nil }
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
        case .medicalInsuranceCategory:
            guard let types = sourceData?.employeeTransferCategory else { return nil }
            return types.compactMap{ OptionDataSource(id: $0.code, title: $0.code, description: $0.label) }
        case .knpCode:
            return sourceData?.knp?.compactMap { OptionDataSource(id: $0.code, title: $0.code, description: $0.label) }
        case .purpose:
            return sourceData?.paymentPurposes?.compactMap { OptionDataSource(id: $0, title: $0) }
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

    func component(by medicalPaymentComponent: MedicalPaymentComponent) -> OperationComponent {
        return components.first(where: { $0.name == medicalPaymentComponent.rawValue })!
    }

}
