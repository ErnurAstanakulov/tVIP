
//
//  DomesticTransferView.swift
//  DigitalBank
//
//  Created by Алем Утемисов on 07.05.2018.
//  Copyright © 2018 iosDeveloper. All rights reserved.
//

import Foundation

class DomesticTransferViewModel: OperationViewModel {
    
    var currencyOperationLimit: Double?
    var usdAmount: Double?
    var bankBikTransactionLimits: [String]?
    
    weak var viewController: OperationsTableViewControllerProtocol?
    var components: [OperationComponent] = []
    var documentId: Int?
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
    
    var invoiceId: Int?
    var isForChildOrganization = false
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
    var KbeToKbkConst: [String]?
    var biksToKbkConst: [String]?
    var kbkForAdmFines: [String]?
    private var childOrganizationId: Int?
    var payDays: [String]?
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
            } else if initialDocument?.accountant == nil && accountantsCount == 0 {
                component(by: .accountant).setValue(newValue: "Не предусмотрен")
            }
            
            if initialDocument?.benefBankCode == nil,
                let accountNumber = initialDocument?.benefAccount,
                let localBank = getLocalBankFrom(accountNumber: accountNumber) {
                component(by: .bankBik).setValue(newValue: localBank.bankBik)
                if let bik = component(by: .bankBik).value {
                    self.loadPayDays(bik: bik) { [weak self] (isSuccess, error) in
                        if !isSuccess {
                            self?.viewController?.presentErrorController(title: "Ошибка", message: contentErrorMessage)
                            return
                        }
                    }
                }
            }
            if initialDocument?.bankName == nil,
                let accountNumber = initialDocument?.benefAccount,
                let localBank = getLocalBankFrom(accountNumber: accountNumber) {
                component(by: .bankName).setValue(newValue: localBank.bankName)
                component(by: .bankName).isVisible = true
            }
            if let isUrgent = initialDocument?.priority {
                component(by: .valueDate).set(uiProperty: .isUserInteractionEnabled(!isUrgent))
            }
            if let isLoanPay = initialDocument?.isLoanPay {
                component(by: .isLoanPay).setValue(newValue: isLoanPay)
            } else {
                component(by: .isLoanPay).setValue(newValue: false)
            }
            if let payDays = sourceData?.payDays?.dates {
                if payDays.count == 0 {
                    component(by: .valueDate).set(uiProperty: .isUserInteractionEnabled(false))
                } else {
                    component(by: .valueDate).set(uiProperty: .isUserInteractionEnabled(true))
                }
            }
            if let KbeToKbk = sourceData?.KbeToKbkConst {
                KbeToKbkConst = KbeToKbk
            }
            if let subsidiaryOrganization = initialDocument?.isSubsidiaryOrganization {
                component(by: .forChildOrganization).setValue(newValue: subsidiaryOrganization)
                if subsidiaryOrganization {
                    component(by: .forChildOrganization).setValue(newValue: true)
                    component(by: .listOfChildrenOrganisations).isVisible = true
                    component(by: .listOfChildrenOrganisations).setValue(newValue: initialDocument?.subsidiaryCustomerShortData?.name != nil ? initialDocument?.subsidiaryCustomerShortData?.name! : "")
                    component(by: .bin).isVisible = true
                    component(by: .bin).setValue(newValue: initialDocument?.subsidiaryCustomerShortData?.taxCode != nil ? initialDocument?.subsidiaryCustomerShortData?.taxCode! : "")
                    component(by: .childOrganizationCode).isVisible = true
                    component(by: .childOrganizationCode).setValue(newValue: initialDocument?.subsidiaryCustomerShortData?.beneficiaryCode != nil ? initialDocument?.subsidiaryCustomerShortData?.beneficiaryCode! : "")
                } else {
                    component(by: .forChildOrganization).setValue(newValue: false)
                }
            }
        }
    }
    
    var initialDocument: DomesticTransfer? {
        didSet {
            component(by: .documentNumber).setValue(newValue: initialDocument?.number)
            
            let amountFormatter = AmountFormatter()
            component(by: .accountNumber).setValue(newValue: initialDocument?.account?.number)
            component(by: .accountNumber).description = amountFormatter.string(for: initialDocument?.account?.plannedBalance ?? "") ?? "0"
            component(by: .valueDate).setValue(newValue: initialDocument?.valueDate ?? "")
            component(by: .template).setValue(newValue: initialDocument?.templateName)
            component(by: .receiverName).setValue(newValue: initialDocument?.benefName)
            component(by: .iin).setValue(newValue: initialDocument?.benefTaxCode)
            component(by: .kbe).setValue(newValue: initialDocument?.benefResidencyCode)
            component(by: .receiverAccount).setValue(newValue: initialDocument?.benefAccount)
            component(by: .bankBik).setValue(newValue: initialDocument?.benefBankCode)
            if let bik = component(by: .bankBik).value {
                self.loadPayDays(bik: bik) { [weak self] (isSuccess, error) in
                    if !isSuccess {
                        self?.viewController?.presentErrorController(title: "Ошибка", message: contentErrorMessage)
                        return
                    }
                }
            }
            if let bankName = initialDocument?.bankName {
                component(by: .bankName).setValue(newValue: bankName)
                component(by: .bankName).isVisible = true
            }
            component(by: .urgentPayment).setValue(newValue: initialDocument?.priority)
            if let isLoanPay = initialDocument?.isLoanPay {
                component(by: .isLoanPay).setValue(newValue: isLoanPay)
            } else {
                component(by: .isLoanPay).setValue(newValue: false)
            }
            if let vat = initialDocument?.vat {
                component(by: .nds).setValue(newValue: true)
                component(by: .ndsAmount).setValue(newValue: String(vat).splitedAmount())
                component(by: .ndsAmount).isVisible = true
            }
            component(by: .amount).setValue(newValue: String(format: "%.2f", initialDocument?.amount ?? 0.0).splittedAmount)
            component(by: .paymentPurpose).setValue(newValue: initialDocument?.purpose)
            component(by: .paymentPurposeInfo).setValue(newValue: initialDocument?.paymentPurposeText)
            component(by: .knp).setValue(newValue: initialDocument?.purposeCode)
            if let knp = initialDocument?.purposeCode {
                let knpCharacters = Array(knp)
                if let firstCharacter = knpCharacters.first, let KbeToKbk = KbeToKbkConst {
                    if getFirstCharacters(from: KbeToKbk).contains(firstCharacter) {
                        component(by: .kbk).setValue(newValue: initialDocument?.purposeCode)
                        component(by: .descriptionKbk).setValue(newValue: initialDocument?.purposeCodeLabel)
                        
                        component(by: .kbk).isVisible = true
                        component(by: .descriptionKbk).isVisible = true
                        
                        if let admFines = initialDocument?.numberOfAdministrativeAffairs {
                            component(by: .admFines).isVisible = true
                            component(by: .admFines).setValue(newValue: admFines)
                        }
                    } else {
                        component(by: .kbk).isVisible = false
                        component(by: .descriptionKbk).isVisible = false
                    }
                    
                } else {
                    component(by: .kbk).isVisible = false
                    component(by: .descriptionKbk).isVisible = false
                }
            }
            component(by: .kvo).setValue(newValue: initialDocument?.kvo)
            if let kvoLabel = initialDocument?.kvoLabel {
                component(by: .descriptionKvo).setValue(newValue: kvoLabel)
                component(by: .descriptionKvo).isVisible = true
            }
            if let purposeLabel = initialDocument?.purposeCodeLabel {
                component(by: .descriptionKnp).setValue(newValue: purposeLabel)
                component(by: .descriptionKnp).isVisible = true
            }
            if let bankResponse = initialDocument?.bankResponse {
                component(by: .bankResponse).setValue(newValue: bankResponse)
                component(by: .bankResponse).isVisible = true
            }
            if let subsidiaryOrganization = initialDocument?.isSubsidiaryOrganization {
                component(by: .forChildOrganization).setValue(newValue: subsidiaryOrganization)
                if subsidiaryOrganization {
                    component(by: .forChildOrganization).setValue(newValue: true)
                    component(by: .listOfChildrenOrganisations).isVisible = true
                    component(by: .listOfChildrenOrganisations).setValue(newValue: initialDocument?.subsidiaryCustomerShortData?.name != nil ? initialDocument?.subsidiaryCustomerShortData?.name! : "")
                    component(by: .bin).isVisible = true
                    component(by: .bin).setValue(newValue: initialDocument?.subsidiaryCustomerShortData?.taxCode != nil ? initialDocument?.subsidiaryCustomerShortData?.taxCode! : "")
                    component(by: .childOrganizationCode).isVisible = true
                    component(by: .childOrganizationCode).setValue(newValue: initialDocument?.subsidiaryCustomerShortData?.beneficiaryCode != nil ? initialDocument?.subsidiaryCustomerShortData?.beneficiaryCode! : "")
                } else {
                    component(by: .forChildOrganization).setValue(newValue: false)
                }
            }
            component(by: .director).setValue(newValue: initialDocument?.director?.fullName)
            component(by: .accountant).setValue(newValue: initialDocument?.accountant?.fullName)
            component(by: .isNotLinkTerrorism).setValue(newValue: initialDocument?.isNotLinkTerrorism)
            component(by: .isNotNeedUnc).setValue(newValue: initialDocument?.isNotNeedUnc)
            component(by: .isPermitGiveInformation).setValue(newValue: initialDocument?.isPermitGiveInformation)
        }
    }
    
    var domesticTransferToSend: DomesticTransferToSend? {
        let domesticTransferToSend = DomesticTransferToSend()
        let accountNumber = component(by: DomesticTransferComponent.accountNumber).value
        domesticTransferToSend.templateName = component(by: .template).value
        domesticTransferToSend.account = sourceData?.accountViews?.first(where: { $0.number == accountNumber })
        domesticTransferToSend.amount = component(by: .amount).value?.trim()
        domesticTransferToSend.number = component(by: .documentNumber).value?.trim()
        domesticTransferToSend.valueDate = component(by: .valueDate).value
        domesticTransferToSend.domesticTransferType = "PaymentOrder"
        domesticTransferToSend.isSubsidiaryOrganization = isForChildOrganization
        if isForChildOrganization {
            guard let childOrganizationId = childOrganizationId else {
                return nil
            }
            domesticTransferToSend.subsidiaryOrganizationId = childOrganizationId
        }
        domesticTransferToSend.purpose = component(by: .paymentPurpose).value
        domesticTransferToSend.purposeText = component(by: .paymentPurposeInfo).value
        domesticTransferToSend.priority = component(by: .urgentPayment).getValue() ?? domesticTransferToSend.priority
        domesticTransferToSend.info = component(by: .additionalInfo).value
        domesticTransferToSend.purposeCode = component(by: .knp).value
        domesticTransferToSend.kvo = component(by: .kvo).value
        domesticTransferToSend.isTemplate = initialDocument?.isTemplate
        domesticTransferToSend.benefName = component(by: .receiverName).value
        domesticTransferToSend.benefBankCode = component(by: .bankBik).value
        domesticTransferToSend.benefAccount = component(by: .receiverAccount).value
        domesticTransferToSend.benefResidencyCode = component(by: .kbe).value
        domesticTransferToSend.benefTaxCode = component(by: .iin).value
        domesticTransferToSend.vat = component(by: .ndsAmount).value?.trim()
        domesticTransferToSend.budgetCode = component(by: .kbk).value
        domesticTransferToSend.numberOfAdministrativeAffairs = component(by: .admFines).value
        domesticTransferToSend.vinCode = component(by: .vinCode).value
        domesticTransferToSend.director = sourceData?.directors.first { $0.fullName == self.component(by: .director).value }
        domesticTransferToSend.accountant = sourceData?.accountants.first { $0.fullName == self.component(by: .accountant).value }
        domesticTransferToSend.invoiceId = invoiceId
        domesticTransferToSend.isNotNeedUnc = component(by: .isNotNeedUnc).getValue()
        domesticTransferToSend.isNotLinkTerrorism = component(by: .isNotLinkTerrorism).getValue()
        domesticTransferToSend.isPermitGiveInformation = component(by: .isPermitGiveInformation).getValue()
        if let isLoanPay: Bool = component(by: .isLoanPay).getValue() {
            domesticTransferToSend.isLoanPay = isLoanPay ? true : false
        } else {
            domesticTransferToSend.isLoanPay = false
        }
        
        return domesticTransferToSend
    }
    
    var ndsAmountText = ""
    var vins: [String]?
    
    required init() {
        setupComponents()
    }
    
    func dataSource(for component: OperationComponent) -> [OptionDataSource]? {
        guard let componenType = DomesticTransferComponent(rawValue: component.name) else { return nil }
        switch componenType {
        case .accountNumber:
            let amountFormatter = AmountFormatter()
            return sourceData?.accountViews?.compactMap {
                let balance = amountFormatter.string(for: $0.plannedBalance ?? 0.0) ?? "0.00"
                return OptionDataSource(id: $0.number,
                                        title: $0.number,
                                        description: "\(balance) \($0.currency ?? "")",
                    color: getAccountStatusColor(with: $0.status?.statusCode,
                                                 isCheckedValue: false))
            }
        case .template:
            return sourceData?.templates?.compactMap { OptionDataSource(id: $0.id.description, title: $0.templateName) }
        case .valueDate:
            if payDays != nil {
                return payDays!.map { OptionDataSource(id: $0, title: $0) }
            }
            return nil
        case .paymentPurpose:
            return sourceData?.paymentPurposes?.compactMap { OptionDataSource(id: $0, title: $0) }
        case .receiverName:
            return sourceData?.counterparties?.compactMap {
                OptionDataSource.init(
                    id: $0.counterparty?.name,
                    title: $0.counterparty?.name,
                    description: $0.counterparty?.bin
                )
            }
        case .iin:
            return sourceData?.counterparties?.compactMap {
                OptionDataSource.init(
                    id: $0.counterparty?.bin,
                    title: $0.counterparty?.bin,
                    description: $0.counterparty?.name
                )
            }
        case .kbe:
            return sourceData?.KBE?.compactMap { OptionDataSource(id: $0.code, title: $0.code, description: $0.label) }
        case .receiverAccount:
            guard let counterpartyName = self.component(by: .receiverName).value,
                let counterParty = sourceData?.counterparties?.first(where: { $0.counterparty?.name == counterpartyName }) else { return nil }
            return counterParty.accounts?.compactMap { OptionDataSource(id: $0.iban, title: $0.iban) }
        case .bankBik:
            return sourceData?.localBanks?.compactMap {  OptionDataSource.init(id: $0.nationalBankBik, title: $0.nationalBankBik, description: $0.bankName)  }
        case .knp:
            return sourceData?.knp?.compactMap { OptionDataSource(id: $0.code, title: $0.code, description: $0.label) }
        case .kvo:
            return getKvoList()?.compactMap { OptionDataSource(id: $0.code, title: $0.code, description: $0.name) }
        case .kbk:
            return sourceData?.kbk?.compactMap { OptionDataSource(id: $0.code, title: $0.code, description: $0.label) }
        case .director:
            return sourceData?.directors.compactMap { OptionDataSource(id: $0.fullName, title: $0.fullName) }
        case .accountant:
            return sourceData?.accountants.compactMap { OptionDataSource(id: $0.fullName, title: $0.fullName) }
        case .listOfChildrenOrganisations:
            return sourceData?.subsidiaryCustomers?.compactMap { OptionDataSource(id: String($0.id), title: $0.name) }
        default:
            return nil
        }
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
    
    func component(by domesticComponent: DomesticTransferComponent) -> OperationComponent {
        return components.first(where: { $0.name == domesticComponent.rawValue })!
    }
    
    func amountFieldValueChangeWithLoaded(_ value: String?, component: OperationComponent, completion: ((Bool, String?) -> Void)?) -> Bool {
        guard let amountString = value else {
            component.setValue(newValue: "")
            updateUsdAmount()
            self.component(by: .ndsAmount).setValue(newValue: "")
            ndsAmountText = ""
            changeValueDependencies(component: component, to: false)
            return false
        }
        component.setValue(newValue: amountString)
        updateUsdAmount()
        changeValueDependencies(component: component, to: true)
        component.errorDescription = nil
        if self.component(by: .amount) == component && self.component(by: .nds).getValue() == true {
            requestVAT { (success, errorStr) in
                completion?(success, errorStr)
            }
            return true
        }
        
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
    
    func switchedWithLoaded(to: Bool, component: OperationComponent, completion: ((Bool, String?) -> Void)?) -> Bool {
        component.setValue(newValue: to)
        changeValueDependencies(component: component, to: to)
        component.errorDescription = nil
        
        // Update amount if vat indicator (nds) is on
        if self.component(by: .nds) == component, component.getValue() == true {
            if let amountValue = self.component(by: .amount).value, !amountValue.isEmpty {
                requestVAT { (success, errorStr) in
                    completion?(success, errorStr)
                }
                return true
            } else {
                ndsAmountText = " (в том числе с НДС 00.00 )"
                self.component(by: .paymentPurposeInfo).setValue(newValue: setPaymentPurposeInfoText())
            }
        } else if self.component(by: .nds) == component, component.getValue() == false {
            ndsAmountText = ""
            self.component(by: .paymentPurposeInfo).setValue(newValue: setPaymentPurposeInfoText())
            if self.component(by: .descriptionKnp).value != nil {
                self.component(by: .paymentPurpose).setValue(newValue: self.component(by: .descriptionKnp).value!)
            } else {
                self.component(by: .paymentPurpose).setValue(newValue: "")
            }
        }
        if self.component(by: .urgentPayment) == component {
            let canEditValueDate = to
            self.component(by: .valueDate).setValue(newValue: payDays?.first)
            self.component(by: .valueDate).set(uiProperty: .isUserInteractionEnabled(!canEditValueDate))
        }
        if self.component(by: .forChildOrganization) == component {
            if component.getValue() == true {
                self.component(by: .bin).isVisible = true
                self.component(by: .listOfChildrenOrganisations).isVisible = true
                self.component(by: .childOrganizationCode).isVisible = true
                isForChildOrganization = true
            } else {
                self.component(by: .bin).isVisible = false
                self.component(by: .listOfChildrenOrganisations).isVisible = false
                self.component(by: .childOrganizationCode).isVisible = false
                isForChildOrganization = false
            }
        }
        
        return false
    }
    
    func optionSelectedWithLoaded(_ value: OptionDataSource?, component: OperationComponent, completion: ((Bool, String?) -> Void)?) -> Bool {
        switch component {
        case self.component(by: .accountNumber):
            component.description = value?.description
            guard let selectedAccount = sourceData?.accountViews?.first(where: { $0.number == value?.title }) else { return false }
            component.set(uiProperty: .isBlockedAccountFillTextColor(getAccountStatusColor(with: selectedAccount.status?.statusCode, isCheckedValue: true)))
        case self.component(by: .receiverName):
            let company = sourceData?.counterparties?.first { $0.counterparty?.bin == value?.description }
            self.component(by: .iin).setValue(newValue: value?.description)
            self.onChange(company: company)
        case self.component(by: .iin):
            let company = sourceData?.counterparties?.first { $0.counterparty?.bin == value?.id }
            self.component(by: .receiverName).setValue(newValue: value?.description)
            self.onChange(company: company)
        case self.component(by: .receiverAccount):
            guard let accountNumber = value?.id else { break }
            let localBank = getLocalBankFrom(accountNumber: accountNumber)
            self.component(by: .bankBik).setValue(newValue: localBank?.bankBik)
            if let bik = self.component(by: .bankBik).value {
                self.loadPayDays(bik: bik) { [weak self] (isSuccess, error) in
                    if !isSuccess {
                        self?.viewController?.presentErrorController(title: "Ошибка", message: contentErrorMessage)
                        return
                    }
                }
            }
            self.component(by: .bankName).setValue(newValue: localBank?.bankName)
        case self.component(by: .bankBik):
            component.setValue(newValue: value?.id)
            self.component(by: .bankName).setValue(newValue: value?.description)
            if let bik = self.component(by: .bankBik).value, !bik.isEmpty {
                self.loadPayDays(bik: bik) { [weak self] (isSuccess, error) in
                    if !isSuccess {
                        self?.viewController?.presentErrorController(title: "Ошибка", message: contentErrorMessage)
                        return
                    }
                }
            } else {
                self.payDays = nil
            }
            self.component(by: .valueDate).setValue(newValue: "")
            self.component(by: .paymentPurposeInfo).setValue(newValue: setPaymentPurposeInfoText())
        case self.component(by: .kbk):
            self.component(by: .descriptionKbk).setValue(newValue: value?.description)
            if let value = component.value, let vin = vins {
                if vin.contains(value) {
                    self.component(by: .vinCode).isVisible = true
                } else {
                    self.component(by: .vinCode).isVisible = false
                }
            } else {
                self.component(by: .vinCode).isVisible = false
            }
            self.component(by: .paymentPurposeInfo).setValue(newValue: setPaymentPurposeInfoText())
        case self.component(by: .knp):
            self.component(by: .knp).setValue(newValue: value?.title)
            self.component(by: .descriptionKnp).setValue(newValue: value?.description)
            self.component(by: .paymentPurposeInfo).setValue(newValue: setPaymentPurposeInfoText())
            checkKnpByKbk(value?.title)
            checkKvoByKnp()
        case self.component(by: .kvo):
            self.component(by: .descriptionKvo).setValue(newValue: value?.description)
            self.component(by: .descriptionKvo).isVisible = !(value?.description ?? "").isEmpty
        case self.component(by: .kbk):
            let isDependency: Bool
            if let code = value?.id,
                let vinCode = sourceData?.kbkVin, vinCode.contains(code) {
                isDependency = true
            } else {
                isDependency = false
            }
            self.component(by: .descriptionKbk).isVisible = true
            self.component(by: .vinCode).isVisible = isDependency
            self.component(by: .descriptionKbk).setValue(newValue: value?.description)
            if let val = value?.title {
                let kbkpCharacters = Array(val)
                if let firstCharacter = kbkpCharacters.first, let admFines = kbkForAdmFines {
                    if getFirstCharacters(from: admFines).contains(firstCharacter) {
                        self.component(by: .admFines).isVisible = true
                    } else {
                        self.component(by: .admFines).isVisible = false
                    }
                } else {
                    self.component(by: .admFines).isVisible = false
                }
            }
            self.component(by: .paymentPurposeInfo).setValue(newValue: setPaymentPurposeInfoText())
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
        case self.component(by: .listOfChildrenOrganisations):
            if let selectedId = value?.id, let selectedOrganisation = sourceData?.subsidiaryCustomers?.first(where: { $0.id == Int(selectedId) }) {
                self.component(by: .bin).setValue(newValue: selectedOrganisation.taxCode)
                self.component(by: .childOrganizationCode).setValue(newValue: selectedOrganisation.beneficiaryCode)
                component.setValue(newValue: selectedOrganisation.name)
                childOrganizationId = selectedOrganisation.id
                return false
            }
        case self.component(by: .paymentPurpose):
            component.setValue(newValue: value?.id)
            self.component(by: .paymentPurposeInfo).setValue(newValue: setPaymentPurposeInfoText())
            return false
        case self.component(by: .template):
            guard let valueId = value?.id, let id = Int(valueId) else { break }
            component.setValue(newValue: id)
            requestTemplate(withId: id, onCompletion: completion)
            return true
        default:
            break
        }
        
        component.setValue(newValue: value?.id)
        return false
    }
    
    func onChange(company: CounterpartyList?) {
        self.component(by: .kbe).setValue(newValue: company?.counterparty?.beneficiaryCode)
        if let accountIban = company?.accounts?.first?.iban {
            self.component(by: .receiverAccount).setValue(newValue: accountIban)
            let bank = getLocalBankFrom(accountNumber: accountIban)
            self.component(by: .bankBik).setValue(newValue: bank?.nationalBankBik)
            if let bik = self.component(by: .bankBik).value {
                self.loadPayDays(bik: bik) { [weak self] (isSuccess, error) in
                    if !isSuccess {
                        self?.viewController?.presentErrorController(title: "Ошибка", message: contentErrorMessage)
                        return
                    }
                }
            }
            self.component(by: .bankName).setValue(newValue: bank?.bankName)
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
        return getKvoList()?.first(where: { (kvo) -> Bool in
            return kvo.code == component(by: .kvo).value
        })?.knpMatch
    }
    
    private func checkKnpByKbk(_ knp: String?) {
        if let knp = knp {
            let knpCharacters = Array(knp)
            if let firstCharacter = knpCharacters.first, let KbeToKbk = KbeToKbkConst {
                if getFirstCharacters(from: KbeToKbk).contains(firstCharacter) {
                    component(by: .kbk).isVisible = true
                    component(by: .descriptionKbk).isVisible = true
                } else {
                    component(by: .kbk).isVisible = false
                    component(by: .descriptionKbk).isVisible = false
                }
                
            } else {
                component(by: .kbk).isVisible = false
                component(by: .descriptionKbk).isVisible = false
            }
        }
    }
    
    func getFirstCharacters(from stringArray: [String]) -> [Character] {
        var letterArray = [Character]()
        for string in stringArray {
            let str = string.trimmingCharacters(in: .whitespaces)
            if let character = Array(str).first {
                letterArray.append(character)
            }
        }
        return letterArray
    }
    
    func isValid(components: [OperationComponent]) -> Bool {
        var result: Bool = true
        for component in components {
            component.errorDescription = nil
            if self.component(by: .kbk) == component && component.isVisible {
                if component.value?.isEmpty == true || component.value == nil {
                    component.errorDescription = "Обязательное поле!"
                    result = false
                }
            }
            if self.component(by: .listOfChildrenOrganisations) == component {
                if isForChildOrganization && component.value == nil {
                    component.errorDescription = "Обязательное поле!"
                    result = false
                }
            }
            if self.component(by: .kvo) == component {
                let isRequired = (isBankBinInBankBikTransactionLimits() && isMembersHasNonresident())
                    || ((currencyOperationLimit ?? 0 <= usdAmount ?? 0) && isMembersHasNonresident())
                if (isRequired && (component.value?.isEmpty == true || component.value == nil)) {
                    component.errorDescription = "Обязательное поле!"
                    result = false
                } else {
                    component.errorDescription = nil
                }
            }
            guard let constraints = component.constraints else { continue }
            if let error = Validator.validatingError(text: component.value, constraint: constraints) {
                component.errorDescription = error
                result = false
            }
        }
        return result
    }
    
    private func updateUsdAmount() {
        guard let amountString = self.component(by: .amount).value else {
            self.usdAmount = nil
            return
        }
        
        Loader.shared.show()
        convertAmountToUSD(Double(amountString), "KZT") { [weak self] (usdAmount) in
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
    
    func isValid(_ value: String?, typedText text: String, for component: OperationComponent) -> Bool {
        if self.component(by: .vinCode) == component {
            guard let value = value else { return true }
            if text.isEmpty {
                return true
            }
            guard isVinCodeValidation(text: value) else {
                component.errorDescription = "Ввод больше символов для VIN код!"
                return false
            }
            component.errorDescription = nil
            return true
        }
        return true
    }
    
    private func isVinCodeValidation(text: String) -> Bool {
        return text.count < 17 ? true : false
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
    
    func textfieldValueChangedWithLoaded(_ value: String?, component: OperationComponent, completion: ((Bool, String?) -> Void)?) -> Bool {
        component.setValue(newValue: value)
        changeValueDependencies(component: component, to: value?.isEmpty == false)
        component.errorDescription = nil
        
        switch component {
        case self.component(by: .receiverAccount):
            guard let value = value else { break }
            let localBank = getLocalBankFrom(accountNumber: value)
            self.component(by: .bankBik).setValue(newValue: localBank?.bankBik)
            if let bik = self.component(by: .bankBik).value {
                self.loadPayDays(bik: bik) { [weak self] (isSuccess, error) in
                    if !isSuccess {
                        self?.viewController?.presentErrorController(title: "Ошибка", message: contentErrorMessage)
                        return
                    }
                }
            }
            self.component(by: .bankName).setValue(newValue: localBank?.bankName)
        case self.component(by: .bankBik):
            component.setValue(newValue: value?.uppercased())
            let bankName = sourceData?.localBanks?.first(where: { $0.bankBik == value?.uppercased() })?.bankName
            self.component(by: .bankName).setValue(newValue: bankName)
            if let bik = self.component(by: .bankBik).value, !bik.isEmpty {
                self.loadPayDays(bik: bik) { [weak self] (isSuccess, error) in
                    if !isSuccess {
                        self?.viewController?.presentErrorController(title: "Ошибка", message: contentErrorMessage)
                        return
                    }
                }
            } else {
                self.payDays = nil
            }
            self.component(by: .valueDate).setValue(newValue: "")
            self.component(by: .paymentPurposeInfo).setValue(newValue: setPaymentPurposeInfoText())
        case self.component(by: .documentNumber):
            guard let value = value else { break }
            let validateContext = ValidateDocumentNumberContext(number: value, documentType: Constants.DocumentType.domesticTransfer)
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
        case self.component(by: .paymentPurpose),
             self.component(by: .vinCode),
             self.component(by: .admFines):
            self.component(by: .paymentPurposeInfo).setValue(newValue: setPaymentPurposeInfoText())
        case self.component(by: .receiverName):
            let company = sourceData?.counterparties?.first { $0.counterparty?.bin == value }
            self.component(by: .iin).setValue(newValue: company?.counterparty?.bin)
            self.onChange(company: company)
        case self.component(by: .iin):
            let company = sourceData?.counterparties?.first { $0.counterparty?.bin == value }
            self.component(by: .receiverName).setValue(newValue: company?.counterparty?.name)
            self.onChange(company: company)
        default:
            break
        }
        
        return false
    }
    
    func isValid(typedText text: String, for component: OperationComponent) -> Bool {
        if self.component(by: .admFines) == component {
            guard self.isAdmFinesInfoText(text: text) else {
                component.errorDescription = "Ввод больше символов чем надо!"
                return false
            }
        }
        return true
    }
    
    func setPaymentPurposeInfoText() -> String {
        var paymentPurposeText: String? = nil
        if let paymentPurposeValue = component(by: .paymentPurpose).value {
            paymentPurposeText = paymentPurposeValue
        }
        
        var vinText: String? = nil
        if let vinCode = component(by: .vinCode).value,
            component(by: .vinCode).isVisible {
            vinText = "VIN \(vinCode)/V"
        }
        
        var admFinesText: String? = nil
        if let admFinesValue = component(by: .admFines).value,
            component(by: .admFines).isVisible {
            admFinesText = "ADM \(admFinesValue)/A"
        }
        
        var knpDescriptionText: String? = nil
        if let knpDescriptionValue = component(by: .descriptionKnp).value {
            knpDescriptionText = knpDescriptionValue
        }
        
        var kbkDescriptionText: String? = nil
        if let kbkDescriptionValue = component(by: .descriptionKbk).value {
            kbkDescriptionText = kbkDescriptionValue
        }
        
        var list: [String?]
        list = [vinText, admFinesText, paymentPurposeText, kbkDescriptionText, knpDescriptionText, ndsAmountText]
        
        if isBankBinInBankBikTransactionLimits(), isKnpEqualToConstant() {
            list = [vinText, admFinesText, kbkDescriptionText, knpDescriptionText, paymentPurposeText, ndsAmountText]
        }
        
        return list.compactMap({ (s) -> String? in return s}).joined(separator: " ")
    }
    
    private func isBankBinInBankBikTransactionLimits() -> Bool {
        guard let bankBikTransactionLimits = bankBikTransactionLimits else {
            return false
        }
        return bankBikTransactionLimits.contains(component(by: .bankBik).value ?? "")
    }
    
    private func isKnpEqualToConstant() -> Bool {
        return component(by: .knp).value == "911"
    }
    
    private func isAdmFinesInfoText(text: String) -> Bool {
        return text.count < 15
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
    
    private func updateVisabilityOfAgreementComponents(amount: Double, customerResidencyCode: Int, beneficiaryResidencyCode: Int) {
        if let thresholdAmount = thresholdAmount {
            if amount < thresholdAmount {
                if 11...18 ~= customerResidencyCode &&
                    21...29 ~= beneficiaryResidencyCode {
                    self.component(by: .isNotNeedUnc).isVisible = true
                } else {
                    self.component(by: .isNotNeedUnc).isVisible = false
                }
                self.component(by: .isNotLinkTerrorism).isVisible = false
                self.component(by: .isPermitGiveInformation).isVisible = false
                return
            } else {
                if 11...19 ~= beneficiaryResidencyCode ||
                    21...29 ~= beneficiaryResidencyCode {
                    if customerResidencyCode == 19 {
                        self.component(by: .isNotNeedUnc).isVisible = true
                        self.component(by: .isNotLinkTerrorism).isVisible = true
                        self.component(by: .isPermitGiveInformation).isVisible = true
                    } else if customerResidencyCode == 29 {
                        self.component(by: .isNotNeedUnc).isVisible = false
                        self.component(by: .isNotLinkTerrorism).isVisible = true
                        self.component(by: .isPermitGiveInformation).isVisible = true
                    }
                    return
                }
            }
        }
        
        hideAgreementComponents()
    }
    
    private func hideAgreementComponents() {
        self.component(by: .isNotNeedUnc).isVisible = false
        self.component(by: .isNotLinkTerrorism).isVisible = false
        self.component(by: .isPermitGiveInformation).isVisible = false
    }
}

enum DomesticTransferComponent: String {
    case documentNumber
    case template
    case accountNumber
    case receiverName
    case iin
    case kbe
    case receiverAccount
    case bankBik
    case bankName
    case urgentPayment
    case valueDate
    case amount
    case nds
    case ndsAmount
    case knp
    case descriptionKnp
    case kvo
    case descriptionKvo
    case paymentPurpose
    case paymentPurposeInfo
    case additionalInfo
    case bankResponse
    case budgetPayment
    case kbk
    case descriptionKbk
    case vinCode
    case accountant
    case director
    case isNotNeedUnc
    case isNotLinkTerrorism
    case isPermitGiveInformation
    case isLoanPay
    case forChildOrganization
    case listOfChildrenOrganisations
    case bin
    case childOrganizationCode
    case admFines
}
//
//  DomesticTransferViewModel+Extension.swift
//  DigitalBank
//
//  Created by Алем Утемисов on 08.05.2018.
//  Copyright © 2018 iosDeveloper. All rights reserved.
//

import Foundation

extension DomesticTransferViewModel: OperationViewModelDataLoadable {
    
    func setupComponents() {
        
        // Local function
        func str(_ component: DomesticTransferComponent) -> String { return component.rawValue }
        let optionsPlaceholder = "Выберите из списка"
        let textFieldPlaceholder = "Введите данные"
        let constraints = AppState.sharedInstance.config?.documents?.domesticTransfer?.paymentOrder?.constraints
        components = [
            OperationComponent(type: ComponentType.searchTextField, name: DomesticTransferComponent.template.rawValue, title: "Шаблоны", placeholder: optionsPlaceholder),
            
            OperationComponent(type: .textfield, name: str(.documentNumber), title: "Номер документа", placeholder: textFieldPlaceholder, constraints: constraints?.number),
            
            OperationComponent(type: ComponentType.switcher, name: DomesticTransferComponent.forChildOrganization.rawValue, title: "За дочернюю организацию"),
            
            OperationComponent(type: ComponentType.options, name: DomesticTransferComponent.listOfChildrenOrganisations.rawValue, title: "Наименование", placeholder: "Список дочерних организации", isVisible: false),
            
            OperationComponent(type: ComponentType.textfield, name: DomesticTransferComponent.bin.rawValue, title: "БИН/ИИН", placeholder: "БИН/ИИН", isVisible: false, uiProperties: [.isUserInteractionEnabled(false)]),
            
            OperationComponent(type: ComponentType.textfield, name: DomesticTransferComponent.childOrganizationCode.rawValue, title: "Код", placeholder: "Код", isVisible: false, uiProperties: [.isUserInteractionEnabled(false)]),
            
            OperationComponent(type: ComponentType.options, name: DomesticTransferComponent.accountNumber.rawValue, title: "Счет списания", placeholder: optionsPlaceholder, constraints: constraints?.account),
            
            OperationComponent(type: ComponentType.searchTextField, name: DomesticTransferComponent.receiverName.rawValue, title: "Наименование получателя", placeholder: textFieldPlaceholder, constraints: constraints?.benefName),
            
            OperationComponent(type: ComponentType.searchTextField, name: DomesticTransferComponent.iin.rawValue, title: "БИН/ИИН получателя", placeholder: textFieldPlaceholder, constraints: constraints?.benefTaxCode),
            
            OperationComponent(type: ComponentType.searchTextField, name: DomesticTransferComponent.kbe.rawValue, title: "КБЕ получателя", placeholder: textFieldPlaceholder, constraints: constraints?.benefResidencyCode),
            
            OperationComponent(type: ComponentType.searchTextField, name: DomesticTransferComponent.receiverAccount.rawValue, title: "Счет зачисления", placeholder: textFieldPlaceholder, constraints: constraints?.benefAccount, uiProperties: [.autocapitalizationType(.allCharacters)]),
            
            OperationComponent(type: ComponentType.searchTextField, name: DomesticTransferComponent.bankBik.rawValue, title: "БИК банка получателя", placeholder: textFieldPlaceholder, constraints: constraints?.benefBankCode),
            
            OperationComponent(type: ComponentType.label, name: DomesticTransferComponent.bankName.rawValue, title: "Наименование банка получателя", placeholder: textFieldPlaceholder, dependency: Dependency(name: DomesticTransferComponent.bankBik.rawValue, condition: .visibility), constraints: nil),
            
            OperationComponent(type: ComponentType.switcher, name: DomesticTransferComponent.urgentPayment.rawValue, title: "Срочный платеж", placeholder: nil, constraints: nil),
            
            OperationComponent(type: ComponentType.options, name: DomesticTransferComponent.valueDate.rawValue, title: "Дата валютирования", placeholder: optionsPlaceholder, constraints: constraints?.valueDate),
            
            OperationComponent(type: ComponentType.amount, name: DomesticTransferComponent.amount.rawValue, title: "Сумма списания", placeholder: textFieldPlaceholder, constraints: constraints?.amount),
            
            OperationComponent(type: ComponentType.switcher, name: DomesticTransferComponent.nds.rawValue, title: "С НДС (12%)", placeholder: nil, constraints: nil),
            
            OperationComponent(type: ComponentType.label, name: DomesticTransferComponent.ndsAmount.rawValue, title: "Сумма НДС (KZT)" , dependency: Dependency(name: DomesticTransferComponent.nds.rawValue, condition: .visibility), constraints: nil, isVisible: false),
            
            OperationComponent(type: ComponentType.switcher, name: DomesticTransferComponent.isLoanPay.rawValue, title: "За счет кредитных средств (при предоставлении кредита банком)", placeholder: nil, constraints: nil),
            
            OperationComponent(type: ComponentType.searchTextField, name: DomesticTransferComponent.knp.rawValue, title: "КНП", placeholder: textFieldPlaceholder, constraints: constraints?.purposeCode),
            
            OperationComponent(type: ComponentType.label, name: DomesticTransferComponent.descriptionKnp.rawValue, title: "Описание КНП", dependency: Dependency(name: DomesticTransferComponent.knp.rawValue, condition: .visibility), constraints: nil),
            
            OperationComponent(type: .searchTextField, name: str(.kvo),                          title: "КВО", placeholder: textFieldPlaceholder, constraints: nil),
            
            OperationComponent(type: .label,           name: str(.descriptionKvo),               title: "Описание КВО", dependency: Dependency(name: str(.kvo), condition: .visibility), constraints: nil),
            
            OperationComponent(type: ComponentType.searchTextField, name: DomesticTransferComponent.kbk.rawValue, title: "КБК", placeholder: textFieldPlaceholder, dependency: Dependency(name: DomesticTransferComponent.knp.rawValue, condition: .visibility), constraints: constraints?.budgetCode, isVisible: false),
            
            OperationComponent(type: ComponentType.searchTextField, name: DomesticTransferComponent.kbk.rawValue, title: "КБК", placeholder: textFieldPlaceholder, dependency: Dependency(name: DomesticTransferComponent.budgetPayment.rawValue, condition: .visibility), constraints: constraints?.budgetCode, isVisible: false),
            
            OperationComponent(type: ComponentType.label, name: DomesticTransferComponent.descriptionKbk.rawValue, title: "Описание КБК", dependency: Dependency(name: DomesticTransferComponent.kbk.rawValue, condition: .visibility), constraints: nil, isVisible: false),
            
            OperationComponent(type: ComponentType.textfield, name: DomesticTransferComponent.admFines.rawValue, title: "№ административного дела", placeholder: textFieldPlaceholder, dependency: Dependency(name: DomesticTransferComponent.kbk.rawValue, condition: .visibility), constraints: nil, isVisible: false),
            
            OperationComponent(type: ComponentType.textfield, name: DomesticTransferComponent.vinCode.rawValue, title: "VIN код", placeholder: textFieldPlaceholder, dependency: Dependency(name: DomesticTransferComponent.budgetPayment.rawValue, condition: .visibility), constraints: constraints?.vinCode, isVisible: false),
            
            OperationComponent(type: ComponentType.searchTextField, name: DomesticTransferComponent.paymentPurpose.rawValue, title: "Назначение платежа", placeholder: textFieldPlaceholder, constraints: constraints?.purpose),
            
            OperationComponent(type: ComponentType.label, name: DomesticTransferComponent.paymentPurposeInfo.rawValue, title: "Детали платежа", placeholder: "", constraints: nil, uiProperties: [.isUserInteractionEnabled(false), .isMultiLineEnabled(true)]),
            
            OperationComponent(type: ComponentType.textfield, name: DomesticTransferComponent.additionalInfo.rawValue, title: "Дополнительная информация", placeholder: textFieldPlaceholder, constraints: constraints?.info),
            
            OperationComponent(type: .label, name: str(.bankResponse), title: "Сообщение из банка", isVisible: false),
            
            OperationComponent(type: .options, name: str(.director), title: "Руководитель", placeholder: optionsPlaceholder, constraints: constraints?.director),
            
            OperationComponent(type: .options, name: str(.accountant), title: "Гл. бухгалтер", placeholder: optionsPlaceholder),
            
            OperationComponent(type: .switcher, name: str(.isNotLinkTerrorism), title: "Подтверждаю, что данный платеж и (или) перевод денег не связан с финансированием террористической или экстремистской деятельности и иным пособничеством терроризму либо экстремизму.", isVisible: false),
            
            OperationComponent(type: .switcher, name: str(.isNotNeedUnc), title: "Подтверждаю, что данный платеж и (или) перевод денег не связан с осуществлением физическим лицом валютной операции, требующей получения регистрационного свидетельства, свидетельства об уведомлении, учетного номера контракта.", isVisible: false),
            
            OperationComponent(type: .switcher, name: str(.isPermitGiveInformation), title: "Разрешаю уполномоченному банку представление информации о данном платеже и (или) переводе денег в правоохранительные органы Республики Казахстан и Национальный Банк по их требованию.", isVisible: false)
        ]
    }
    
    public func loadInitialData(onCompletion perform: @escaping (_ success: Bool, _ errorDescription: String?) -> Void){
        let url = baseURL + "api/payment/domestic-transfer/source-field?fieldList=ACCOUNTS%2CCOUNTERPARTIES%2CKBE%2CLOCAL_BANKS%2CPAYMENT_DATES%2CKNP%2CPURPOSES%2CTEMPLATES%2CCONSTRAINTS%2CKBK_FOR_VIN%2CSUBSIDIARY_CUSTOMER%2CCUSTOMER%2CDOCUMENT_NUMBER%2CKVO%2CCOMPANY_PERSONS%2CKBK&domesticTransferType=PaymentOrder"
        sessionManager.request(url, method: .get).responseJSON {[weak self] (serverResponse) in
            log(serverResponse: serverResponse)
            let dictionary = serverResponse.result.value as? [String: Any]
            
            guard serverResponse.result.isSuccess && serverResponse.error == nil else {
                perform(false, serverResponse.error?.localizedDescription)
                return
            }
            guard let dict = dictionary else {
                perform(false, serverResponse.error?.localizedDescription)
                return
            }
            self?.sourceData = DomesticTransferSourсeData(JSON: dict)
            if self?.sourceData?.kbkVin != nil {
                self?.vins = self?.sourceData?.kbkVin!.components(separatedBy: ",")
            }
            
            let dispatchGroup = DispatchGroup()
            var isSuccess: Bool = true
            var errorDescription: String? = nil
            dispatchGroup.enter()
            self?.loadKbkToKbeConst(onCompletion: { (success, errorMessage) in
                if !success {
                    errorDescription = errorMessage
                    isSuccess = false
                }
                dispatchGroup.leave()
            })
            
            dispatchGroup.enter()
            self?.loadThresholdAmount(forCurrency: Constants.Сurrency.KZT, onCompletion: { (success, errorMessage) in
                if !success {
                    errorDescription = errorMessage
                    isSuccess = false
                }
                dispatchGroup.leave()
            })
            
            dispatchGroup.enter()
            self?.loadAdmFinesConst(onCompletion: { (success, errorMessage) in
                if !success {
                    errorDescription = errorMessage
                    isSuccess = false
                }
                dispatchGroup.leave()
            })
            
            dispatchGroup.enter()
            self?.loadCurrencyOperationLimit { (success, errorMessage) in
                if !success {
                    errorDescription = errorMessage
                    isSuccess = false
                }
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            self?.loadBankBikTransactionLimitConstants { (success, errorMessage) in
                if !success {
                    errorDescription = errorMessage
                    isSuccess = false
                }
                dispatchGroup.leave()
            }
            
            dispatchGroup.notify(queue: .main) {
                perform(isSuccess, errorDescription)
            }
        }
    }
    
    public func loadCurrencyOperationLimit(onCompletion perform: @escaping (_ success: Bool, _ errorDescription: String?) -> Void) {
        let url = baseURL + "api/constants/name/CURRENCY_OPERATION_LIMIT"
        sessionManager.request(url, method: .get).responseJSON {  [weak self] (serverResponse) in
            guard let self = self else {
                return
            }
            
            guard let dictionary = serverResponse.result.value as? [String: Any],
                serverResponse.result.isSuccess && serverResponse.error == nil else {
                    return
            }
            
            self.currencyOperationLimit = Double((dictionary["value"] as? String) ?? "0")
            perform(true, nil)
        }
    }
    
    func convertAmountToUSD(_ amount: Double?, _ currency: String?, _ complation: @escaping (Double?) -> Void) {
        guard let amount = amount, let currency = currency else {
            complation(nil)
            return
        }
        let url = baseURL + "api/exchange-rate/amount/\(currency)/detail"
        sessionManager.request(url, method: .get).responseJSON {  [weak self] (serverResponse) in
            log(serverResponse: serverResponse)
            
            guard let self = self else {
                return
            }
            
            guard let dictionary = serverResponse.result.value as? [String: Any],
                serverResponse.result.isSuccess && serverResponse.error == nil else {
                    complation(nil)
                    return
            }
            
            guard let exchangeRate = CurrencyExchangeRate(JSON: dictionary) else {
                complation(nil)
                return
            }
            
            complation(self.convertAmount(amount, exchangeRate))
        }
    }
    
    private func convertAmount(_ amount: Double, _ exchangeRate: CurrencyExchangeRate) -> Double? {
        guard let currencyNbrkRate = exchangeRate.currencyNbrkRate,
            let usdNbrkRate = exchangeRate.usdNbrkRate else {
                return nil
        }
        return (amount * currencyNbrkRate) / usdNbrkRate
    }
    
    func loadKbkToKbeConst(onCompletion perform: @escaping (_ success: Bool, _ errorDescription: String?) -> Void) {
        let url = baseURL + "api/documents/mobile/payment-order-and-payroll-data"
        sessionManager.request(url, method: .get).responseJSON {[weak self] (serverResponse) in
            log(serverResponse: serverResponse)
            let dictionary = serverResponse.result.value as? [String: Any]
            
            guard serverResponse.result.isSuccess && serverResponse.error == nil else {
                perform(false, serverResponse.error?.localizedDescription)
                return
            }
            guard let dict = dictionary else {
                perform(false, serverResponse.error?.localizedDescription)
                return
            }
            guard let KbeToKbkConst = dict["KbeToKbkConst"] as? [String],
                let biksToKbkConst = dict["biksToKbkConst"] as? [String] else {
                    perform(false, "didn't receive some values from the server")
                    return
            }
            self?.KbeToKbkConst = KbeToKbkConst
            self?.biksToKbkConst = biksToKbkConst
            perform(true, nil)
        }
    }
    
    func loadAdmFinesConst(onCompletion perform: @escaping (_ success: Bool, _ errorDescription: String?) -> Void) {
        let url = baseURL + "api/constants/name/KBK_FOR_ADM_FINES"
        sessionManager.request(url, method: .get).responseJSON {[weak self] (serverResponse) in
            log(serverResponse: serverResponse)
            let dictionary = serverResponse.result.value as? [String: Any]
            
            guard serverResponse.result.isSuccess && serverResponse.error == nil else {
                perform(false, serverResponse.error?.localizedDescription)
                return
            }
            guard let dict = dictionary else {
                perform(false, serverResponse.error?.localizedDescription)
                return
            }
            guard let kbkForAdmFines = dict["value"] as? String else {
                perform(false, "didn't receive some values from the server")
                return
            }
            self?.kbkForAdmFines = kbkForAdmFines.components(separatedBy: ",")
            perform(true, nil)
        }
    }
    
    func loadBankBikTransactionLimitConstants(onCompletion perform: @escaping (_ success: Bool, _ errorDescription: String?) -> Void) {
        let url = baseURL + "api/constants/name/BANKS_BIK_TRANSACTION_LIMIT_FILTER"
        sessionManager.request(url, method: .get).responseJSON {[weak self] (serverResponse) in
            log(serverResponse: serverResponse)
            let dictionary = serverResponse.result.value as? [String: Any]
            
            guard serverResponse.result.isSuccess && serverResponse.error == nil else {
                perform(false, serverResponse.error?.localizedDescription)
                return
            }
            guard let dict = dictionary else {
                perform(false, serverResponse.error?.localizedDescription)
                return
            }
            guard let kbkForAdmFines = dict["value"] as? String else {
                perform(false, "didn't receive some values from the server")
                return
            }
            self?.bankBikTransactionLimits = kbkForAdmFines.components(separatedBy: ",")
            perform(true, nil)
        }
    }
    
    func set(accountNumber: String?, balance: String?) {
        component(by: .accountNumber).setValue(newValue: accountNumber)
        component(by: .accountNumber).description = balance
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
    
    func requestVAT(onCompletion perform: @escaping (_ success: Bool, _ errorDescription: String?) -> Void) {
        let context = VATContext()
        context.sum = component(by: .amount).value ?? "0"
        context.execute(isSuccsess: { [weak self] (response) in
            guard let amount = response as? Double else { perform(false, nil); return }
            self?.component(by: .ndsAmount).setValue(newValue: String(format: "%.2f", amount).splittedAmount)
            if self?.component(by: .ndsAmount).value != nil {
                self?.ndsAmountText = " (в том числе с НДС " + (self?.component(by: .ndsAmount).value)! + ")"
                self?.component(by: .paymentPurposeInfo).setValue(newValue: self?.setPaymentPurposeInfoText())
            } else {
                self?.ndsAmountText = " (в том числе с НДС 00.00 )"
                self?.component(by: .paymentPurposeInfo).setValue(newValue: self?.setPaymentPurposeInfoText())
            }
            perform(true, nil)
        }) { (error) in
            if let serverError = error as? ContextError {
                perform(false, serverError.errorDescription)
            } else {
                perform(false, error?.localizedDescription)
            }
        }
    }
    
    func saveDocument(isTemplate: Bool, onCompletion perform: @escaping (_ success: Bool, _ errorMessage: String?) -> Void) {
        guard let document = domesticTransferToSend else { return }
        let save = SaveDomesticTransferContext()
        save.documentID = initialDocument?.id
        save.finalDocument = document
        save.finalDocument?.isTemplate = isTemplate
        if isTemplate && initialDocument?.id != nil {
            save.reSaveTemplate = true
        }
        
        save.execute(isSuccsess: { (response) in
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
        sessionManager.request(url, method: .get).validate().responseString { [weak self]  response in
            log(serverResponse: response)
            guard let documentNumber = response.result.value else { return }
            self?.component(by: .documentNumber).setValue(newValue: documentNumber)
            perform(true, nil)
        }
    }
    
    func loadThresholdAmount(forCurrency currency: String, onCompletion perform: ((_ success: Bool, _ errorMessage: String?) -> Void)?) {
        let url = baseURL + "api/exchange-rate/amount/" + currency
        sessionManager.request(url, method: .get).validate().responseJSON { [unowned self] response in
            log(serverResponse: response)
            guard let amount = response.result.value as? Double else {
                self.thresholdAmount = nil
                perform?(true, nil)
                return
            }
            
            self.thresholdAmount = amount
            perform?(true, nil)
        }
    }
    
    func loadPayDays(bik: String, onCompletion perform: @escaping (_ success: Bool, _ errorDescription: String?) -> Void) {
        let url = baseURL + "api/documents/mobile/paydays?benefBankCode=\(bik)&paymentType="
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
}

import Foundation
import ObjectMapper

class DomesticTransferSourсeData: NSObject, Mappable {
    
    var accountViews: [AccountDetails]?
    var companyPersons: [[CompanyPerson]]?
    var counterparties: [CounterpartyList]?
    var customerView: CustomerView?
    var documentNumber: String?
    var localBanks: [LocalBank]?
    var payDays: ValueDates?
    var paymentPurposes: [String]?
    var kbkVin: String?
    var knp: [KNP]?
    var kvo: [KVO]?
    var KBE: [KBE]?
    var kbk: [KBK]?
    var transferRequisites: TransferRequisites?
    var employeeTransferCategory: [EmployeeTransferCategory]?
    var templates: [DomesticTransferTemplateDescription]?
    var KbeToKbkConst: [String]?
    var isSubsidiaryOrganization: Bool?
    var subsidiaryCustomerShortData: SubsidiaryCustomer?
    
    var directors: [CompanyPerson]{
        return companyPersons?.first ?? []
    }
    
    var accountants: [CompanyPerson]{
        return companyPersons?.last ?? []
    }
    var subsidiaryCustomers: [SubsidiaryCustomer]?
    required init?(map: Map) {
        super.init()
    }
    
    func mapping(map: Map) {
        accountViews <- map["ACCOUNTS"]
        kbk <- map["KBK"]
        kbkVin <- map["KBK_FOR_VIN"]
        counterparties <- map["COUNTERPARTIES"]
        customerView <- map["CUSTOMER"]
        documentNumber <- map["DOCUMENT_NUMBER"]
        localBanks <- map["LOCAL_BANKS"]
        payDays <- map["PAYMENT_DATES"]
        paymentPurposes <- map["PURPOSES"]
        knp <- map["KNP"]
        kvo <- map["KVO"]
        companyPersons <- map["COMPANY_PERSONS"]
        KBE <- map["KBE"]
        templates <- map["TEMPLATES"]
        transferRequisites <- map["SOCIAL_COMPANY"]
        employeeTransferCategory <- map["EMPLOYEE_TRANSFER_CATEGORIES"]
        KbeToKbkConst <- map["KbeToKbkConst"]
        subsidiaryCustomers <- map["SUBSIDIARY_CUSTOMER"]
        isSubsidiaryOrganization <- map["isSubsidiaryOrganization"]
        subsidiaryCustomerShortData <- map["subsidiaryCustomerShortData"]
    }
}

class CustomerView: BaseModel {
    var name: String?
    var intName: String?
    var taxCode: String?
    var residencyCode: String?
    var intlAddress: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        name <- map["name"]
        intName <- map["intName"]
        taxCode <- map["taxCode"]
        residencyCode <- map["residencyCode"]
        intlAddress <- map["intlAddress"]
    }
}

class AccountDetails: BaseModel {
    var number: String?
    var accountType: String?
    var currency: String?
    var currencyDigital: String?
    var balance: Sum?
    var plannedBalance: Sum?
    var alias: String?
    var status: Status?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        number <- map["number"]
        accountType <- map["accountType"]
        currency <- map["currency"]
        currencyDigital <- map["currencyDigital"]
        balance <- map["balance"]
        plannedBalance <- map["plannedBalance"]
        alias <- map["alias"]
        status <- map["status"]
    }
    
    static public func ==(lhs: AccountDetails, rhs: AccountDetails) -> Bool {
        return lhs.id == rhs.id
    }
}

class BudgetCode: BaseModel {
    var label: String?
    var value: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        label <- map["label"]
        value <- map["value"]
    }
}

class KBK: BaseModel {
    var label: String?
    var code: String?
    var deleted: Bool?
    var category: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        deleted <- map["deleted"]
        label <- map["label"]
        code <- map["code"]
        category <- map["category"]
    }
}

class CompanyPerson: BaseModel {
    var fullName: String?
    var position: String?
    var sign_level: String?
    
    init(_ smCompanyPerson: SMCompanyPerson) {
        super.init()
        self.fullName = smCompanyPerson.fullName
        self.position = smCompanyPerson.position
        self.sign_level = smCompanyPerson.sign_level
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        fullName <- map["fullName"]
        position <- map["position"]
        sign_level <- map["sign_level"]
    }
}

struct SMCompanyPerson: Codable, SMBaseModel {
    var fullName: String?
    var position: String?
    var sign_level: String?
    var id: Int
}

class DocumentNumber: BaseModel {
    var documentNumber: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        documentNumber <- map["documentNumber"]
    }
}

struct CounterpartyList: Mappable {
    var counterparty: Contragent?
    var accounts: [Account]?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        counterparty <- map["counterparty"]
        accounts <- map["accounts"]
    }
}

class KBE: BaseModel {
    var label: String?
    var code: String?
    var category: String?
    var deleted: Bool?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        deleted <- map["deleted"]
        category <- map["category"]
        label <- map["label"]
        code <- map["code"]
    }
}

class SubsidiaryCustomer: BaseModel {
    var customerId: Int?
    var name: String?
    var taxCode: String?
    var ownershipType: String?
    var beneficiaryCode: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        id <- map["id"]
        customerId <- map["customerId"]
        name <- map["name"]
        taxCode <- map["taxCode"]
        ownershipType <- map["ownershipType"]
        beneficiaryCode <- map["beneficiaryCode"]
    }
    
}

class TransferEmployee: BaseModel {
    var taxCode: String?
    var name: String?
    var residencyCode: String?
    var account: String?
    var bankCode: String?
    var bankName: String?
    var paymentPurposeCode: PaymentPurposeCode?
    var pensionCnType: PensionCnType?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        id <- map["id"]
        taxCode <- map["taxCode"]
        name <- map["name"]
        residencyCode <- map["residencyCode"]
        account <- map["account"]
        bankCode <- map["bankCode"]
        bankName <- map["bankName"]
        paymentPurposeCode <- map["paymentPurposeCode"]
        pensionCnType <- map["pensionCnType"]
    }
}

class PaymentPurposeCode: BaseModel {
    var deleted: Bool?
    var externalId: String?
    var category: String?
    var code: String?
    var label: String?
    var forIndividuals: Bool?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        id <- map["id"]
        deleted <- map["deleted"]
        externalId <- map["externalId"]
        category <- map["category"]
        code <- map["code"]
        label <- map["label"]
        forIndividuals <- map["forIndividuals"]
    }
}

class PensionCnType: BaseModel {
    var code: String?
    var name: String?
    var parentId: Int?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        id <- map["id"]
        parentId <- map["parentId"]
        name <- map["name"]
        code <- map["code"]
    }
}

