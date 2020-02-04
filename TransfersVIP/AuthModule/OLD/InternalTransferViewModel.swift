//
//  InternalTransferViewModel.swift
//  DigitalBank
//
//  Created by Алем Утемисов on 09.05.2018.
//  Copyright © 2018 iosDeveloper. All rights reserved.
//

import Foundation

class InternalTransferViewModel {
    
    weak var viewController: OperationsTableViewControllerProtocol?
    var components: [OperationComponent] = []
    var isEditing: Bool = true {
        didSet {
            components.forEach {
                $0.set(uiProperty: .isUserInteractionEnabled(isEditing))
                if !isEditing {
                    $0.placeholder =  "Не заполнено"
                }
            }
        }
    }
    
    var initialDocument: DomesticTransfer? {
        didSet {
            component(by: .accountCurrency).setValue(newValue: initialDocument?.account?.currency)
            component(by: .template).setValue(newValue: initialDocument?.templateName)
            component(by: .documentNumber).setValue(newValue: initialDocument?.number)
            component(by: .accountNumber).setValue(newValue: initialDocument?.account?.number)
            let amountFormatter = AmountFormatter()
            component(by: .accountNumber).description = amountFormatter.string(for: initialDocument?.account?.plannedBalance ?? 0.0)
            component(by: .enrollAccountNumber).setValue(newValue: initialDocument?.benefAccount)
            component(by: .urgentPaymentIndicator).setValue(newValue: initialDocument?.priority ?? false)
            component(by: .valueDate).setValue(newValue: initialDocument?.valueDate)
            component(by: .amount).setValue(newValue: initialDocument?.amount)
            component(by: .knp).setValue(newValue: initialDocument?.purposeCode)
            component(by: .descriptionKnp).setValue(newValue: initialDocument?.purposeCodeLabel)
            component(by: .paymentPurpose).setValue(newValue: initialDocument?.purpose)
            component(by: .paymentPurposeInfo).setValue(newValue: initialDocument?.purpose)
            component(by: .additionalInfo).setValue(newValue: initialDocument?.info)
            if let bankResponse = initialDocument?.bankResponse {
                component(by: .bankResponse).setValue(newValue: bankResponse)
                component(by: .bankResponse).isVisible = true
            }
            component(by: .descriptionKnp).isVisible = true
            component(by: .accountant).setValue(newValue: initialDocument?.accountant?.fullName)
            component(by: .director).setValue(newValue: initialDocument?.director?.fullName)
        }
    }
    
