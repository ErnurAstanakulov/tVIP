//
//  ConversionViewModel.swift
//  DigitalBank
//
//  Created by Алем Утемисов on 09.05.2018.
//  Copyright © 2018 iosDeveloper. All rights reserved.
//

import Foundation

class ConversionViewModel: OperationViewModel {
    
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
    
    public var minAmount = 0.0
    var payDays: [String]?
    var currencyContracts: [CurrencyContract]?
    
    public var initialDocument: AccountTransfersFullModel? {
        didSet {
            component(by: .documentNumber).setValue(newValue: initialDocument?.number)
            component(by: .accountNumber).setValue(newValue: initialDocument?.account?.number)
            let amountFormatter = AmountFormatter()
            component(by: .accountNumber).description = amountFormatter.string(for: initialDocument?.account?.plannedBalance ?? 0.0)
            component(by: .template).setValue(newValue: initialDocument?.templateName)
            if let amount = initialDocument?.amount {
                let formattedAmount = String(format: "%.2f", amount).splittedAmount
                component(by: .amount).setValue(newValue: formattedAmount)
            }
            component(by: .fixAmount).setValue(newValue: initialDocument?.fixDebitSum)
            component(by: .fixReceiverAmount).setValue(newValue: initialDocument?.fixDebitSum == false)
            component(by: .receiverAccount).setValue(newValue: initialDocument?.creditAccount?.number)
            component(by: .receiverAccount).description = initialDocument?.creditAccount?.balance?.description
            if let account = initialDocument?.creditAccount?.balance?.description {
                let curr = account.suffix(3)
                self.loadContracts(currency: String(curr))
            }
            if let receiverAmount = initialDocument?.creditSum {
                let formattedReceiverAmount = String(format: "%.2f", receiverAmount).splittedAmount
                component(by: .receiverAmount).setValue(newValue: formattedReceiverAmount)
            }
            if let exchangeRate = initialDocument?.exchangeRate {
                let formattedExchangeRateAmount = String(format: "%.2f", exchangeRate).splittedAmount
                component(by: .exchangeRate).setValue(newValue: formattedExchangeRateAmount)
            }
            component(by: .commissionAccount).setValue(newValue: initialDocument?.feeAccount?.number)
            component(by: .valueDate).setValue(newValue: initialDocument?.valueDate)
            component(by: .knp).setValue(newValue: initialDocument?.purposeCode)
            component(by: .descriptionKnp).setValue(newValue: initialDocument?.purposeCodeLabel)
            component(by: .paymentPurpose).setValue(newValue: initialDocument?.purpose)
            if let bankResponse = initialDocument?.bankResponse {
                component(by: .bankResponse).setValue(newValue: bankResponse)
                component(by: .bankResponse).isVisible = true
            }
            if let isIndividualRate = initialDocument?.individualExchangeRate {
                component(by: .individualRate).isVisible = isIndividualRate
                component(by: .individualRate).setValue(newValue: isIndividualRate)
                component(by: .exchangeRate).set(uiProperty: .isUserInteractionEnabled(isIndividualRate))
            }
            component(by: .dealPurpose).setValue(newValue: initialDocument?.operationTargetCode)
            component(by: .accountant).setValue(newValue: initialDocument?.accountant?.fullName)
            component(by: .director).setValue(newValue: initialDocument?.director?.fullName)
            component(by: .executionRateAgreement).setValue(newValue: true)
            component(by: .info).setValue(newValue: initialDocument?.info)
            if initialDocument?.state == Constants.DocumentState.executed {
                component(by: .executionRate).isVisible = true
                if let executionRate = initialDocument?.executionRate {
                    component(by: .executionRate).setValue(newValue: String(format: "%.2f", executionRate))
                }
                if initialDocument?.fixDebitSum == true {
                    component(by: .receiverAmount).setValue(newValue: String(format: "%.2f",initialDocument?.executionAmount ?? 0.00).splittedAmount)
                } else {
                    component(by: .amount).setValue(newValue: String(format: "%.2f", initialDocument?.executionAmount ?? 0.00).splittedAmount)
                }
            }
        }
    }
    var sourсeData: AccountTransfersDataSource? {
        didSet {
            let accountantsCount = sourсeData?.accountants.count ?? 0
            if accountantsCount <= 1 {
                component(by: .accountant).set(uiProperty: .isUserInteractionEnabled(false))
            }
            if initialDocument == nil {
                component(by: .documentNumber).setValue(newValue: sourсeData?.documentNumber)
                component(by: .director).setValue(newValue: sourсeData?.directors.first?.fullName)
                component(by: .accountant).setValue(newValue: accountantsCount == 0 ? "Не предусмотрен" : sourсeData?.accountants.first?.fullName)
            } else if initialDocument?.accountant == nil && accountantsCount == 0 {
                component(by: .accountant).setValue(newValue: "Не предусмотрен")
            }

            if initialDocument?.valueDate == nil {
                component(by: .valueDate).setValue(newValue: sourсeData?.valueDates?.currentDate)
            }
            if initialDocument?.number == nil {
                component(by: .documentNumber).setValue(newValue: sourсeData?.documentNumber)
                component(by: .valueDate).setValue(newValue: sourсeData?.valueDates?.currentDate)
            }
            if let payDays = sourсeData?.valueDates?.dates {
                if payDays.count == 0 {
                    component(by: .valueDate).set(uiProperty: .isUserInteractionEnabled(false))
                } else {
                    component(by: .valueDate).set(uiProperty: .isUserInteractionEnabled(true))
                }
            }
        }
    }
    