class Status: BaseModel {
    
    var code: String?
    var label: String?
    var subCode: String?
    var subLabel: String?
    
    override func mapping(map: Map) {
        id <- map["id"]
        code <- map["code"]
        label <- map["label"]
        subCode <- map["subCode"]
        subLabel <- map["subLabel"]
    }
    
    var statusCode: ProductStatus? {
        guard let code = code else { return nil }
        return ProductStatus(rawValue: code)
    }
}

import Foundation
import ObjectMapper

class LocalBank: Bank {
    var cityString: String?
    var nationalBankName: String?
    var bankBik: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        cityString <- map["city"]
        nationalBankName <- map["bankName"]
        bankBik <- map["nationalBankBik"]
    }
}

import Foundation
import ObjectMapper

class Contragent: NSObject, Mappable {
    var id: Int!
    var deleted: Bool?
    var isNational: Bool?
    var name: String?
    var internationalName: String?
    var bin: String?
    var beneficiaryCode: String?
    var country: Country?
    var countryName: String?
    var city: String?
    var address: String?
    var notes: String?
    var kpp: String?
    var account: String?
    var bankCode: String?
    var bankName: String?
    var countryCode: String?
    var countryTwoLetterCode: String?
    var ibans: [String]?
    
    required init?(map: Map) {
        if map.JSON["id"] as? Int == nil {
            return nil
        }
        
        super.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        deleted <- map["deleted"]
        isNational <- map["isNational"]
        name <- map["name"]
        internationalName <- map["internationalName"]
        bin <- map["bin"]
        beneficiaryCode <- map["beneficiaryCode"]
        country <- map["country"]
        countryName <- map["countryName"]
        city <- map["city"]
        address <- map["address"]
        notes <- map["notes"]
        kpp <- map["kpp"]
        account <- map["account"]
        bankCode <- map["bankCode"]
        bankName <- map["bankName"]
        countryCode <- map["countryCode"]
        countryTwoLetterCode <- map["countryTwoLetterCode"]
        ibans <- map["ibans"]
    }
}

