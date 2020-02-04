//
//  PensionPaymentViewModel.swift
//  DigitalBank
//
//  Created by Алем Утемисов on 09.05.2018.
//  Copyright © 2018 iosDeveloper. All rights reserved.
//

import Foundation

class PensionPaymentViewModel: SocialPaymentViewModel {
    
    override var keyPayDays: String { return "MAX_VALUE_DAYS_PENSION" }
    
    override func setEmployees() {
        component(by: .employees).setValue(newValue: employees.isEmpty ? nil : "Сотрудники выбраны")
        component(by: .employees).errorDescription = nil
        for employee in employees {
            employee._pension.subscribe(onNext: {[weak self, weak employee] (_) in
                guard  let self = self, let employee = employee else { return }
                let sum = self.calculateSumEmployees()
                self.component(by: .amount).setValue(newValue: sum.splittedAmount)
                employee.amount = Double(sum) ?? 0.0
            }).disposed(by: disposeBag)
        }
    }
    
    override var initialDocument: DomesticTransfer? {
        didSet {
            component(by: .documentNumber).setValue(newValue: initialDocument?.number)
            component(by: .accountNumber).setValue(newValue: initialDocument?.account?.number)
            let amountFormatter = AmountFormatter()
            component(by: .accountNumber).description = amountFormatter.string(for: initialDocument?.account?.plannedBalance ?? 0.0)
            component(by: .template).setValue(newValue: initialDocument?.templateName)
            component(by: .receiverName).setValue(newValue: initialDocument?.benefName)
            component(by: .iin).setValue(newValue: initialDocument?.benefTaxCode)
            component(by: .kbe).setValue(newValue: initialDocument?.benefResidencyCode)
            component(by: .receiverAccount).setValue(newValue: initialDocument?.benefAccount)
            component(by: .bankBik).setValue(newValue: initialDocument?.benefBankCode)
            component(by: .accountant).setValue(newValue: initialDocument?.accountant?.fullName)
            component(by: .director).setValue(newValue: initialDocument?.director?.fullName)
            if let bankName = initialDocument?.bankName {
                component(by: .bankName).setValue(newValue: bankName)
                component(by: .bankName).isVisible = true
            }
            component(by: .valueDate).setValue(newValue: initialDocument?.valueDate)
            component(by: .amount).setValue(newValue: String(format: "%2f", initialDocument?.amount ?? 0.00).splittedAmount)
            component(by: .paymentPurpose).setValue(newValue: initialDocument?.purpose)
            component(by: .knp).setValue(newValue: initialDocument?.purposeCode)
            component(by: .paymentType).setValue(newValue: initialDocument?.employeeTransferCategory)
            component(by: .period).setValue(newValue: initialDocument?.employeeTransferPeriod)
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
                newEmployee.pension = employee.amount
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
    
    override var domesticTransferToSend: DomesticTransferToSend? {
        let domesticTransferToSend = super.domesticTransferToSend
        domesticTransferToSend?.employeeTransferCategory = component(by: .paymentType).value
        return domesticTransferToSend
    }
    
    override var documentType: String {
        return "PensionContribution"
    }
    
    override var requisitesName: String {
        return "PENSION_COMPANY"
    }
    
    override func isEmployeesValid() -> String? {
        guard !employees.isEmpty else {
            return "Список сотрудников не заполнен"
        }
        for employee in employees {
            if employee.pension == 0.0 {
                return "Сумма для сотрудников не заполнена"
            }
        }
        return nil
    }
    
    override func dataSource(for component: OperationComponent) -> [OptionDataSource]? {
        guard let componenType = SocialPaymentComponent(rawValue: component.name) else { return nil }
        switch componenType {
        case .paymentType:
            guard let types = sourceData?.employeeTransferCategory else { return nil }
            return types.compactMap{ OptionDataSource(id: $0.code, title: $0.code, description: $0.label) }
        default:
            return super.dataSource(for: component)
        }
    }
    
    override func optionSelectedWithLoaded(_ value: OptionDataSource?, component: OperationComponent, completion: ((Bool, String?) -> Void)?) -> Bool {
        if self.component(by: .paymentType) == component {
            self.component(by: .paymentTypeDescription).setValue(newValue: value?.description)
            changeValueDependencies(component: component, to: value?.id.isEmpty == false)
        }
        if self.component(by: .knp) == component {
            let autoFillModel = self.autoFillByKnp?.filter { $0.paymentPurposeCode?.code == value?.id }.first
            self.setAutoFillComponentsByKnp(model: autoFillModel)
            self.component(by: .descriptionKnp).setValue(newValue: value?.description)
            self.component(by: .paymentPurpose).setValue(newValue: value?.description)
        }
        return super.optionSelectedWithLoaded(value, component: component, completion: completion)
    }
    
    override func setAutoFillComponentsByKnp(model: TransferEmployee?) {
        self.component(by: .receiverName).setValue(newValue: model?.name)
        self.component(by: .iin).setValue(newValue: model?.taxCode)
        self.component(by: .receiverAccount).setValue(newValue: model?.account)
        self.component(by: .bankBik).setValue(newValue: model?.bankCode)
        self.component(by: .paymentTypeDescription).setValue(newValue: model?.pensionCnType?.name)
        self.component(by: .paymentType).setValue(newValue: model?.pensionCnType?.code)
        changeValueDependencies(component: self.component(by: .paymentType), to: model?.pensionCnType?.code?.isEmpty == false)
        self.component(by: .kbe).setValue(newValue: model?.residencyCode)
        self.component(by: .bankName).setValue(newValue: model?.bankName)
    }
    
    override func setupComponents() {
        func str(_ component: SocialPaymentComponent) -> String { return component.rawValue }
        let optionsPlaceholder = "Выберите из списка"
        let textFieldPlaceholder = "Введите данные"
        let constraints = AppState.sharedInstance.config?.documents?.domesticTransfer?.pensionContribution?.constraints
        
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
                title: "КНП", placeholder: textFieldPlaceholder,
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
                placeholder: textFieldPlaceholder,
                dependency: Dependency(
                    name: SocialPaymentComponent.bankBik.rawValue,
                    condition: .visibility)
            ),
            .init(
                type: ComponentType.switcher,
                name: SocialPaymentComponent.urgentPayment.rawValue,
                title: "Срочный платеж"
            ),
            .init(
                type: ComponentType.options,
                name: SocialPaymentComponent.paymentType.rawValue,
                title: "Тип отчисления",
                placeholder: optionsPlaceholder
            ),
            .init(
                type: ComponentType.label,
                name: SocialPaymentComponent.paymentTypeDescription.rawValue,
                title: "Наименование отчисления",
                dependency: Dependency(
                    name: SocialPaymentComponent.paymentType.rawValue,
                    condition: .visibility
                ),
                isVisible: false),
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
                placeholder: "Считается автоматически",
                constraints: constraints?.amount
            ),
            .init(
                type: ComponentType.label,
                name: SocialPaymentComponent.descriptionKnp.rawValue,
                title: "Описание КНП",
                dependency: Dependency(
                    name: SocialPaymentComponent.knp.rawValue,
                    condition: .visibility
                )
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
                constraints: constraints?.director),
            .init(
                type: .options,
                name: str(.accountant),
                title: "Гл. бухгалтер",
                placeholder: optionsPlaceholder
            )
        ]
    
    }
    
    override var initialDataUrl: String {
        return baseURL + "api/payment/domestic-transfer/source-field?fieldList=ACCOUNTS%2CCOMPANY_PERSONS%2CSUBSIDIARY_CUSTOMER%2CPAYMENT_DATES%2CKNP%2CPURPOSES%2CEMPLOYEE_TRANSFER_CATEGORIES%2CTEMPLATES%2CCONSTRAINTS%2CCUSTOMER%2CDOCUMENT_NUMBER%2CPENSION_COMPANY&domesticTransferType=PensionContribution"
    }
    
}
