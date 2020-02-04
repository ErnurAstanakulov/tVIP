//
//  InternationalTransferViewModel.swift
//  DigitalBank
//
//  Created by Алем Утемисов on 09.05.2018.
//  Copyright © 2018 iosDeveloper. All rights reserved.
//

import Foundation

class InternationalTransferViewModel: OperationViewModel {
    
    weak var viewController: OperationsTableViewControllerProtocol?
    var components: [OperationComponent] = []
    var documentId: Int?
    private var VOCode: String?
    private var contractNumber: String?
    private var contractDate: String?
    private var contractConsideredNumber: String?
    private var contractConsideredDate: String?
    private var invoiceNumber: String?
    private var paymentPurposeText: String?
    var currencyContracts: [InternationalCurrencyContract]?
    var payDays: [String]?
    var currencyLimitConst: Double?
    var kbeConstants: [String] = (21...29).map(String.init)
    var currencyOperationLimit: Double?
    var usdAmount: Double?
    var bankBikTransactionLimits: [String]?
    var accountFromDepositRUB: String?
    
    var thresholdAmount: Double? {
        didSet {
            if thresholdAmount != nil {
                if let beneficiaryResidencyCodeString = component(by: .kbe).value,
                   let beneficiaryResidencyCode = Int(beneficiaryResidencyCodeString),
                   let customerResidencyCodeString = sourceData?.customerView?.residencyCode ?? initialDocument?.custResidencyCode,
                   let customerResidencyCode = Int(customerResidencyCodeString),
                   let amountString = self.component(by: .amount).value,
                   let amount = Double(amountString) {
                    updateVisabilityOfAgreementComponents(amount: amount, customerResidencyCode: customerResidencyCode, beneficiaryResidencyCode: beneficiaryResidencyCode)
                }
            } else {
                hideAgreementComponents()
            }
        }
    }
    var sourceData: InternationalTransferDataSource? {
        didSet {
            let accountantsCount = sourceData?.accountants.count ?? 0
            if accountantsCount <= 1 {
                component(by: .accountant).set(uiProperty: .isUserInteractionEnabled(false))
            }
            
            if initialDocument == nil {
                component(by: .documentNumber).setValue(newValue: sourceData?.documentNumber)
                component(by: .intlAddress).setValue(newValue: sourceData?.customerView?.intlAddress)
                component(by: .director).setValue(newValue: sourceData?.directors.first?.fullName)
                component(by: .accountant).setValue(newValue: accountantsCount == 0 ? "Не предусмотрен" : sourceData?.accountants.first?.fullName)
            } else if initialDocument?.accountant == nil && accountantsCount == 0 {
                component(by: .accountant).setValue(newValue: "Не предусмотрен")
            }
            
            if let isUrgent = initialDocument?.priority {
                component(by: .valueDate).set(uiProperty: .isUserInteractionEnabled(!isUrgent))
            }
            if initialDocument?.number == nil {
                component(by: .documentNumber).setValue(newValue: sourceData?.documentNumber)
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
    var isEditing: Bool = true {
        didSet {
            components.forEach {
                if $0 == component(by: .transliterate) { return }
                $0.set(uiProperty: .isUserInteractionEnabled(isEditing))
                if !isEditing {
                    $0.placeholder =  "Не заполнено"
                }
            }
        }
    }
    
    /*
     Should be set after sourceData setup
    */
    var initialDocument: InternationalTransfer? {
        didSet {
            component(by: .documentNumber).setValue(newValue: initialDocument?.number)
            
            let amountFormatter = AmountFormatter()
            component(by: .accountNumber).setValue(newValue: initialDocument?.account?.number)
            component(by: .accountNumber).description = amountFormatter.string(for: initialDocument?.account?.plannedBalance ?? 0.0) ?? "0.00"
            component(by: .intlAddress).setValue(newValue: initialDocument?.senderAddress)
            component(by: .accountCurrency).setValue(newValue: initialDocument?.account?.currency)
            let currencyIsRUB = initialDocument?.account?.currency == Constants.Сurrency.RUB
            component(by: .VOCode).isVisible = currencyIsRUB
            component(by: .VOCode).setValue(newValue: initialDocument?.currencyOperationType)
            component(by: .template).setValue(newValue: initialDocument?.templateName)
            component(by: .receiverName).setValue(newValue: initialDocument?.benefName)
            component(by: .iin).setValue(newValue: initialDocument?.benefTaxCode)
            component(by: .kbe).setValue(newValue: initialDocument?.benefResidencyCode)
            component(by: .kpp).isVisible = currencyIsRUB
            component(by: .kpp).setValue(newValue: initialDocument?.benefKpp)
            if let benefCountryCode = initialDocument?.benefCountryCode {
                component(by: .countryCode).setValue(newValue: benefCountryCode)
                if let benefCountry = initialDocument?.benefCountry {
                    component(by: .country).setValue(newValue: benefCountry)
                    component(by: .country).isVisible = true
                }
            }
            component(by: .city).setValue(newValue: initialDocument?.benefCity)
            component(by: .address).setValue(newValue: initialDocument?.benefAddress)
            component(by: .receiverAccount).setValue(newValue: initialDocument?.benefAccount)
            component(by: .receiverBankBik).setValue(newValue: initialDocument?.benefBankCode)
            if let bankName = initialDocument?.benefBankName {
                component(by: .receiverBankName).setValue(newValue: bankName)
                component(by: .receiverBankName).isVisible = true
            }
            component(by: .receiverCorrespondentAccount).setValue(newValue: initialDocument?.benefBankCorrAccount)
            if let benefBankCountryCode = initialDocument?.benefBankCountryCode {
                component(by: .receiverBankCountryCode).setValue(newValue: benefBankCountryCode)
                if let benefBankCountry = initialDocument?.benefBankCountry {
                    component(by: .receiverBankCountry).setValue(newValue: benefBankCountry)
                }
            }
            component(by: .receiverBankCity).setValue(newValue: initialDocument?.benefBankCity)
            component(by: .receiverBankAddress).setValue(newValue: initialDocument?.benefBankAddress)
            
            component(by: .agentBankBik).setValue(newValue: initialDocument?.agentBankCode)
            if let bankName = initialDocument?.agentBankName {
                component(by: .agentBankName).setValue(newValue: bankName)
                component(by: .agentBankName).isVisible = true
            }
            component(by: .agentCorrespondentAccount).setValue(newValue: initialDocument?.agentCorrAccount)
            if let agentBankCountryCode = initialDocument?.agentBankCountryCode {
                component(by: .agentBankCountryCode).setValue(newValue: agentBankCountryCode)
                if let agentBankCountry = initialDocument?.agentBankCountry {
                    component(by: .agentBankCountry).setValue(newValue: agentBankCountry)
                }
            }
            component(by: .agentBankCity).setValue(newValue: initialDocument?.agentBankCity)
            component(by: .agentBankAddress).setValue(newValue: initialDocument?.agentBankAddress)
            component(by: .valueDate).setValue(newValue: initialDocument?.valueDate ?? "")
            component(by: .amount).setValue(newValue: String(format: "%2f", initialDocument?.amount ?? 0.00).splittedAmount)
            component(by: .contractNumber).setValue(newValue: initialDocument?.contractNumber)
            component(by: .contractDate).setValue(newValue: initialDocument?.contractDate)
            component(by: .contractConsideredNumber).setValue(newValue: initialDocument?.contractAuditNumber)
            component(by: .contractConsideredDate).setValue(newValue: initialDocument?.contractAuditDate)
            component(by: .commissionType).setValue(newValue: initialDocument?.feeTypeCode)
            component(by: .commissionTypeName).setValue(newValue: sourceData?.feeTypes?.first { $0.code == initialDocument?.feeTypeCode }?.label)
            component(by: .commissionAccount).setValue(newValue: initialDocument?.feeAccount?.number)
            component(by: .commissionAccount).description = amountFormatter.string(for: String(initialDocument?.feeAccount?.balance ?? 0.0))
            component(by: .knp).setValue(newValue: initialDocument?.purposeCode)
            if let purposeLabel = initialDocument?.purposeCodeLabel {
                component(by: .descriptionKnp).setValue(newValue: purposeLabel)
                component(by: .descriptionKnp).isVisible = true
            }
            component(by: .kvo).setValue(newValue: initialDocument?.kvo)
            if let kvoLabel = initialDocument?.kvoLabel {
                component(by: .descriptionKvo).setValue(newValue: kvoLabel)
                component(by: .descriptionKvo).isVisible = true
            }
            component(by: .paymentPurpose).setValue(newValue: initialDocument?.purpose)
            component(by: .paymentPurposeInfo).setValue(newValue: initialDocument?.purposeUserValue)
            component(by: .additionalInfo).setValue(newValue: initialDocument?.additionalInfo)
            if let bankResponse = initialDocument?.bankResponse {
                component(by: .bankResponse).setValue(newValue: bankResponse)
                component(by: .bankResponse).isVisible = true
            }
            component(by: .noTerror).setValue(newValue: initialDocument?.isNotLinkTerrorism)
            component(by: .noUnc).setValue(newValue: initialDocument?.isNotNeedUnc)
            component(by: .isPermitGiveInformation).setValue(newValue: initialDocument?.isPermitGiveInformation)
            component(by: .accountant).setValue(newValue: initialDocument?.accountant?.fullName)
            component(by: .director).setValue(newValue: initialDocument?.director?.fullName)
            component(by: .invoiceDate).setValue(newValue: initialDocument?.invoiceDate)
            component(by: .invoice).setValue(newValue: initialDocument?.invoice)
            component(by: .transliterate).setValue(newValue: initialDocument?.transliterate)
            component(by: .transliterate).isVisible = initialDocument?.transliterate ?? false
            if let currency = component(by: .accountCurrency).value {
                loadThresholdAmount(forCurrency: currency, onCompletion: nil)
                loadCurrencyContractInfo(byCurrencyId: currency)
                let currencyIsRUB = (currency == Constants.Сurrency.RUB)
                [self.component(by: .codeTypeOperation), self.component(by: .number4), self.component(by: .number5), self.component(by: .number6), self.component(by: .number7), self.component(by: .number8), self.component(by: .number9), self.component(by: .number10)].forEach { $0.isVisible = currencyIsRUB }
                if currencyIsRUB {
                    component(by: .codeTypeOperation).setValue(newValue: initialDocument?.operationTypeCode)
                    component(by: .number4).setValue(newValue: initialDocument?.field_N4)
                    component(by: .number5).setValue(newValue: initialDocument?.field_N5)
                    component(by: .number6).setValue(newValue: initialDocument?.basisTaxPayment)
                    component(by: .number7).setValue(newValue: initialDocument?.taxPeriod)
                    component(by: .number8).setValue(newValue: initialDocument?.taxIdNumber)
                    component(by: .number9).setValue(newValue: initialDocument?.taxDocumentDate)
                    component(by: .number10).setValue(newValue: initialDocument?.taxDocumentType)
                }
            }
        }
    }
    
    var transferToSend: InternationalTransferToSend? {
        let transferToSend = InternationalTransferToSend()
        let accountNumber = component(by: .accountNumber).value
        let feeAccountNumber = component(by: .commissionAccount).value
        
        transferToSend.templateName = component(by: .template).value
        transferToSend.account = sourceData?.foreignAccountViews?.first(where: { $0.number == accountNumber })
        transferToSend.senderAddress = component(by: .intlAddress).value
        transferToSend.benefName = component(by: .receiverName).value
        transferToSend.benefTaxCode = component(by: .iin).value
        transferToSend.benefId = sourceData?.counterparties?.first(where: ({ $0.counterparty?.bin == component(by: .iin).value }))?.counterparty?.id
        transferToSend.benefResidencyCode = component(by: .kbe).value
        transferToSend.benefKpp = component(by: .kpp).value
        transferToSend.benefCountryCode = component(by: .countryCode).value
        transferToSend.benefCity = component(by: .city).value
        transferToSend.benefAddress = component(by: .address).value
        transferToSend.benefAccount = component(by: .receiverAccount).value
        transferToSend.benefBankCode = component(by: .receiverBankBik).value
        transferToSend.benefBankCorrAccount = component(by: .receiverCorrespondentAccount).value
        transferToSend.benefBankCountryCode = component(by: .receiverBankCountryCode).value
        transferToSend.benefBankCountry = component(by: .receiverBankCountry).value
        transferToSend.benefBankCity = component(by: .receiverBankCity).value
        transferToSend.benefBankAddress = component(by: .receiverBankAddress).value
        transferToSend.agentBankCode = component(by: .agentBankBik).value
        transferToSend.agentCorrAccount = component(by: .agentCorrespondentAccount).value
        transferToSend.agentBankCountry = component(by: .agentBankCountry).value
        transferToSend.agentBankCountryCode = component(by: .agentBankCountryCode).value
        transferToSend.agentBankCity = component(by: .agentBankCity).value
        transferToSend.agentBankAddress = component(by: .agentBankAddress).value
        transferToSend.priority = false
        transferToSend.valueDate = component(by: .valueDate).value
        transferToSend.amount = component(by: .amount).value?.trim()
        transferToSend.number = component(by: .documentNumber).value
        transferToSend.isTemplate = false
        transferToSend.contractNumber = component(by: .contractNumber).value
        transferToSend.contractDate = component(by: .contractDate).value
        transferToSend.contractAuditNumber = component(by: .contractConsideredNumber).value
        transferToSend.contractAuditDate = component(by: .contractConsideredDate).value
        transferToSend.feeTypeCode = component(by: .commissionType).value
        transferToSend.feeAccount = sourceData?.feeAccounts?.first(where: { $0.number == feeAccountNumber })
        transferToSend.purposeCode = component(by: .knp).value
        transferToSend.kvo = component(by: .kvo).value
        transferToSend.kvoLabel = component(by: .descriptionKvo).value
        transferToSend.purpose = component(by: .paymentPurpose).value
        transferToSend.purposeUserValue = component(by: .paymentPurposeInfo).value
        transferToSend.additionalInfo = component(by: .additionalInfo).value
        transferToSend.isNotNeedUnc = component(by: .noUnc).getValue()
        transferToSend.isNotLinkTerrorism = component(by: .noTerror).getValue()
        transferToSend.isPermitGiveInformation = component(by: .isPermitGiveInformation).getValue()
        transferToSend.director = sourceData?.directors.first { $0.fullName == self.component(by: .director).value }
        transferToSend.accountant = sourceData?.accountants.first { $0.fullName == self.component(by: .accountant).value }
        transferToSend.invoice = component(by: .invoice).value
        transferToSend.invoiceDate = component(by: .invoiceDate).value
        transferToSend.currencyOperationType = component(by: .VOCode).value
        transferToSend.benefBankName = component(by: .receiverBankName).value
        transferToSend.agentBankName = component(by: .agentBankName).value
        transferToSend.transliterate = component(by: .transliterate).getValue()
        transferToSend.operationTypeCode = component(by: .codeTypeOperation).getValue()
        transferToSend.field_N4 = component(by: .number4).value
        transferToSend.field_N5 = component(by: .number5).value
        transferToSend.basisTaxPayment = component(by: .number6).getValue()
        transferToSend.taxPeriod = component(by: .number7).value
        transferToSend.taxIdNumber = component(by: .number8).value
        transferToSend.taxDocumentDate = component(by: .number9).getValue()
        transferToSend.taxDocumentType = component(by: .number10).getValue()
        return transferToSend
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
        guard let componenType = InternationalTransferComponent(rawValue: component.name) else { return nil }
        switch componenType {
        case .accountNumber:
            let selectedCurrency = self.component(by: .accountCurrency).value
            let amountFormatter = AmountFormatter()
            return sourceData?.foreignAccountViews?
                .filter { $0.currency == selectedCurrency || selectedCurrency == nil }
                .compactMap {
                    let amountString = amountFormatter.string(for: $0.plannedBalance ?? 0.0) ?? "0"
                    return OptionDataSource(id: $0.number, title: $0.number, description: "\(amountString) \($0.currency ?? "")", color: getAccountStatusColor(with: $0.status?.statusCode, isCheckedValue: false))
            }
        case .accountCurrency:
            guard let currencies = sourceData?.foreignAccountViews?.compactMap({ $0.currency }) else {
                return []
            }
            let uniqueCurrencies = Array(Set(currencies))
            return uniqueCurrencies.compactMap { OptionDataSource(id: $0, title: $0) }
        case .template:
            return sourceData?.templates?.compactMap { OptionDataSource(id: $0.id.description, title: $0.templateName) }
        case .valueDate:
            if payDays != nil {
                return payDays!.map {
                    OptionDataSource(id: $0, title: $0)
                }
            }
            return nil
        case .receiverName:
            return sourceData?.counterparties?.compactMap {
                OptionDataSource.init(
                    id: $0.counterparty?.internationalName,
                    title: $0.counterparty?.internationalName,
                    description: $0.counterparty?.bin
                )
            }
        case .iin:
            return sourceData?.counterparties?.compactMap {
                OptionDataSource.init(
                    id: $0.counterparty?.bin,
                    title: $0.counterparty?.bin,
                    description: $0.counterparty?.internationalName
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
                let counterParty = sourceData?.counterparties?.first(where: { $0.counterparty?.internationalName == counterpartyName }) else { return nil }
            return counterParty.accounts?.compactMap { OptionDataSource(id: $0.iban, title: $0.iban) }
        case .receiverBankBik:
            if let counterpartyName = self.component(by: .receiverName).value,
                let counterParty = sourceData?.counterparties?.first(where: { $0.counterparty?.internationalName == counterpartyName }) {
                return counterParty.accounts?.compactMap { OptionDataSource(id: $0.internationalBank?.internationalBankBik, title: $0.internationalBank?.internationalBankBik, description: $0.bank?.bankName) }
            } else {
                return sourceData?.banksSwifts?.compactMap {  OptionDataSource.init(id: $0, title: $0)  }
            }
        case .knp:
            return sourceData?.knp?.compactMap { OptionDataSource(id: $0.code, title: $0.code, description: $0.label) }
        case .kvo:
            return getKvoList()?.compactMap { OptionDataSource(id: $0.code, title: $0.code, description: $0.name) }
        case .agentBankBik:
            return sourceData?.banksSwifts?.compactMap { OptionDataSource(id: $0, title: $0)  }
        case .countryCode:
            return sourceData?.countries?.compactMap { OptionDataSource(id: $0.twoLetterCode, title: $0.twoLetterCode, description: $0.fullCountryName) }
        case .commissionType:
            return sourceData?.feeTypes?.compactMap { OptionDataSource(id: $0.code, title: $0.code, description: $0.label) }
        case .commissionAccount:
            let amountFormatter = AmountFormatter()
            return sourceData?.feeAccounts?.compactMap { feeAccount in
                let description: String?
                if let plannedBalance = amountFormatter.string(for: feeAccount.plannedBalance ?? ""),
                   let currency = feeAccount.currency {
                    description = String(plannedBalance) + " " + currency
                } else {
                    description = nil
                }
                return OptionDataSource(id: feeAccount.number, title: feeAccount.number, description: description, color: getAccountStatusColor(with: feeAccount.status?.statusCode, isCheckedValue: false))
            }
        case .VOCode:
            return sourceData?.currencyOperationTypes?.compactMap { OptionDataSource(id: $0.code, title: $0.code, description: $0.label) }
        case .director:
            return sourceData?.directors.compactMap { OptionDataSource(id: $0.fullName, title: $0.fullName) }
        case .accountant:
            return sourceData?.accountants.compactMap { OptionDataSource(id: $0.fullName, title: $0.fullName) }
        case .contractNumber:
            return currencyContracts?.compactMap { OptionDataSource(id: $0.contractNumber, title: $0.contractNumber) }
        case .codeTypeOperation:
            return sourceData?.rubCodeOperations?.compactMap { OptionDataSource(id: $0.code, title: $0.label) }
        case .number6:
            return sourceData?.basisTaxPayments?.compactMap { OptionDataSource(id: $0.code, title: $0.label) }
        case .number10:
            return sourceData?.taxDocumentTypes?.compactMap { OptionDataSource(id: $0.code, title: $0.label) }
        default:
            return nil
        }
    }
    
    func searchResults(for text: String, in component: OperationComponent, optionsDataSourceCallback: (([OptionDataSource]) -> Void)?) {
        guard let componenType = InternationalTransferComponent(rawValue: component.name) else { return }
        switch componenType {
        case .receiverBankBik:
            var isNumeric: Bool = false
            if self.component(by: .accountCurrency).value == Constants.Сurrency.RUB { isNumeric = true }
            loadBankSwifts(isNumeric: isNumeric, bik: text, optionsDataSourceCallback: optionsDataSourceCallback)
        case .agentBankBik:
            loadBankSwifts(bik: text, optionsDataSourceCallback: optionsDataSourceCallback)
        default:
            break
        }
    }

    func component(by internationalComponent: InternationalTransferComponent) -> OperationComponent {
        print(internationalComponent.rawValue)
        return components.first(where: { $0.name == internationalComponent.rawValue })!
    }
    
    func loadCurrencyContractInfo(byCurrencyId currencyId: String, completion: ((Bool, String?) -> Void)? = nil) {
        requestCurrencyContractInfo(currency: currencyId) { [weak self] (success, error) in
            if !success {
                completion?(success, error)
                return
            }
            self?.requestExchangeRate(currency: currencyId) { (success, error) in
                if !success {
                    completion?(success, error)
                    return
                }
                completion?(true, nil)
            }
        }
    }
    
    func optionSelectedWithLoaded(_ value: OptionDataSource?, component: OperationComponent, completion: ((Bool, String?) -> Void)?) -> Bool {
        switch component {
        case self.component(by: .accountCurrency):
            guard let currency = value?.id else { return false }
            let currencyIsRUB = (currency == Constants.Сurrency.RUB)
            [self.component(by: .codeTypeOperation), self.component(by: .number4), self.component(by: .number5), self.component(by: .number6), self.component(by: .number7), self.component(by: .number8), self.component(by: .number9), self.component(by: .number10)].forEach { (component) in
                component.isVisible = currencyIsRUB
                if !currencyIsRUB { component.clearValue() }
            }
            self.loadCurrencyContractInfo(byCurrencyId: currency, completion: completion)
        case self.component(by: .countryCode):
            component.setValue(newValue: value?.title)
            self.component(by: .country).setValue(newValue: value?.description)
            self.component(by: .country).isVisible = true
        case self.component(by: .receiverBankBik):
            component.setValue(newValue: value?.title)
            self.component(by: .receiverBankName).setValue(newValue: value?.description)
            self.component(by: .receiverBankName).isVisible = true
            if let idStr = value?.id {
                loadBankInfo(id: Int(idStr)) {[weak self] (bank, success, errorStr) in
                    if let bank = bank {
                        self?.component(by: .receiverBankCountryCode).setValue(newValue: bank.country?.twoLetterCode)
                        self?.component(by: .receiverBankCountry).setValue(newValue: bank.country?.countryName)
                        self?.component(by: .receiverBankCity).setValue(newValue: bank.city)
                        self?.component(by: .receiverBankAddress).setValue(newValue: bank.address)
                    }
                    completion?(success, errorStr)
                }
            }
            return true
        case self.component(by: .agentBankBik):
            component.setValue(newValue: value?.title)
            self.component(by: .agentBankName).setValue(newValue: value?.description)
            if let idStr = value?.id {
                loadBankInfo(id: Int(idStr)) {[weak self] (bank, success, errorStr) in
                    if let bank = bank {
                        self?.component(by: .agentBankCountryCode).setValue(newValue: bank.country?.twoLetterCode)
                        self?.component(by: .agentBankCountry).setValue(newValue: bank.country?.countryName)
                        self?.component(by: .agentBankCity).setValue(newValue: bank.city)
                        self?.component(by: .agentBankAddress).setValue(newValue: bank.address)
                    }
                    completion?(success, errorStr)
                }
            }
            return true
        case self.component(by: .knp):
            self.component(by: .descriptionKnp).setValue(newValue: value?.description)
            component.errorDescription = nil
            checkKvoByKnp()
        case self.component(by: .kvo):
            self.component(by: .descriptionKvo).setValue(newValue: value?.description)
            self.component(by: .descriptionKvo).isVisible = !(value?.description ?? "").isEmpty
        case self.component(by: .commissionType):
            self.component(by: .commissionTypeName).setValue(newValue: value?.description)
        case self.component(by: .template):
            guard let valueId = value?.id, let id = Int(valueId) else { break }
            component.setValue(newValue: value?.id)
            requestTemplate(withId: id, onCompletion: completion)
            return true
        case self.component(by: .accountNumber):
            component.description = value?.description
            self.component(by: .VOCode).isVisible = false
            self.component(by: .kpp).isVisible = false
            
            guard let account = sourceData?.foreignAccountViews?.first(where: { $0.number == value?.id })
                else { break }
            
            component.setValue(newValue: value?.id)
            let dispatchGroup = DispatchGroup()
            var isSuccess = true
            var errorMessage: String?
            
            dispatchGroup.enter()
            loadPayDays(onCompletion: { success, message in
                if !success {
                    isSuccess = false
                }
                errorMessage = message
                dispatchGroup.leave()
            })
            if let currency = account.currency {
                dispatchGroup.enter()
                loadFeeTypes(currency: currency, onCompletion: { success, message in
                    if !success {
                        isSuccess = false
                    }
                    errorMessage = message
                    dispatchGroup.leave()
                })
            }
            dispatchGroup.notify(queue: .main) {
                completion?(isSuccess, errorMessage)
            }
            
            let currencyIsRUB = account.currency?.uppercased().contains(Constants.Сurrency.RUB) == true
            self.component(by: .VOCode).isVisible = currencyIsRUB
            self.component(by: .kpp).isVisible = currencyIsRUB
            self.component(by: .accountCurrency).setValue(newValue: account.currency)
            self.component(by: .commissionType).setValue(newValue: "")
            self.component(by: .commissionTypeName).setValue(newValue: "")
            self.component(by: .accountNumber).set(uiProperty: .isBlockedAccountFillTextColor(getAccountStatusColor(with: account.status?.statusCode, isCheckedValue: true)))
            return true
        case self.component(by: .accountCurrency):
            component.setValue(newValue: value?.id)
            let dispatchGroup = DispatchGroup()
            var isSuccess = true
            var errorMessage: String?
            
            if let currency = value?.title {
                dispatchGroup.enter()
                loadThresholdAmount(forCurrency: currency) { success, message in
                    if !success {
                        isSuccess = false
                    }
                    errorMessage = message
                    dispatchGroup.leave()
                }
                
                dispatchGroup.enter()
                loadFeeTypes(currency: currency, onCompletion: { success, message in
                    if !success {
                        isSuccess = false
                    }
                    errorMessage = message
                    dispatchGroup.leave()
                })
                self.component(by: .commissionType).setValue(newValue: "")
                self.component(by: .commissionTypeName).setValue(newValue: "")
                
                // For latin validation set empty values
                let components: [InternationalTransferComponent] = [.city, .address, .receiverName, .additionalInfo]
                components.forEach { component in
                    self.component(by: component).setValue(newValue: "")
                    self.component(by: component).errorDescription = nil
                }
                
                self.component(by: .accountCurrency).setValue(newValue: value?.id)
                updateUsdAmount()
            }
            if let account = getAccountMatchOfDepositRUB(currency: value?.id)  {
                dispatchGroup.enter()
                loadPayDays(onCompletion: { success, message in
                    if !success {
                        isSuccess = false
                    }
                    errorMessage = message
                    dispatchGroup.leave()
                })
                self.component(by: .accountNumber).setValue(newValue: account.number)
                self.component(by: .accountNumber).set(uiProperty: .isBlockedAccountFillTextColor(getAccountStatusColor(with: account.status?.statusCode, isCheckedValue: true)))
                
                let amountFormatter = AmountFormatter()
                self.component(by: .accountNumber).description = amountFormatter.string(for: account.plannedBalance ?? 0.0)
                let currencyIsRUB = (account.currency == Constants.Сurrency.RUB)
                self.component(by: .VOCode).isVisible = currencyIsRUB
                self.component(by: .kpp).isVisible = currencyIsRUB
            }
            
            dispatchGroup.notify(queue: .main) {
                completion?(isSuccess, errorMessage)
            }
            
            let isTransliterated = value?.id == Constants.Сurrency.RUB
            self.component(by: .transliterate).isVisible = isTransliterated
            self.component(by: .transliterate).setValue(newValue: isTransliterated)
            if value?.id == Constants.Сurrency.RUB {
                self.component(by: .commissionType).set(uiProperty: .isUserInteractionEnabled(false))
                self.component(by: .commissionType).setValue(newValue: self.sourceData?.feeTypes?.filter({ $0.code == "OUR" }).first?.code)
                self.component(by: .commissionTypeName).setValue(newValue: sourceData?.feeTypes?.first?.label)
            }
            [self.component(by: .agentBankBik), self.component(by: .agentBankName), self.component(by: .agentCorrespondentAccount)].forEach { $0.isVisible = !isTransliterated }
            return true
        case self.component(by: .receiverName):
            let receiver = sourceData?.counterparties?.first(where: { $0.counterparty?.bin == value?.description })
            self.component(by: .iin).setValue(newValue: value?.description)
            onChange(receiver: receiver)
        case self.component(by: .iin):
            let receiver = sourceData?.counterparties?.first(where: { $0.counterparty?.bin == value?.id })
            self.component(by: .receiverName).setValue(newValue: value?.description)
            onChange(receiver: receiver)
        case self.component(by: .commissionAccount):
            component.description = value?.description
            guard let selectedAccount = sourceData?.feeAccounts?.first(where: { $0.number == value?.title }) else { return false }
            self.component(by: .commissionAccount).set(uiProperty: .isBlockedAccountFillTextColor(getAccountStatusColor(with: selectedAccount.status?.statusCode, isCheckedValue: true)))
        case self.component(by: .kbe):
            if let beneficiaryResidencyCodeString = value?.title,
                let beneficiaryResidencyCode = Int(beneficiaryResidencyCodeString),
                let customerResidencyCodeString = sourceData?.customerView?.residencyCode,
                let customerResidencyCode = Int(customerResidencyCodeString),
                let amountString = self.component(by: .amount).value,
                let amount = Double(amountString) {
                updateVisabilityOfAgreementComponents(amount: amount, customerResidencyCode: customerResidencyCode, beneficiaryResidencyCode: beneficiaryResidencyCode)
            } else {
                hideAgreementComponents()
            }
        case self.component(by: .VOCode):
            VOCode = component.value
            self.component(by: .paymentPurpose).setValue(newValue: alterPaymentPurposeField())
        case self.component(by: .contractNumber):
            guard let currencyContract = currencyContracts?.first(where: { $0.contractNumber == component.value })
                else { break }
            
            contractNumber = component.value
            self.component(by: .contractDate).setValue(newValue: currencyContract.contractDate)
            contractDate = currencyContract.contractDate
            self.component(by: .contractConsideredNumber).setValue(newValue:
                currencyContract.conContractNumber)
            contractConsideredNumber = currencyContract.conContractNumber
            self.component(by: .contractConsideredDate).setValue(newValue: currencyContract.conContractNumberDate)
            contractConsideredDate = currencyContract.conContractNumberDate
            self.component(by: .paymentPurpose).setValue(newValue: alterPaymentPurposeField())
        default:
            break
        }
        component.setValue(newValue: value?.id)
        return false
    }
    
    private func onChange(receiver: ForeignContragent?) {
        self.component(by: .countryCode).setValue(newValue: receiver?.counterparty?.countryTwoLetterCode)
        self.component(by: .country).setValue(newValue: receiver?.counterparty?.countryName)
        self.component(by: .country).isVisible = true
        self.component(by: .kbe).setValue(newValue: receiver?.counterparty?.beneficiaryCode)
        let kbeName = sourceData?.KBE?.first { $0.code == receiver?.counterparty?.beneficiaryCode }?.label
        self.component(by: .descriptionKbe).setValue(newValue: kbeName)
        self.component(by: .city).setValue(newValue: receiver?.counterparty?.city)
        self.component(by: .address).setValue(newValue: receiver?.counterparty?.address)
        self.component(by: .kpp).setValue(newValue: receiver?.counterparty?.kpp)
        if let account = receiver?.accounts?.first {
            self.component(by: .receiverAccount).setValue(newValue: account.iban)
            self.component(by: .receiverBankBik).setValue(newValue: account.bankCode)
            if let bankName = account.bankName {
                self.component(by: .receiverBankName).setValue(newValue: bankName)
                self.component(by: .receiverBankName).isVisible = true
            }
            self.component(by: .receiverBankCountryCode).setValue(newValue: account.bankCountryTwoLetterCode)
            self.component(by: .receiverBankCountry).setValue(newValue: account.bankCountryName)
            self.component(by: .receiverBankCity).setValue(newValue: account.bankCity)
            self.component(by: .receiverBankAddress).setValue(newValue: account.bankAddress)
            self.component(by: .receiverCorrespondentAccount).setValue(newValue: account.corrBankAccount)
            self.component(by: .agentCorrespondentAccount).setValue(newValue: account.agentCorrBankAcc)
            self.component(by: .agentBankBik).setValue(newValue: account.agentBankCode)
            self.component(by: .agentBankName).setValue(newValue: account.agentBankName)
        }
    }
    
    private func checkKvoByKnp() {
        let knpCode: String? = component(by: .knp).value
        let kvoKnpMatch: String? = getKnpMathOfKvo()
        
        if (knpCode != kvoKnpMatch) {
            component(by: .kvo).setValue(newValue: nil as String?)
        }
    }
    
    private func getKnpMathOfKvo() -> String? {
        return getKvoList()?.first(where: { (  kvo) -> Bool in
            return kvo.code == component(by: .kvo).value
        })?.knpMatch
    }
    
    private func getKvoList() -> [KVO]? {
        guard let knpCode = component(by: .knp).value else {
            return nil
        }
        return sourceData?.kvo?.filter { [unowned self] (kvo) in
            return self.isKnp(code: knpCode, include: kvo.knpMatch) &&
                !self.isKnp(code: knpCode, include: kvo.knpExclude, false)
        }
    }
    
    func isKnp(code knpCode: String, include kvoCodes: String?, _ defailtReturn: Bool = true) -> Bool {
        guard let kvoCodes = kvoCodes else { return defailtReturn }
        for kvoCode in kvoCodes.split(separator: ",") {
            guard knpCode.count == kvoCode.count else { continue }
            let code = kvoCode.replacingOccurrences(of: "*", with: "")
            if knpCode.starts(with: code) {
                return true
            }
        }
        return false
    }
    
    private func isBankBinInBankBikTransactionLimits() -> Bool {
        guard let bankBikTransactionLimits = bankBikTransactionLimits else {
            return false
        }
        return bankBikTransactionLimits.contains(component(by: .receiverBankBik).value ?? "")
    }
    
    private func getAccountMatchOfDepositRUB(currency: String?) -> ForeignAccountView? {
        guard let accountFromDepositRUB = accountFromDepositRUB, currency == Constants.Сurrency.RUB else { return sourceData?.foreignAccountViews?.first(where: { $0.currency == currency })}
        return sourceData?.foreignAccountViews?.first(where: { $0.number == accountFromDepositRUB })
    }
    
    private func alterPaymentPurposeField() -> String {
        guard self.component(by: .accountCurrency).value != nil else {
            return ""
        }
        
        var paymentPurpose = ""
        if let VOCode = VOCode {
            paymentPurpose = "'(VO\(VOCode))' "
        }
        if let contractNumber = contractNumber {
            paymentPurpose += "Кнтр \(contractNumber) "
        }
        if let contractDate = contractDate {
            paymentPurpose += "ДТ\(contractDate) "
        }
        if let contractConsideredNumber = contractConsideredNumber {
            paymentPurpose += "УНК\(contractConsideredNumber) "
        }
        if let contractConsideredDate = contractConsideredDate {
            paymentPurpose += "ДТ\(contractConsideredDate) "
        }
        if let invoiceNumber = invoiceNumber,
           !invoiceNumber.isEmpty {
            paymentPurpose += "ИНВ\(invoiceNumber) "
        } else {
            paymentPurpose = paymentPurpose.replacingOccurrences(of: "ИНВ", with: "")
        }
        if let paymentPurposeText = paymentPurposeText {
            paymentPurpose += paymentPurposeText
        }
        return paymentPurpose
    }
    
    func isValid(components: [OperationComponent]) -> Bool {
        var result: Bool = true
        for component in components {
            switch component {
            case self.component(by: .contractNumber):
                guard let sumString = self.component(by: .amount).value, let  sum = Double(sumString), let residencyCode = sourceData?.customerView?.residencyCode, let code =  Int(residencyCode), let limit = self.thresholdAmount else { break }
                if sum > limit && code >= 11 && code <= 18 &&
                    (component.value == "" || component.value == nil) {
                    component.errorDescription = "Обязательное поле!"
                    result = false
                } else {
                    component.errorDescription = nil
                }
            case self.component(by: .intlAddress):
                if self.component(by: .accountCurrency).value != Constants.Сurrency.RUB &&
                    (component.value == "" || component.value == nil) {
                    component.errorDescription = "Обязательное поле!"
                    result = false
                } else {
                    component.errorDescription = nil
                }
            case self.component(by: .receiverCorrespondentAccount):
                if self.component(by: .accountCurrency).value == Constants.Сurrency.RUB &&
                    component.value?.isEmpty != false {
                    component.errorDescription = "Обязательное поле!"
                    result = false
                } else {
                    component.errorDescription = nil
                }
            case self.component(by: .iin), self.component(by: .VOCode):
                if self.component(by: .accountCurrency).value == Constants.Сurrency.RUB &&
                    (component.value == "" || component.value == nil) {
                    component.errorDescription = "Обязательное поле!"
                    result = false
                } else {
                    component.errorDescription = nil
                }
            case self.component(by: .city), self.component(by: .address), self.component(by: .receiverName), self.component(by: .additionalInfo):
                if let text = component.value, !text.isEmpty {
                    if !isValid(nil, typedText: text, for: component) {
                        return false
                    }
                }
            case self.component(by: .kpp):
                let isRequired = kbeConstants.contains(where: { $0.trim().uppercased() == self.component(by: .kbe).value?.trim().uppercased() }) == true
                if self.component(by: .accountCurrency).value == Constants.Сurrency.RUB &&
                    (component.value == "" || component.value == nil), isRequired {
                    component.errorDescription = "Обязательное поле!"
                    result = false
                } else {
                    component.errorDescription = nil
                }
            case self.component(by: .kvo):
                let isRequired = (isBankBinInBankBikTransactionLimits() && isMembersHasNonresident())
                || ((currencyOperationLimit ?? 0 <= usdAmount ?? 0) && isMembersHasNonresident())
                if (isRequired && component.value == nil) {
                    component.errorDescription = "Обязательное поле!"
                    result = false
                } else {
                    component.errorDescription = nil
                }
            default:
                break
            }
            guard let constraints = component.constraints else { continue }
            if let error = Validator.validatingError(text: component.value, constraint: constraints) {
                component.errorDescription = error
                result = false
            }
        }
        return result
    }
    
    var documentActionDataArray: [DocumentActionData]? = nil
    
    var jsonParameters: [String: Any] {
        if let json = transferToSend?.toJSON() {
            return json
        }
        
        return [:]
    }
    
    var componentsAreValid: Bool {
        return isValid(components: components)
    }
    
    func textfieldValueChangedWithLoaded(_ value: String?, component: OperationComponent, completion: ((_ success: Bool, _ errorMessage: String?) -> Void)?) -> Bool {
        component.setValue(newValue: value)
        changeValueDependencies(component: component, to: value?.isEmpty == false)
        
        switch component {
        case self.component(by: .documentNumber):
            guard let value = value else { break }
            let validateContext = ValidateDocumentNumberContext(number: value, documentType: Constants.DocumentType.internationTransfer)
            validateContext.load(isSuccsess: { (response) in
                if let number = response as? String, number != "ok" {
                    component.errorDescription = "Предлагаемый порядковый номер \(number)"
                    completion?(true, nil)
                }
            })
        case self.component(by: .kbe):
            if let beneficiaryResidencyCodeString = value,
                let beneficiaryResidencyCode = Int(beneficiaryResidencyCodeString),
                let customerResidencyCodeString = sourceData?.customerView?.residencyCode,
                let customerResidencyCode = Int(customerResidencyCodeString),
                let amountString = self.component(by: .amount).value,
                let amount = Double(amountString) {
                updateVisabilityOfAgreementComponents(amount: amount, customerResidencyCode: customerResidencyCode, beneficiaryResidencyCode: beneficiaryResidencyCode)
            } else {
                hideAgreementComponents()
            }
        case self.component(by: .contractDate):
            contractDate = component.value
            self.component(by: .paymentPurpose).setValue(newValue: alterPaymentPurposeField())
        case self.component(by: .contractConsideredDate):
            contractConsideredDate = component.value
            self.component(by: .paymentPurpose).setValue(newValue: alterPaymentPurposeField())
        case self.component(by: .contractConsideredNumber):
            contractConsideredNumber = component.value
            self.component(by: .paymentPurpose).setValue(newValue: alterPaymentPurposeField())
        case self.component(by: .invoice):
            invoiceNumber = component.value
            self.component(by: .paymentPurpose).setValue(newValue: alterPaymentPurposeField())
        case self.component(by: .paymentPurposeInfo):
            paymentPurposeText = component.value
            self.component(by: .paymentPurpose).setValue(newValue: alterPaymentPurposeField())
        case self.component(by: .receiverName):
            let receiver = sourceData?.counterparties?.first(where: { $0.counterparty?.bin == value })
            self.component(by: .iin).setValue(newValue: receiver?.counterparty?.bin)
            onChange(receiver: receiver)
        case self.component(by: .iin):
            let receiver = sourceData?.counterparties?.first(where: { $0.counterparty?.bin == value })
            self.component(by: .receiverName).setValue(newValue: receiver?.counterparty?.internationalName)
            onChange(receiver: receiver)
        default:
            break
        }
        return false
    }
    
    func amountFieldValueChangeWithLoaded(_ value: String?, component: OperationComponent, completion: Completion?) -> Bool {
        guard let amountString = value else {
            component.setValue(newValue: "")
            updateUsdAmount()
            hideAgreementComponents()
            changeValueDependencies(component: component, to: false)
            return false
        }
        component.setValue(newValue: amountString)
        updateUsdAmount()
        changeValueDependencies(component: component, to: true)
        component.errorDescription = nil
        if let beneficiaryResidencyCodeString = self.component(by: .kbe).value,
           let beneficiaryResidencyCode = Int(beneficiaryResidencyCodeString),
           let customerResidencyCodeString = sourceData?.customerView?.residencyCode,
           let customerResidencyCode = Int(customerResidencyCodeString),
           let amount = Sum(amountString.trim()) {
            updateVisabilityOfAgreementComponents(amount: amount, customerResidencyCode: customerResidencyCode, beneficiaryResidencyCode: beneficiaryResidencyCode)
        } else {
            hideAgreementComponents()
        }
        
        return false
    }
    
    private func updateUsdAmount() {
        guard let amountString = self.component(by: .amount).value,
            let currency = component(by: .accountCurrency).value else {
                self.usdAmount = nil
                return
        }

        Loader.shared.show()
        convertAmountToUSD(Double(amountString), currency) { [weak self] (usdAmount) in
            Loader.shared.hide()
            self?.usdAmount = usdAmount
        }
    }
    
    //FIXME: NEED TO BE CONVERTED
    private func getAmountInUSD() -> Double? {
        let amountString: String? = component(by: .amount).value
        return amountString?.returnDouble()
    }
    
    private func isMembersHasNonresident() -> Bool {
        var isSenderNonresident = false
        var isRecipientNonresident = false
        let nonresidentsCodes = ["21", "22", "23", "24", "25", "26", "27", "28", "29"]
        
        if let senderKbeCode = sourceData?.customerView?.residencyCode {
            isSenderNonresident = nonresidentsCodes.contains(senderKbeCode)
        }
        
        if let recipientKbeCode = component(by: .kbe).value {
            isRecipientNonresident = nonresidentsCodes.contains(recipientKbeCode)
        }
    
        return isSenderNonresident || isRecipientNonresident
    }
    
    // MARK: - Textfield validation for accountCurrency except RUB
    
    func isValid(_ value: String?, typedText text: String, for component: OperationComponent) -> Bool {
        guard isAllowed(text: text) else {
            component.errorDescription = "Ввод недопустимых символов!"
            return false
        }
        
        if let currencyValue = self.component(by: .accountCurrency).value,
            currencyValue != Constants.Сurrency.RUB && !text.isEmpty {
                let components: [InternationalTransferComponent] = [.contractNumber, .city, .address, .receiverName, .invoice, .additionalInfo]
                if components.map(self.component).contains(component) {
                    component.errorDescription = !text.isLatin() ? "Только латинские символы!" : nil
                    return text.isLatin()
                }
        }
        
        if let value = self.component(by: .number8).value {
             self.component(by: .number8).errorDescription = value.count >= 15 ? "Введите до 15 символов!" : nil
            return true
        }
        
        component.errorDescription = nil
        return true
    }
    
    private func isAllowed(text: String) -> Bool {
        let disallowedCharacterSet = CharacterSet(charactersIn: "№@\"^~;!\\{}[]<>|%#$&*ҺӘәІіҢңҒғҮүҰұҚқӨөҺһ")
        return text.rangeOfCharacter(from: disallowedCharacterSet) == nil
    }
    
    private func updateVisabilityOfAgreementComponents(amount: Double, customerResidencyCode: Int, beneficiaryResidencyCode: Int) {
        if let thresholdAmount = thresholdAmount {
            if amount < thresholdAmount {
                if 11...18 ~= customerResidencyCode &&
                   21...29 ~= beneficiaryResidencyCode {
                    self.component(by: .noUnc).isVisible = true
                } else {
                    self.component(by: .noUnc).isVisible = false
                }
                self.component(by: .noTerror).isVisible = false
                self.component(by: .isPermitGiveInformation).isVisible = false
                return
            } else {
                if 11...19 ~= beneficiaryResidencyCode ||
                   21...29 ~= beneficiaryResidencyCode {
                    if customerResidencyCode == 19 {
                        self.component(by: .noUnc).isVisible = true
                        self.component(by: .noTerror).isVisible = true
                        self.component(by: .isPermitGiveInformation).isVisible = true
                    } else if customerResidencyCode == 29 {
                        self.component(by: .noUnc).isVisible = false
                        self.component(by: .noTerror).isVisible = true
                        self.component(by: .isPermitGiveInformation).isVisible = true
                    }
                    return
                }
            }
        }
        
        hideAgreementComponents()
    }
    
    private func hideAgreementComponents() {
        self.component(by: .noUnc).isVisible = false
        self.component(by: .noTerror).isVisible = false
        self.component(by: .isPermitGiveInformation).isVisible = false
    }
}

enum InternationalTransferComponent: String {
    case template
    case documentNumber
    case accountNumber
    case accountCurrency
    case transliterate
    case intlAddress
    case receiverName
    case iin
    case kbe
    case descriptionKbe
    case kpp
    case countryCode
    case country
    case city
    case address
    case receiverAccount
    case receiverBankBik
    case receiverBankName
    case receiverCorrespondentAccount
    case receiverBankCountryCode
    case receiverBankCountry
    case receiverBankCity
    case receiverBankAddress
    case agentBankBik
    case agentBankName
    case agentCorrespondentAccount
    case agentBankCountryCode
    case agentBankCountry
    case agentBankCity
    case agentBankAddress
    case valueDate
    case amount
    case VOCode
    case contractNumber
    case contractDate
    case contractConsideredNumber
    case contractConsideredDate
    case invoice
    case invoiceDate
    case commissionType
    case commissionTypeName
    case commissionAccount
    case knp
    case descriptionKnp
    case kvo
    case descriptionKvo
    case paymentPurpose
    case additionalInfo
    case bankResponse
    case noTerror
    case noUnc
    case isPermitGiveInformation
    case director
    case accountant
    case paymentPurposeInfo
    case codeTypeOperation
    case number4
    case number5
    case number6
    case number7
    case number8
    case number9
    case number10
}