class Account: BaseModel {
    var deleted: Bool?
    var iban: String?
    var bankName: String?
    var bankCode: String?
    var bankId: String?
    var bankAddress: String?
    var bankCountryId: Int?
    var bankCity: String?
    var corrBankAccount: String?
    var bankCountryTwoLetterCode: String?
    var bankCountryName: String?
    var iso: String?
    var bank: InternationalBank?
    
    var internationalBank: InternationalBank?
    var internationalBankCity: String?
    var internationalBankAddress: String?
    var internationalBankAccount: String?
    var internationalAgent: InternationalBank?
    var internationalAgentCity: String?
    var internationalAgentAddress: String?
    var internationalAgentAccount: String?
    var counterpartyId: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        deleted <- map["deleted"]
        iban <- map["iban"]
        iso <- map["iso"]
        bank <- map["bank"]
        bankName <- map["bankName"]
        bankCode <- map["bankCode"]
        bankId <- map["bankId"]
        bankAddress <- map["bankAddress"]
        bankCountryId <- map["bankCountryId"]
        bankCity <- map["bankCity"]
        corrBankAccount <- map["corrBankAccount"]
        bankCountryTwoLetterCode <- map["bankCountryTwoLetterCode"]
        bankCountryName <- map["bankCountryName"]
        