    var sourceData: DomesticTransferSourсeData? {
        didSet {
            let accountantsCount = sourceData?.accountants.count ?? 0
            if accountantsCount <= 1 {
                component(by: .accountant).set(uiProperty: .isUserInteractionEnabled(false))
            }
            
            if initialDocument == nil {
                component(by: .documentNumber).setValue(newValue: sourceData?.documentNumber)
                component(by: .director).setValue(newValue: sourceData?.directors.first?.fullName)
                component(by: .accountant).setValue(newValue: accountantsCount == 0 ? "Не предусмотрен" : sourceData?.accountants.first?.fullName)
                
                if initialDocument?.valueDate == nil {
                    component(by: .valueDate).setValue(newValue: sourceData?.payDays?.currentDate)
                }
                if let isUrgent = initialDocument?.priority {
                    component(by: .valueDate).set(uiProperty: .isUserInteractionEnabled(!isUrgent))
                }
            } else if initialDocument?.number == nil {
                component(by: .documentNumber).setValue(newValue: sourceData?.documentNumber)
                component(by: .valueDate).setValue(newValue: sourceData?.payDays?.currentDate)
            } else {
                let accountView = sourceData?.accountViews?.first { $0.number == initialDocument?.benefAccount }
                component(by: .enrollAccountNumber).description = String(accountView?.plannedBalance ?? 0.0)
            }
            
            if initialDocument?.accountant == nil && accountantsCount == 0 {
                component(by: .accountant).setValue(newValue: "Не предусмотрен")
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
    
    var templateList: [DomesticTransferTemplateDescription]?
    var payDays: [String]?
    
    var domesticTransferToSend: DomesticTransferToSend? {
        let domesticTransferToSend = DomesticTransferToSend()
        let accountNumber = component(by: .accountNumber).value
        domesticTransferToSend.templateName = component(by: .template).value
        domesticTransferToSend.account = sourceData?.accountViews?.first(where: { $0.number == accountNumber })
        domesticTransferToSend.amount = component(by: .amount).value
        domesticTransferToSend.number = component(by: .documentNumber).value
        domesticTransferToSend.valueDate = component(by: .valueDate).value
        domesticTransferToSend.domesticTransferType = "OwnAccountTransfer"
        domesticTransferToSend.purpose = component(by: .paymentPurpose).value
        domesticTransferToSend.purposeText = component(by: .paymentPurposeInfo).value
        domesticTransferToSend.priority = component(by: .urgentPaymentIndicator).getValue() ?? domesticTransferToSend.priority
        domesticTransferToSend.info = component(by: .additionalInfo).value
        domesticTransferToSend.purposeCode = component(by: .knp).value
        domesticTransferToSend.isTemplate = initialDocument?.isTemplate
        domesticTransferToSend.benefName = getCurrentOrganizationName()
        domesticTransferToSend.benefAccount = component(by: .enrollAccountNumber).value
        domesticTransferToSend.benefBankCode = "SABRKZKA"
        let residencyCode = initialDocument?.custResidencyCode ?? sourceData?.customerView?.residencyCode
        domesticTransferToSend.benefResidencyCode = residencyCode
        domesticTransferToSend.creditAccount = sourceData?.accountViews?.first { $0.number == domesticTransferToSend.benefAccount }
        domesticTransferToSend.creditSum = domesticTransferToSend.amount
        let taxCode = initialDocument?.custTaxCode ?? sourceData?.customerView?.taxCode
        domesticTransferToSend.benefTaxCode = taxCode
        domesticTransferToSend.director = sourceData?.directors.first { $0.fullName == self.component(by: .director).value }
        domesticTransferToSend.accountant = sourceData?.accountants.first { $0.fullName == self.component(by: .accountant).value }
        return domesticTransferToSend
    }
    
    private func getCurrentOrganizationName() -> String? {
        return "currentOrganization?.name"
    }
    
    private var paymentPurposeText = ""
    private var knpDescriptionText = ""
    
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
        func str(_ component: InternalTransferComponent) -> String { return component.rawValue }
        let optionsPlaceholder = "Выберите из списка"
        let textFieldPlaceholder = "Введите данные"
        let constraints = AppState.sharedInstance.config?.documents?.internatTransfer?.constraints
        components = [
            .init(
                type: ComponentType.searchTextField,
                name: InternalTransferComponent.template.rawValue, title: "Шаблоны", placeholder: optionsPlaceholder),
            .init(type: .textfield, name: str(.documentNumber), title: "Номер документа", placeholder: textFieldPlaceholder, constraints: constraints?.number),
            .init(type: .options, name: str(.accountCurrency), title: "Валюта", placeholder: optionsPlaceholder, constraints: nil),
            .init(type: .options, name: str(.accountNumber), title: "Счет списания", placeholder: optionsPlaceholder, constraints: constraints?.account),
            .init(type: .amount, name: str(.amount), title: "Сумма", placeholder: textFieldPlaceholder, constraints: constraints?.amount),
            .init(type: .options, name: str(.enrollAccountNumber), title: "Счет зачисления", placeholder: optionsPlaceholder, constraints: constraints?.account),
            .init(type: .switcher, name: str(.urgentPaymentIndicator),  title: "Срочный платеж"),
            .init(type: ComponentType.options, name: str(.valueDate), title: "Дата валютирования", placeholder: optionsPlaceholder, constraints: constraints?.valueDate),
            .init(type: ComponentType.searchTextField, name: str(.knp), title: "КНП", placeholder: textFieldPlaceholder, constraints: constraints?.purposeCode),
            .init(type: ComponentType.label, name: str(.descriptionKnp), title: "Описание КНП", dependency: Dependency(name: str(.knp), condition: .visibility), constraints: nil, isVisible: false),
            .init(type: ComponentType.searchTextField, name: str(.paymentPurpose), title: "Назначение платежа", placeholder: textFieldPlaceholder, constraints: constraints?.purpose),
            .init(type: ComponentType.label, name: DomesticTransferComponent.paymentPurposeInfo.rawValue, title: "Назначение платежа", placeholder: "", constraints: constraints?.purpose, uiProperties: [.isUserInteractionEnabled(false)]),
            .init(type: ComponentType.textfield, name: str(.additionalInfo), title: "Дополнительная информация", placeholder: textFieldPlaceholder, constraints: constraints?.info),
            .init(type: .label, name: str(.bankResponse), title: "Сообщение из банка", isVisible: false),
            .init(type: .options, name: str(.director), title: "Руководитель", placeholder: optionsPlaceholder),
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
    
    func setPaymentPurposeInfoText() -> String {
        var text = ""
        if paymentPurposeText != "" {
            text += paymentPurposeText + " "
        }
        if knpDescriptionText != "" {
            text += knpDescriptionText + " "
        }
        return text
    }
}

extension InternalTransferViewModel: OperationViewModel {
    
    func dataSource(for component: OperationComponent) -> [OptionDataSource]? {
        guard let componenType = InternalTransferComponent(rawValue: component.name) else { return nil }
        switch componenType {
        case .template:
            return sourceData?.templates?.compactMap { OptionDataSource(id: $0.id.description, title: $0.templateName) }
        case .accountCurrency:
            guard let accounts = sourceData?.accountViews else { return nil }
            let currencies = accounts.compactMap { $0.currency }
            /// Display only currencies with two or more accounts of same currency (paired accounts)
            let repeatedCurrencies = Array(Set(currencies.filter({ (i: String) in currencies.filter({ $0 == i }).count > 1})))
            return repeatedCurrencies.compactMap { OptionDataSource(id: $0, title: $0) }
        case .accountNumber:
            let components = self.visibleComponents.filter { $0.name == "accountCurrency" }
            guard let currencyComponent = components.first else { return nil }
            let currencies = dataSource(for: currencyComponent)
            var accounts = sourceData?.accountViews?.filter { (details) in
                currencies?.contains(where: { value in value.title == details.currency }) == true
            }
            guard let selectedCurrency = self.component(by: .accountCurrency).value else {
                let amountFormatter = AmountFormatter()
                return accounts?.compactMap { account in
                    if let balance = account.plannedBalance, let currency = account.currency {
                        return OptionDataSource(id: account.number, title: account.number, description: "\(amountFormatter.string(for: balance) ?? "0.00") \(currency)", color: getAccountStatusColor(with: account.status?.statusCode, isCheckedValue: false))
                    } else {
                        return OptionDataSource(id: account.number, title: account.number, color: getAccountStatusColor(with: account.status?.statusCode, isCheckedValue: false))
                    }
                }
            }
            accounts = accounts?.filter { $0.currency == selectedCurrency }
            return accounts?.compactMap { account in
                if let balance = account.plannedBalance, let currency = account.currency {
                    return OptionDataSource(id: account.number, title: account.number, description: "\(balance) \(currency)", color:                 getAccountStatusColor(with: account.status?.statusCode, isCheckedValue: false))
                } else {
                    return OptionDataSource(id: account.number, title: account.number, color: getAccountStatusColor(with: account.status?.statusCode, isCheckedValue: false))
                }
            }
        case .enrollAccountNumber:
            let accountComponent = self.component(by: .accountNumber)
            return dataSource(for: accountComponent)
        case .valueDate:
            if payDays != nil {
                return payDays!.map { OptionDataSource(id: $0, title: $0) }
            }
            return nil
        case .knp:
            return sourceData?.knp?.compactMap { OptionDataSource(id: $0.code, title: $0.code, description: $0.label) }
        case .paymentPurpose:
            return sourceData?.paymentPurposes?.compactMap { OptionDataSource(id: $0, title: $0) }
        case .director:
            return sourceData?.directors.compactMap { OptionDataSource(id: $0.fullName, title: $0.fullName) }
        case .accountant:
            return sourceData?.accountants.compactMap { OptionDataSource(id: $0.fullName, title: $0.fullName) }
        default:
            return nil
        }
    }
    
    func component(by domesticComponent: InternalTransferComponent) -> OperationComponent {
        return components.first(where: { $0.name == domesticComponent.rawValue })!
    }
    
    func optionSelectedWithLoaded(_ value: OptionDataSource?, component: OperationComponent, completion: ((Bool, String?) -> Void)?) -> Bool {
        switch component {
        case self.component(by: .template):
            if let valueId = value?.id, let id = Int(valueId) {
                component.setValue(newValue: id)
                requestTemplate(withId: id, onCompletion: completion)
                return true
            }
        case self.component(by: .knp):
            self.component(by: .descriptionKnp).isVisible = true
            self.component(by: .descriptionKnp).setValue(newValue: value?.description)
            if self.component(by: .descriptionKnp).value != nil {
                knpDescriptionText = self.component(by: .descriptionKnp).value!
            } else {
                knpDescriptionText = ""
            }
            self.component(by: .paymentPurposeInfo).setValue(newValue: setPaymentPurposeInfoText())
        //self.component(by: .paymentPurpose).setValue(newValue: value?.description)
        case self.component(by: .accountNumber), self.component(by: .enrollAccountNumber):
            component.description = value?.description
            guard let selectedAccount = sourceData?.accountViews?.first(where: { $0.number == value?.title }) else { return false }
            component.set(uiProperty: .isBlockedAccountFillTextColor(getAccountStatusColor(with: selectedAccount.status?.statusCode, isCheckedValue: true)))
            
            self.component(by: .accountCurrency).setValue(newValue: selectedAccount.currency)
            
            let secondComponent = self.component(by: component.name == InternalTransferComponent.accountNumber.rawValue ? .enrollAccountNumber : .accountNumber)
            
            if let accounts = self.dataSource(for: component),
                accounts.count == 2 &&
                    (accounts.contains(where: { $0.id == secondComponent.value }) || secondComponent.value == nil || secondComponent.value?.isEmpty == true) {
                let secondAccount = accounts.first(where: { $0.title != value?.title })
                secondComponent.setValue(newValue: secondAccount?.title)
                secondComponent.description = secondAccount?.description
            } else if secondComponent.value == component.value {
                secondComponent.setValue(newValue: "")
                secondComponent.description = nil
            }
        default:
            break
        }
        
        component.setValue(newValue: value?.id)
        changeValueDependencies(component: component, to: value?.id.isEmpty == false)
        component.errorDescription = nil
        
        return false
    }
    
    func switchedWithLoaded(to: Bool, component: OperationComponent, completion: ((Bool, String?) -> Void)?) -> Bool {
        if self.component(by: .urgentPaymentIndicator) == component {
            let canEditValueDate = to
            self.component(by: .valueDate).setValue(newValue: payDays?.first)
            self.component(by: .valueDate).set(uiProperty: .isUserInteractionEnabled(!canEditValueDate))
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
        } else if self.component(by: .paymentPurpose) == component {
            if let val  = component.value {
                paymentPurposeText = val
            } else {
                paymentPurposeText = ""
            }
            self.component(by: .paymentPurposeInfo).setValue(newValue: setPaymentPurposeInfoText())
        }
        return false
    }
    
    func isValid(components: [OperationComponent]) -> Bool {
        var result: Bool = true
        for component in components {
            component.errorDescription = nil
            guard let constraints = component.constraints else { continue }
            if let error = Validator.validatingError(text: component.value, constraint: constraints) {
                component.errorDescription = error
                result = false
            }
        }
        return result
    }
}

enum InternalTransferComponent: String {
    case template
    case documentNumber
    
    case accountCurrency
    case accountNumber
    case amount
    
    case enrollAccountNumber
    
    case urgentPaymentIndicator
    case valueDate
    case knp
    case descriptionKnp
    
    case paymentPurpose
    case paymentPurposeInfo
    case additionalInfo
    case bankResponse
    case director
    case accountant
}