    var conversionToSend: AccountTransfersToSend? {
        let conversionToSend = AccountTransfersToSend()
        let accountNumber = component(by: .accountNumber).value
        let receiverAccountNumber = component(by: .receiverAccount).value
        let commisionAccountNumber = component(by: .commissionAccount).value
        let contract = component(by: .currencyContract).value
        conversionToSend.number = component(by: .documentNumber).value
        conversionToSend.account = sourсeData?.accountsViews?.first(where: { $0.number == accountNumber })
        conversionToSend.feeAccount = sourсeData?.feeAccounts?.first(where: { $0.number == commisionAccountNumber })
        conversionToSend.templateName = component(by: .template).value ?? ""
        conversionToSend.amount = component(by: .amount).value?.trim()
        conversionToSend.creditSum = component(by: .receiverAmount).value?.trim()
        conversionToSend.fixDebitSum = component(by: .fixAmount).getValue()
        conversionToSend.creditAccount = sourсeData?.accountsViews?.first(where: { $0.number == receiverAccountNumber })
        if let exchangeRate = component(by: .exchangeRate).value {
            conversionToSend.exchangeRate = exchangeRate.trim()
        }
        if let individualRate: Bool = component(by: .individualRate).getValue() {
            conversionToSend.individualExchangeRate = individualRate
        }
        conversionToSend.purposeCode = component(by: .knp).value
        conversionToSend.purpose = component(by: .paymentPurpose).value
        conversionToSend.valueDate = component(by: .valueDate).value
        conversionToSend.director = sourсeData?.directors.first { $0.fullName == self.component(by: .director).value }
        conversionToSend.accountant = sourсeData?.accountants.first { $0.fullName == self.component(by: .accountant).value }
        conversionToSend.operationTargetId = sourсeData?.operationTargets?.first { $0.code == self.component(by: .dealPurpose).value }?.id.description
        if let info = component(by: .info).value {
            conversionToSend.info = info
        }
        conversionToSend.contractId = sourсeData?.currencyContracts?.first { $0.contractNumber == contract }?.id
        return conversionToSend
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
    
    func dataSource(for component: OperationComponent) -> [OptionDataSource]? {
        guard let componenType = ConversionComponent(rawValue: component.name) else { return nil }
        let amountFormatter = AmountFormatter()
        switch componenType {
        case .accountNumber:
            let currency = sourсeData?.accountsViews?.first(where: { $0.number == self.component(by: .receiverAccount).value })?.currency
            return sourсeData?.accountsViews?.filter({$0.currency != currency}).compactMap {
                let balance = amountFormatter.string(for: $0.plannedBalance ?? 0.0) ?? "0.00"
                return OptionDataSource(id: $0.number, title: $0.number, description: "\(balance) \($0.currency ?? "")", color: getAccountStatusColor(with: $0.status?.statusCode, isCheckedValue: false))
            }
        case .template:
            return sourсeData?.templates?.compactMap { OptionDataSource(id: $0.id.description, title: $0.templateName) }
        case .valueDate:
            if payDays != nil {
                return payDays!.map { OptionDataSource(id: $0, title: $0) }
            }
            return nil
        case .paymentPurpose:
            return sourсeData?.purposes?.compactMap { OptionDataSource(id: $0, title: $0) }
        case .commissionAccount:
            return sourсeData?.feeAccounts?.compactMap { OptionDataSource(id: $0.number, title: $0.number, color: getAccountStatusColor(with: $0.status?.statusCode, isCheckedValue: false))}
        case .receiverAccount:
            let currency = sourсeData?.accountsViews?.first(where: { $0.number == self.component(by: .accountNumber).value })?.currency
            return sourсeData?.accountsViews?.filter({$0.currency != currency}).compactMap {
                let balance = amountFormatter.string(for: $0.plannedBalance ?? 0.0) ?? "0.00"
                return OptionDataSource(id: $0.number, title: $0.number, description: "\(balance) \($0.currency ?? "")", color: getAccountStatusColor(with: $0.status?.statusCode, isCheckedValue: false)) }
        case .knp:
            return sourсeData?.knp?.compactMap { OptionDataSource(id: $0.code, title: $0.code, description: $0.label) }
        case .dealPurpose:
            return sourсeData?.operationTargets?.compactMap { OptionDataSource(id: $0.id.description, title: $0.code, description: $0.name) }
        case .director:
            return sourсeData?.directors.compactMap { OptionDataSource(id: $0.fullName, title: $0.fullName) }
        case .accountant:
            return sourсeData?.accountants.compactMap { OptionDataSource(id: $0.fullName, title: $0.fullName) }
        case .currencyContract:
            if currencyContracts != nil {
                return currencyContracts!.map { OptionDataSource(id: $0.id.description, title: $0.contractNumber ?? "")  }
            }
            return nil
        default:
            return nil
        }
    }
    
    func component(by conversionComponent: ConversionComponent) -> OperationComponent {
        return components.first(where: { $0.name == conversionComponent.rawValue })!
    }
    
    func optionSelectedWithLoaded(_ value: OptionDataSource?, component: OperationComponent, completion: ((Bool, String?) -> Void)?) -> Bool {
        if self.component(by: .knp) == component {
            self.component(by: .descriptionKnp).setValue(newValue: value?.description)
            self.component(by: .paymentPurpose).setValue(newValue: value?.description)
        }
        if let valueId = value?.id, let id = Int(valueId), self.component(by: .template) == component {
            component.setValue(newValue: id)
            requestTemplate(withId: id, onCompletion: completion)
            return true
        }
        component.setValue(newValue: value?.id)
        
        if self.component(by: .accountNumber) == component || self.component(by: .receiverAccount) == component || self.component(by: .valueDate) == component {
            component.description = value?.description
            if let currency = sourсeData?.accountsViews?.first(where: { $0.number == value?.id })?.currency {
                
                component.set(uiProperty: .isBlockedAccountFillTextColor(getAccountStatusColor(with: sourсeData?.accountsViews?.first(where: { $0.number == value?.title })?.status?.statusCode, isCheckedValue: true)))
                component.set(uiProperty: .isBlockedAccountFillTextColor(getAccountStatusColor(with: sourсeData?.feeAccounts?.first(where: { $0.number == value?.title })?.status?.statusCode, isCheckedValue: true)))
                
                return requestCurrencyContractInfo(currency: currency, onCompletion: completion)
            }
            return prepareForExchangeRate(completion: completion)
        }
        if self.component(by: .dealPurpose) == component {
            component.setValue(newValue: value?.title)
            self.component(by: .paymentPurpose).setValue(newValue: value?.description)
        }
        if self.component(by: .currencyContract) == component {
            if let selectedId = value?.id, let selectedCurrencyContract = sourсeData?.currencyContracts?.first(where: { $0.id == Int(selectedId) }) {
                self.component(by: .contractDate).setValue(newValue: selectedCurrencyContract.contractDate)
            }
            component.setValue(newValue: value?.title)
        }
        if self.component(by: .commissionAccount) == component {
            component.set(uiProperty: .isBlockedAccountFillTextColor(getAccountStatusColor(with: sourсeData?.feeAccounts?.first(where: { $0.number == value?.title })?.status?.statusCode, isCheckedValue: true)))
        }
        component.errorDescription = nil
        return false
    }
    
    func isValid(components: [OperationComponent]) -> Bool {
        var result: Bool = true
        var account: AccountsViews?
        var sum: Double?
        var resCode: String?
        var isCurrencyContractFilled = false
        for component in components {
            if component == self.component(by: .executionRateAgreement) {
                let isAgreeExecutionRate: Bool = component.getValue() ?? false
                if isAgreeExecutionRate == false {
                    component.errorDescription = "Обязательное поле!"
                    result = false
                }
            }
            if component == self.component(by: .accountNumber) {
                let accountNumber = self.component(by: .accountNumber).value
                account = sourсeData?.accountsViews?.first(where: { $0.number == accountNumber })
                resCode = sourсeData?.customerView?.residencyCode
            }
            if component == self.component(by: .amount) {
                if let amount = self.component(by: .amount).value {
                    sum = Double(amount)
                }
            }
            if component == self.component(by: .currencyContract) {
                isCurrencyContractFilled = (self.component(by: .currencyContract).value != nil) ? true : false
            }
            guard let constraints = component.constraints else { continue }
            if let error = Validator.validatingError(text: component.value, constraint: constraints) {
                component.errorDescription = error
                result = false
            }
        }
        guard let accountView = account, let amount = sum, let residencyCode = resCode, let code = Int(residencyCode) else {
            return result
        }
        if( accountView.currency == "KZT" && amount > self.minAmount && code >= 11 && code <= 18 && isCurrencyContractFilled == false) {
            result = false
            let component = components.first { $0.type == .amount }
            component?.errorDescription = "Обязательное поле!"
            return result
        }
        return result
    }
    
    func prepareForExchangeRate(completion: ((Bool, String?) -> Void)?) -> Bool {
        guard let accountNumber = component(by: .accountNumber).value,
            let receiverAccountNumber = component(by: .receiverAccount).value,
            !accountNumber.isEmpty && !receiverAccountNumber.isEmpty else {
            return false
        }
        var amount = "0.00"
        var isReceivingAmount = false
        if let sendingAmount = component(by: .amount).value, component(by: .fixAmount).getValue() == true  {
            amount = sendingAmount
            isReceivingAmount = false
        } else if let recievingAmount = component(by: .receiverAmount).value, component(by: .fixReceiverAmount).getValue() == true {
            amount = recievingAmount
            isReceivingAmount = true
        } else {
            return false
        }
        
        return getExchangeRateWithLoaded(amount: amount, isReceivingAmount: isReceivingAmount, onCompletion: completion)
    }
    
    func amountFieldValueChangeWithLoaded(_ value: String?, component: OperationComponent, completion: ((Bool, String?) -> Void)?) -> Bool {
        guard let amountString = value else {
            component.setValue(newValue: "0.00")
            component.errorDescription = nil
            return false
        }
        component.setValue(newValue: amountString)
        component.errorDescription = nil
        return prepareForExchangeRate(completion: completion)
    }
    
    func switchedWithLoaded(to: Bool, component: OperationComponent, completion: ((Bool, String?) -> Void)?) -> Bool {
        component.setValue(newValue: to)
        changeValueDependencies(component: component, to: to)
        component.errorDescription = nil
        if component == self.component(by: .fixAmount) {
            self.component(by: .amount).set(uiProperty: .isUserInteractionEnabled(to))
            self.component(by: .fixReceiverAmount).setValue(newValue: !to)
            self.component(by: .receiverAmount).set(uiProperty: .isUserInteractionEnabled(!to))
            return prepareForExchangeRate(completion: completion)
        } else if component == self.component(by: .fixReceiverAmount) {
            self.component(by: .receiverAmount).set(uiProperty: .isUserInteractionEnabled(to))
            self.component(by: .fixAmount).setValue(newValue: !to)
            self.component(by: .amount).set(uiProperty: .isUserInteractionEnabled(!to))
            return prepareForExchangeRate(completion: completion)
        } else if component == self.component(by: .individualRate) {
            self.component(by: .exchangeRate).set(uiProperty: .isUserInteractionEnabled(to))
            self.component(by: .exchangeRate).placeholder = to ? "Введите данные" : nil
            return prepareForExchangeRate(completion: completion)
        }
        return false
    }
    
    func textfieldValueChangedWithLoaded(_ value: String?, component: OperationComponent, completion: ((Bool, String?) -> Void)?) -> Bool {
        component.setValue(newValue: value)
        changeValueDependencies(component: component, to: value?.isEmpty == false)
        component.errorDescription = nil
        if self.component(by: .documentNumber) == component {
            if let value = value {
                let validateContext = ValidateDocumentNumberContext(number: value, documentType: Constants.DocumentType.accountTransfer)
                validateContext.load(isSuccsess: { (response) in
                    if let number = response as? String, number != "ok" {
                        component.errorDescription = "Предлагаемый порядковый номер \(number)"
                        completion?(true, nil)
                    }
                })
            }
        }
        return false
    }
    
    var documentActionDataArray: [DocumentActionData]? = nil
    
    var jsonParameters: [String: Any] {
        if let json = conversionToSend?.toJSON() {
            return json
        }
        
        return [:]
    }
    
    var componentsAreValid: Bool {
        return isValid(components: components)
    }
}

enum ConversionComponent: String {
    case template
    case documentNumber
    case accountNumber
    case amount
    case fixAmount
    case receiverAccount
    case receiverAmount
    case fixReceiverAmount
    case individualRate
    case exchangeRate
    case executionRate
    case commissionAccount
    case valueDate
    case knp
    case descriptionKnp
    case paymentPurpose
    case bankResponse
    case dealPurpose
    case director
    case accountant
    case info
    case executionRateAgreement
    case currencyContract
    case contractDate
}