        internationalBank <- map["internationalBank"]
        internationalBankCity <- map["internationalBankCity"]
        internationalBankAddress <- map["internationalBankAddress"]
        internationalBankAccount <- map["internationalBankAccount"]
        internationalAgent <- map["internationalAgent"]
        internationalAgentCity <- map["internationalAgentCity"]
        internationalAgentAddress <- map["internationalAgentAddress"]
        internationalAgentAccount <- map["internationalAgentAccount"]
        counterpartyId <- map["counterpartyId"]
    }
}

class KVO: BaseModel {
    var deleted: Bool?
    var name: String?
    var code: String?
    var knpMatch: String?
    var knpExclude: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        deleted <- map["deleted"]
        name <- map["name"]
        code <- map["code"]
        knpMatch <- map["knpMatch"]
        knpExclude <- map["knpExclude"]
    }
}

import Foundation
import ObjectMapper

class DomesticTransfer: BaseModel {
    var account: AccountDetails?
    var amount: Double?
    var valueDate: String?
    var purpose: String?
    var purposeCode: String?
    var purposeCodeLabel: String?
    var kvo: String?
    var kvoLabel: String?
    var priority: Bool?
    var benefName: String?
    var benefTaxCode: String?
    var benefAccount: String?
    var benefBankCode: String?
    var benefResidencyCode: String?
    var custId: Int?
    var custName: String?
    var custTaxCode: String?
    var custResidencyCode: String?
    var created: String?
    var number: String?
    var state: String?
    var type: String?
    var director: CompanyPerson?
    var accountant: CompanyPerson?
    var bankResponse: String?
    var manager: Manager?
    var info: String?
    var isTemplate: Bool?
    var templateName: String?
    var actions: Actions?
    var domesticTransferType: String?
    var vat: Sum?
    var budgetCode: String?
    var budgetCodeLabel: String?
    var vinCode: String?
    var bankName: String?
    var employees: [EmployeeSender]?
    var documentnumber: String?
    var documentDate: String?
    var urgent: Bool?
    var isNotNeedUnc: Bool?
    var isNotLinkTerrorism: Bool?
    var isPermitGiveInformation: Bool?
    var employeeTransferCategory: String?
    var employeeTransferPeriod: String?
    var isLoanPay: Bool?
    var paymentPurposeText: String?
    var isSubsidiaryOrganization: Bool?
    var subsidiaryCustomerShortData: SubsidiaryCustomer?
    var numberOfAdministrativeAffairs: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        urgent <- map["urgent"]
        documentDate <- map[""]
        account <- map["account"]
        amount <- map["amount"]
        purpose <- map["purpose"]
        valueDate <- map["valueDate"]
        purposeCode <- map["purposeCode"]
        purposeCodeLabel <- map["purposeCodeLabel"]
        kvo <- map["kvo"]
        kvoLabel <- map["kvoLabel"]
        priority <- map["priority"]
        benefName <- map["benefName"]
        benefTaxCode <- map["benefTaxCode"]
        benefAccount <- map["benefAccount"]
        benefBankCode <- map["benefBankCode"]
        benefResidencyCode <- map["benefResidencyCode"]
        custId <- map["custId"]
        custName <- map["custName"]
        custTaxCode <- map["custTaxCode"]
        custResidencyCode <- map["custResidencyCode"]
        created <- map["create"]
        number <- map["number"]
        state <- map["state"]
        type <- map["type"]
        director <- map["director"]
        accountant <- map["accountant"]
        bankResponse <- map["bankResponse"]
        manager <- map["manager"]
        info <- map["info"]
        isTemplate <- map["isTemplate"]
        templateName <- map["templateName"]
        actions <- map["actions"]
        domesticTransferType <- map["domesticTransferType"]
        vat <- map["vat"]
        budgetCode <- map["budgetCode"]
        budgetCodeLabel <- map["budgetCodeLabel"]
        vinCode <- map["vinCode"]
        bankName <- map["bankName"]
        employees <- map["employees"]
        documentnumber <- map["documentnumber"]
        isNotNeedUnc <- map["isNotNeedUnc"]
        isNotLinkTerrorism <- map["isNotLinkTerrorism"]
        isPermitGiveInformation <- map["isPermitGiveInformation"]
        employeeTransferCategory <- map["employeeTransferCategory"]
        employeeTransferPeriod <- map["employeeTransferPeriod"]
        isLoanPay <- map["isLoanPay"]
        paymentPurposeText <- map["purposeText"]
        isSubsidiaryOrganization <- map["isSubsidiaryOrganization"]
        subsidiaryCustomerShortData <- map["subsidiaryCustomerShortData"]
        numberOfAdministrativeAffairs <- map["numberOfAdministrativeAffairs"]
    }
}

struct Role: Mappable {
    var code: String?
    var deleted: Bool?
    var id: Int!
    var name: String?
    
    init?(map: Map) {
        if map.JSON["id"] == nil {
            return nil
        }
    }
    
    mutating func mapping(map: Map) {
        code <- map["code"]
        deleted <- map["deleted"]
        id <- map["id"]
        name <- map["name"]
    }
}

class ManagerShort: BaseModel {
    var fullName: String?
    var phone: String?
    var email: String?
    var isChat: Bool?
    var subdivision: String?
    var name: String? //name should be raname to role
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        fullName <- map["fullName"]
        phone <- map["phone"]
        email <- map["email"]
        isChat <- map["isChat"]
        subdivision <- map["subdivision"]
        name <- map["name"]
    }
}

class Manager: ManagerShort {
    var blocked: Bool?
    var deleted: Bool?
    var externalId: String?
    var incorrectPasswordCount: Int?
    var isBankSign: Bool?
    var isBlock: Bool?
    var lastLogin: String?
    var login: String?
    var maxIncorrectPasswordCount: Int?
    var role: Role?
    var shortName: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        blocked <- map["blocked"]
        deleted <- map["deleted"]
        externalId <- map["externalId"]
        incorrectPasswordCount <- map["incorrectPasswordCount"]
        isBankSign <- map["isBankSign"]
        isBlock <- map["isBlock"]
        lastLogin <- map["lastLogin"]
        login <- map["login"]
        maxIncorrectPasswordCount <- map["maxIncorrectPasswordCount"]
        role <- map["role"]
        shortName <- map["shortName"]
    }
}

class Bank: NSObject, Mappable {
    var id: Int!
    var deleted: Bool?
    var nationalBankBik: String?
    var country: Country?
    var bankName: String?
    var bankCode: String?
    var corrBankAccount: String?
    var city: String?
    var address: String?
    var twoLetterCode: String?
    
    required init?(map: Map) {
        if map.JSON["id"] == nil {
            return nil
        }
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        deleted <- map["deleted"]
        nationalBankBik <- map["nationalBankBik"]
        country <- map["country"]
        bankName <- map["bankName"]
        bankCode <- map["bankCode"]
        corrBankAccount <- map["corrBankAccount"]
        city <- map["city"]
        address <- map["address"]
        twoLetterCode <- map["twoLetterCode"]
    }
}

class Country: NSObject, Mappable {
    var id: Int?
    var deleted: Bool?
    var countryCode: String?
    var countryName: String?
    var fullCountryName: String?
    var threeLetterCode: String?
    var twoLetterCode: String?
    
    var countryString: String? {
        guard let name = self.countryName, let fullName = self.fullCountryName else { return nil }
        return String(format:" \(name) (\(fullName))")
    }
    
    required init?(map: Map) {
        super.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        deleted <- map["deleted"]
        countryCode <- map["countryCode"]
        countryName <- map["countryName"]
        fullCountryName <- map["fullCountryName"]
        threeLetterCode <- map["threeLetterCode"]
        twoLetterCode <- map["twoLetterCode"]
    }
}

class DomesticTransferToSend: NSObject, Mappable {
    var account: AccountDetails?
    var amount: String?
    var creditSum: String?
    var valueDate: String?
    var domesticTransferType: String?
    var purpose: String?
    var purposeText: String?
    var priority: Bool = false
    var info: String?
    var accountant: CompanyPerson?
    var director: CompanyPerson?
    var purposeCode: String?
    var kvo: String?
    var isTemplate: Bool?
    var templateName: String?
    var number: String?
    var benefName: String?
    var benefBankCode: String?
    var benefAccount: String?
    var creditAccount: AccountDetails?
    var benefResidencyCode: String?
    var benefTaxCode: String?
    var vat: String?
    var budgetCode: String?
    var vinCode: String?
    var documentNumber: String?
    var employees: [EmployeeSender]?
    var isNotNeedUnc: Bool?
    var isNotLinkTerrorism: Bool?
    var isPermitGiveInformation: Bool?
    var employeeTransferCategory: String?
    var employeeTransferPeriod: String?
    var numberOfAdministrativeAffairs: String?
    
    var invoiceId: Int?
    var isLoanPay: Bool?
    var isSubsidiaryOrganization: Bool?
    var subsidiaryOrganizationId: Int?
    
    override init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        documentNumber <- map["documentnumber"]
        account <- map["account"]
        valueDate <- map["valueDate"]
        amount <- map["amount"]
        creditSum <- map["creditSum"]
        domesticTransferType <- map["domesticTransferType"]
        purpose <- map["purpose"]
        purposeText <- map["purposeText"]
        priority <- map["priority"]
        info <- map["info"]
        accountant <- map["accountant"]
        director <- map["director"]
        purposeCode <- map["purposeCode"]
        kvo <- map["kvo"]
        isTemplate <- map["isTemplate"]
        templateName <- map["templateName"]
        number <- map["number"]
        benefName <- map["benefName"]
        benefBankCode <- map["benefBankCode"]
        benefAccount <- map["benefAccount"]
        creditAccount <- map["creditAccount"]
        benefResidencyCode <- map["benefResidencyCode"]
        benefTaxCode <- map["benefTaxCode"]
        vat <- map["vat"]
        budgetCode <- map["budgetCode"]
        vinCode <- map["vinCode"]
        isNotNeedUnc <- map["isNotNeedUnc"]
        isNotLinkTerrorism <- map["isNotLinkTerrorism"]
        isPermitGiveInformation <- map["isPermitGiveInformation"]
        employees <- map["employees"]
        employeeTransferCategory <- map["employeeTransferCategory"]
        employeeTransferPeriod <- map["employeeTransferPeriod"]
        numberOfAdministrativeAffairs <- map["numberOfAdministrativeAffairs"]
        
        invoiceId <- map["invoiceId"]
        isLoanPay <- map["isLoanPay"]
        isSubsidiaryOrganization <- map["isSubsidiaryOrganization"]
        subsidiaryOrganizationId <- map["subsidiaryOrganizationId"]
    }
}

class EmployeeSender: BaseModel {
    var firstName: String?
    var lastName: String?
    var middleName: String?
    var taxCode: String?
    var account: String?
    var amount: Double?
    var checked: Bool?
    var period: String?
    var birthDate: String?
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        middleName <- map["middleName"]
        taxCode <- map["taxCode"]
        checked <- map["checked"]
        account <- map["account"]
        period <- map["period"]
        birthDate <- map["birthDate"]
        amount <- map["amount"]
    }
    
    convenience init(worker: Employee) {
        self.init()
        self.firstName = worker.firstName
        self.lastName = worker.lastName
        self.middleName = worker.middleName
        self.taxCode = worker.taxCode
        self.account = worker.account
        self.period = worker.period
        self.birthDate = worker.birthDate
        self.amount = worker.amount
    }
}

struct SMTransferActions: Codable {
    //отозвать
    var revoke: [String]?
    //отправить в непринятые
    var bad: [String]?
    //удалить
    var remove: [String]?
    //отправить в банк
    var sentToRBS: [String]?
    //вернуть на редактирование
    var toDraft: [String]?
    //подписать
    var sign: [String]?
    //отправить на подписание
    var submit: [String]?
    //редактирование
    var edit: [String]?
    //отказать
    var reject: [String]?
    //оплатить
    var pay: [String]?
}

struct Actions: Mappable {
    //отозвать
    var revoke: [String]? = []
    //отправить в непринятые
    var bad: [String]? = []
    //удалить
    var remove: [String]? = []
    //отправить в банк
    var sentToRBS: [String]? = []
    //вернуть на редактирование
    var toDraft: [String]? = []
    //подписать
    var sign: [String]? = []
    //отправить на подписание
    var submit: [String]? = []
    //редактирование
    var edit: [String]? = []
    //отказать
    var reject: [String]? = []
    //оплатить
    var pay: [String]? = []
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        revoke <- map["revoke"]
        bad <- map["bad"]
        remove <- map["remove"]
        sentToRBS <- map["sentToRBS"]
        toDraft <- map["toDraft"]
        sign <- map["sign"]
        submit <- map["submit"]
        edit <- map["edit"]
        reject <- map["reject"]
        pay <- map["pay"]
    }
}


class ValidateDocumentNumberContext : Context {
    public let number: String
    private let documentType: Constants.DocumentType
    
    init(number: String, documentType: Constants.DocumentType) {
        self.number = number
        self.documentType = documentType
    }
    
    public override func urlString() -> String {
        return baseURL + "api/customer/documents/validate-number"
    }
    
    // This function can be reloaded
    public override func parametres() -> [String: Any]? {
        return ["number": number, "documentType": documentType.rawValue]
    }
    
    override func load(isSuccsess: @escaping SuccessfulLoaded, ifFailed: LoadingError? = nil) {
        let request = sessionManager.request(urlString(), method: HTTPMethod(), parameters: parametres(), encoding: encoding(), headers: HTTPHeaders())
        let validateRequest = request.validate()
        self.request = validateRequest
        validateRequest.responseString { (serverResponse) in
            guard let result = serverResponse.result.value else {
                ifFailed.map { $0(serverResponse.result.error) }
                return
            }
            
            isSuccsess(result)
        }
    }
}

class Loader {
    static let shared = Loader()
    lazy private var ansRootView = ANSRootView(frame: UIScreen.main.bounds)
    
    var isLoadingStateEnabled = false {
        didSet {
            guard isLoadingStateEnabled != oldValue else { return }
            if isLoadingStateEnabled {
                UIApplication.shared.keyWindow?.isUserInteractionEnabled = false
                UIApplication.shared.keyWindow?.addSubview(self.ansRootView)
                ansRootView.isLoadingViewVisible = true
            } else {
                ansRootView.removeFromSuperview()
                ansRootView.isLoadingViewVisible = false
                UIApplication.shared.keyWindow?.isUserInteractionEnabled = true
            }
        }
    }
    
    func show() {
        isLoadingStateEnabled = true
    }
    
    func hide() {
        isLoadingStateEnabled = false
    }
    
    private init() {}
}

import Alamofire
class Context {
    typealias SuccessfulLoaded = (_ result: Any) ->()
    typealias LoadingError = (_ error: Error?) -> ()
    
    public var controller: UIViewController? = nil
    public var model: AnyObject? = nil
    
    public var request: DataRequest? {
        willSet(newRequest) {
            request?.cancel()
            newRequest?.resume()
        }
    }
    
    public init(controller: UIViewController? = nil, model: AnyObject? = nil) {
        self.controller = controller
        self.model = model
    }
    
    deinit {
        self.request = nil
    }
    
    public func execute(isSuccsess: @escaping SuccessfulLoaded, ifFailed: LoadingError? = nil) {
        self.load(isSuccsess: isSuccsess, ifFailed: ifFailed)
    }
    
    public func cancel() {
        self.request = nil
    }
    
    // !Necessarily for reloaing (by default "")
    public func urlString() -> String {
        return ""
    }
    
    // This function can be reloaded
    public func parametres() -> [String: Any]? {
        return nil
    }
    
    // By default .get, this function can be reloaded
    public func HTTPMethod() -> HTTPMethod {
        return .get
    }
    
    // By default .URLEncoding.default, this function can be reloaded
    public func encoding() -> ParameterEncoding {
        return URLEncoding.default
    }
    
    public func HTTPHeaders() -> [String: String]? {
        return nil
    }
    
    func load(isSuccsess: @escaping SuccessfulLoaded, ifFailed: LoadingError? = nil) {
        let request = sessionManager.request(urlString(), method: HTTPMethod(), parameters: parametres(), encoding: encoding(), headers: HTTPHeaders())
        let validateRequest = request.validate()
        self.request = validateRequest
        validateRequest.responseJSON { (serverResponse) in
            log(serverResponse: serverResponse)
            guard let result = serverResponse.result.value, let statusCode = serverResponse.response?.statusCode, 200..<300 ~= statusCode else {
                ifFailed.map({
                    if let statusCode = serverResponse.response?.statusCode {
                        $0(ContextError.httpRequestAnyFailed(response: serverResponse, statusCode: statusCode))
                    } else {
                        $0(ContextError.unknown)
                    }
                })
                return
            }
            
            isSuccsess(result)
        }
    }
}

public enum ContextError: Error {
    case sessionExpired
    case unknown
    case httpRequestAnyFailed(response: DataResponse<Any>, statusCode: Int)
    case httpRequestStringFailed(response: DataResponse<String>, statusCode: Int)
}

extension ContextError: LocalizedError {
    public var errorDescription: String? {
        func descriptionFor(code: Int, serverError: ServerError? = nil) -> String {
            switch (code, serverError) {
            case (400, let error) where error != nil: return error!.messageForShow()
            case (401, _): return "Неверный логин или пароль"
            case (403, _): return "Ваш профиль удален"
            case (419, _): return "Сессия прервана администратором"
            case (500, _): return "Сервер не отвечает. Попробуйте позже"
            default: return "Ошибка HTTP запроса с кодом `\(code)`."
            }
        }
        
        switch self {
        case .unknown:
            return "Неизвестная ошибка, повторите позднее"
        case .httpRequestAnyFailed(let response, let statusCode):
            return descriptionFor(code: statusCode, serverError: response.getServerError())
        case .httpRequestStringFailed(let response, let statusCode):
            return descriptionFor(code: statusCode, serverError: response.getServerError())
        default:
            return nil
        }
    }
}

class ValueDates: Mappable {
    
    var currentDate: String?
    var dates: [String]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        currentDate <- map["currentDate"]
        dates <- map["valueDates"]
    }
    
}

class LoadStandingOrderContext: Context {
    var ID: String?
    
    public override func urlString() -> String {
        guard let id = self.ID else { return "" }
        return baseURL + "api/standing-order/\(id)"
    }
}

class VATContext: Context {
    public var sum: String = "0"
    public override func urlString() -> String {
        return "\(baseURL)api/customer/documents/calculate-vat?amount=\(sum.trim())"
    }
    
    public override func parametres() -> [String: Any]? {
        return nil
    }
    
    // By default .get, this function can be reloaded
    public override func HTTPMethod() -> HTTPMethod {
        return .get
    }
    
    // By default .URLEncoding.default, this function can be reloaded
    public override func encoding() -> ParameterEncoding {
        return JSONEncoding.default
    }
}


class SaveDomesticTransferContext: Context {
    public var finalDocument: DomesticTransferToSend?
    public var documentID: Int?
    public var reSaveTemplate = false
    
    override func urlString() -> String {
        guard let id = self.documentID, let document = self.finalDocument else {
            return baseURL + "api/payment/domestic-transfer/new"
        }
        
        if document.isTemplate == true {
            if reSaveTemplate {
                return baseURL + "api/payment/domestic-transfer/\(id)"
            } else {
                return baseURL + "api/payment/domestic-transfer/new"
            }
        }
        
        return baseURL + "api/payment/domestic-transfer/\(id)"
    }
    
    public override func parametres() -> [String: Any]? {
        guard let body = self.finalDocument else { return nil }
        // КОСТЫЛЬ begin
        //SESC: in tamplate purposeCode canNot be empty
        if finalDocument?.isTemplate == true && finalDocument?.purposeCode?.isEmpty == true {
            body.purposeCode = nil
        }
        // КОСТЫЛЬ end
        
        let json = body.toJSON()
        return json
    }
    
    public override func HTTPMethod() -> HTTPMethod {
        return .post
    }
    
    public override func encoding() -> ParameterEncoding {
        return JSONEncoding.default
    }
    
    override func load(isSuccsess: @escaping SuccessfulLoaded, ifFailed: LoadingError? = nil) {
        let request = sessionManager.request(urlString(), method: HTTPMethod(), parameters: parametres(), encoding: encoding(), headers: HTTPHeaders())
        let validateRequest = request.validate()
        self.request = validateRequest
        validateRequest.responseString { (serverResponse) in
            log(serverResponse: serverResponse)
            guard let result = serverResponse.result.value else {
                if serverResponse.getServerError() != nil {
                    ifFailed.map { $0(ContextError.httpRequestStringFailed(response: serverResponse, statusCode: serverResponse.response?.statusCode ?? 400)) }
                } else {
                    ifFailed.map { $0(serverResponse.result.error) }
                }
                return
            }
            
            isSuccsess(result)
        }
    }
    
}

class KNP: BaseModel {
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
}

class TransferRequisites: BaseModel {
    var deleted: Bool?
    
    var taxCode: String?
    var name: String?
    var residencyCode: String?
    var account: String?
    var bankCode: String?
    var bankName: String?
    var type: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        deleted <- map["deleted"]
        taxCode <- map["taxCode"]
        name <- map["name"]
        residencyCode <- map["residencyCode"]
        account <- map["account"]
        bankCode <- map["bankCode"]
        bankName <- map["bankName"]
        type <- map["type"]
    }
}

class DomesticTransferTemplate: BaseModel {
    var number: String?
    var templateName: String?
    var isTemplate: Bool?
    var created: String?
    //  var subType
    var payerName: String?
    var payerAccount: String?
    var receiverName: String?
    var receiverAccount: String?
    var amount: String?
    var purpose: String?
    var currency: String?
    var state: State?
    var actions: Actions?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        number <- map["number"]
        templateName <- map["templateName"]
        isTemplate <- map["isTemplate"]
        created <- map["created"]
        //  var subType
        payerName <- map["payerName"]
        payerAccount <- map["payerAccount"]
        receiverName <- map["receiverName"]
        receiverAccount <- map["receiverAccount"]
        amount <- map["amount"]
        purpose <- map["purpose"]
        currency <- map["currency"]
        state <- map["state"]
        actions <- map["actions"]
    }
}

class State: BaseModel {
    var category: String?
    var code: String?
    var label: String?
    var deleted: Bool?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        deleted <- map["deleted"]
        category <- map["category"]
        code <- map["code"]
        label <- map["label"]
    }
}

class DomesticTransferTemplateDescription: BaseModel {
    var templateName: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        templateName <- map["templateName"]
    }
}
public class ServerError: Mappable {
    var message: String?
    var description: String?
    var fieldErrors: [ServerFieldError]?
    
    required public init?(map: Map) {
        let keys = map.JSON.keys
        guard keys.contains("message"), keys.contains("description") else {
            return nil
        }
    }
    
    public func mapping(map: Map) {
        message <- map["message"]
        description <- map["description"]
        fieldErrors <- map["fieldErrors"]
    }
    
    public func messageForShow() -> String {
        if let description = self.description, !description.isEmpty {
            return description
        } else if let fieldErrors = self.fieldErrors, !fieldErrors.isEmpty {
            return fieldErrors
                .compactMap({ $0.message })
                .joined(separator: "\n")
        } else {
            return "Неизвестная ошибка сервера"
        }
    }
}

public class ServerFieldError: Mappable {
    var field: String?
    var objectName: String?
    var message: String?
    
    required public init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        field <- map["field"]
        objectName <- map["objectName"]
        message <- map["message"]
    }
}

extension DataResponse {
    public func getServerError() -> ServerError? {
        return self.data
            .flatMap({ String(data: $0, encoding: .utf8) })
            .flatMap({ ServerError(JSONString: $0) })
    }
}

class DocType: NSObject, Mappable {
    var id: String?
    var code: String?
    var label: String?
    var subCode: String?
    
    required init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        id <- map["id"]
        code <- map["code"]
        label <- map["label"]
        subCode <- map["subCode"]
    }
}
