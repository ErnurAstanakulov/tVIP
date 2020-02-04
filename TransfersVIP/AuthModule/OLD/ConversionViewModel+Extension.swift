//
//  ConversionViewModel+Extension.swift
//  DigitalBank
//
//  Created by Алем Утемисов on 09.05.2018.
//  Copyright © 2018 iosDeveloper. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

extension ConversionViewModel: OperationViewModelDataLoadable {
    
    func setupComponents() {
        
        // Local function
        func str(_ component: ConversionComponent) -> String { return component.rawValue }
        let optionsPlaceholder = "Выберите из списка"
        let textFieldPlaceholder = "Введите данные"
        let constraints = AppState.sharedInstance.config?.documents?.accountTransfer?.constraints
        components = [
            OperationComponent(type: ComponentType.searchTextField, name: ConversionComponent.template.rawValue, title: "Шаблоны", placeholder: optionsPlaceholder),
            .init(type: .textfield, name: str(.documentNumber), title: "Номер документа", placeholder: textFieldPlaceholder),
            OperationComponent(type: ComponentType.options, name: ConversionComponent.accountNumber.rawValue, title: "Счет списания", placeholder: optionsPlaceholder, constraints: constraints?.account),
            OperationComponent(type: ComponentType.amount, name: ConversionComponent.amount.rawValue, title: "Сумма списания", placeholder: textFieldPlaceholder, constraints: constraints?.debitSum, value: "0.00"),
            OperationComponent(type: ComponentType.switcher, name: ConversionComponent.fixAmount.rawValue, title: "Зафиксировать сумму", value: "true"),
            OperationComponent(type: ComponentType.options, name: ConversionComponent.receiverAccount.rawValue, title: "Счет зачисления", placeholder: optionsPlaceholder, constraints: constraints?.creditAccount),
            OperationComponent(type: ComponentType.amount, name: ConversionComponent.receiverAmount.rawValue, title: "Сумма зачисления", placeholder: textFieldPlaceholder, constraints: constraints?.creditSum, value: "0.00", uiProperties: [.isUserInteractionEnabled(false)]),
            OperationComponent(type: ComponentType.switcher, name: ConversionComponent.fixReceiverAmount.rawValue, title: "Зафиксировать сумму"),
            OperationComponent(type: ComponentType.amount, name: ConversionComponent.exchangeRate.rawValue, title: "Предварительный курс", placeholder: "0.00", uiProperties: [.isUserInteractionEnabled(false)]),
            OperationComponent(type: ComponentType.switcher, name: ConversionComponent.individualRate.rawValue, title: "Курс конвертации"),
            OperationComponent(type: ComponentType.label, name: ConversionComponent.executionRate.rawValue, title: "Курс исполнения"),
            OperationComponent(type: ComponentType.options, name: ConversionComponent.commissionAccount.rawValue, title: "Счет взимания комиссии", placeholder: optionsPlaceholder, constraints: constraints?.creditAccount),
            OperationComponent(type: ComponentType.options, name: ConversionComponent.valueDate.rawValue, title: "Дата валютирования", placeholder: optionsPlaceholder, constraints: constraints?.valueDate),
            OperationComponent(type: ComponentType.searchTextField, name: ConversionComponent.knp.rawValue, title: "КНП", placeholder: textFieldPlaceholder, constraints: constraints?.purposeCode),
            OperationComponent(type: ComponentType.label, name: ConversionComponent.descriptionKnp.rawValue, title: "Описание КНП", dependency: Dependency(name: ConversionComponent.knp.rawValue, condition: .visibility)),
            OperationComponent(type: ComponentType.options, name: ConversionComponent.dealPurpose.rawValue, title: "Цель сделки", placeholder: optionsPlaceholder, constraints: constraints?.purpose),
            OperationComponent(type: ComponentType.options, name: ConversionComponent.currencyContract.rawValue, title: "Валютный договор", placeholder: optionsPlaceholder),
            OperationComponent(type: ComponentType.date, name: ConversionComponent.contractDate.rawValue, title: "Дата договора", placeholder: optionsPlaceholder, uiProperties: [.isUserInteractionEnabled(false)]),
            OperationComponent(type: ComponentType.label, name: ConversionComponent.paymentPurpose.rawValue, title: "Назначение платежа", placeholder: optionsPlaceholder, constraints: constraints?.purpose, uiProperties: [.isMultiLineEnabled(true), .isUserInteractionEnabled(false)]),
            .init(type: .label, name: str(.bankResponse), title: "Сообщение из банка", isVisible: false),
            OperationComponent(type: .options, name: str(.director), title: "Руководитель", placeholder: optionsPlaceholder),
            OperationComponent(type: .options, name: str(.accountant), title: "Гл. бухгалтер", placeholder: optionsPlaceholder),
            OperationComponent(type: .textfield, name: ConversionComponent.info.rawValue, title: "Дополнительная информация", placeholder: textFieldPlaceholder),
            OperationComponent(type: .switcher, name: str(.executionRateAgreement), title: "Согласен и разрешаю уполномоченному банку применить при исполнении документа текущий курс конвертации (определенный Банком на момент проведения операции), который может отличаться от отображаемого в системе дистанционного банковского обслуживания курса на момент получения уполномоченным банком заявки на конвертацию")
        ]
        
        // Hide individualRate & executionRate component by default
        component(by: .individualRate).isVisible = false
        component(by: .executionRate).isVisible = false
    }
    
    func loadInitialData(onCompletion perform: @escaping (_ success: Bool, _ errorDescription: String?) -> Void) {
        
        let url = baseURL + "api/payment/account-transfer/source-field?fieldList=PURPOSES%2CPAYMENT_DATES%2CCOMPANY_PERSONS%2CKNP%2CACCOUNTS%2CFEE_ACCOUNTS%2CTEMPLATES%2CCONSTRAINTS%2CCUSTOMER%2COPERATION_TARGET%2CDOCUMENT_NUMBER"
        sessionManager.request(url, method: .get).responseJSON { (serverResponse) in
            log(serverResponse: serverResponse)

            guard let json = serverResponse.result.value as? [String: Any] else {
                let error = serverResponse.getServerError()
                perform(false, error?.messageForShow())
                return
            }
            let sourсeData = AccountTransfersDataSource(JSON: json)
            self.sourсeData = sourсeData
            perform(true, nil)
        }
    }
    
    func requestTemplate(withId id: Int, onCompletion perform: ((_ success: Bool, _ errorDescription: String?) -> Void)?) {
        let context = LoadAccountTransfersContext()
        context.ID = id.description
        context.execute(isSuccsess: { [weak self] (response) in
            guard let json = response as? [String: Any] else { perform?(false, nil); return }
            let document = AccountTransfersFullModel(JSON: json)
            self?.initialDocument = document
            perform?(true, nil)
        }) { (error) in
            if let serverError = error as? ContextError {
                perform?(false, serverError.errorDescription)
            } else {
                perform?(false, error?.localizedDescription)
            }
        }
    }
    
    func set(accountNumber: String?, balance: String?, type: AccountTransfersSelectedProductType) {
        switch type {
        case .from:
            component(by: .accountNumber).setValue(newValue: accountNumber)
            component(by: .accountNumber).description = balance
        case .to:
            component(by: .receiverAccount).setValue(newValue: accountNumber)
            component(by: .receiverAccount).description = balance
        }
    }
    
    func saveDocument(isTemplate: Bool, onCompletion perform: @escaping (_ success: Bool, _ errorMessage: String?) -> Void) {
        guard let document = conversionToSend else { return }
        let save = AccountTransfersSaveContext()
        document.isTemplate = isTemplate
        save.finalDocument = document
        save.documentID = initialDocument?.id
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
        sessionManager.request(url, method: .get).validate().responseString { [weak self] response in
            log(serverResponse: response)
            guard let documentNumber = response.result.value else { perform(false, response.error?.localizedDescription); return }
            self?.component(by: .documentNumber).setValue(newValue: documentNumber)
            perform(true, nil)
        }
    }
    
    func requestCurrencyContractInfo(currency: String, onCompletion perform: ((_ success: Bool, _ errorDescription: String?) -> Void)?) -> Bool {
        let url = "\(baseURL)api/frgnexchange/for-fortex-transfer?creditCurrency=\(currency)&status=1"
        sessionManager.request(url, method: .get).responseJSON { [unowned self] (response) in
            log(serverResponse: response)
            guard let json = response.result.value as? [AnyDict] else {
                perform?(false, response.error?.localizedDescription)
                return
            }
            
            let contracts = Mapper<ForeignExchangeContract>().mapArray(JSONArray: json)
            self.component(by: .currencyContract).clearValue()
            self.sourсeData?.currencyContracts = contracts
            self.currencyContracts = json.compactMap{ CurrencyContract(JSON: $0) }
            perform?(true, nil)
        }
        return true
    }
    
    public func getExchangeRateWithLoaded(amount: String, isReceivingAmount: Bool, onCompletion perform: ((_ success: Bool, _ errorDescription: String?) -> Void)?) -> Bool {
        let accountNumber = component(by: .accountNumber).value
        let receiverAccountNumber = component(by: .receiverAccount).value
        guard let accountDetails = sourсeData?.accountsViews?.first(where: { $0.number == accountNumber }),
            let receiverAccountDetails = sourсeData?.accountsViews?.first(where: { $0.number == receiverAccountNumber }),
            let fromCurrency = accountDetails.currency,
            let toCurrency = receiverAccountDetails.currency else { perform?(false, nil); return false }
        
        let url = baseURL + "api/exchange-rate/for-account-transfer"
        
        var parameters: [String: Any] = ["fromCurrency" : fromCurrency, "toCurrency" : toCurrency, "isAdd": isReceivingAmount, "amount": amount]
        if let valueDate = component(by: .valueDate).value {
            parameters["valueDate"] = valueDate
        }
        if self.component(by: .individualRate).getValue() == true {
            if let exchangeRate = component(by: .exchangeRate).value {
                parameters["individualRate"] = exchangeRate
            }
        }
        if fromCurrency == toCurrency {
            self.component(by: .exchangeRate).setValue(newValue: "1.0")
            perform?(true, nil)
            return false
        }
        sessionManager.request(url, parameters: parameters, encoding: URLEncoding.queryString).validate().responseJSON {
            [weak self] response in
            log(serverResponse: response)
            guard let exchangeModel = response.result.value as? [String : Any],
                let buy = exchangeModel["buy"] as? String,
                let amount = Double(buy),
                let rateBargain = exchangeModel["rateBargain"] as? String,
                let convertedValue = exchangeModel["convertedValue"] as? String else {
                    let errorMessage: String?
                    if let data = response.data,
                        let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? AnyDict,
                        let conversionError = jsonData?["description"] as? String {
                        errorMessage = conversionError
                    } else {
                        errorMessage = response.error?.localizedDescription
                    }
                    self?.component(by: .individualRate).isVisible = true
                    self?.component(by: .receiverAmount).setValue(newValue: 0.00)
                    self?.component(by: .exchangeRate).setValue(newValue: 0.00)
                    perform?(false, errorMessage)
                    return
            }
            self?.minAmount = amount
            
            let convertedAmount = Sum(convertedValue)
            
            if isReceivingAmount {
                if let convertedAmount = convertedAmount {
                    let formattedAmount = String(format: "%.2f", convertedAmount).splittedAmount
                    self?.component(by: .amount).setValue(newValue: formattedAmount)
                } else {
                    self?.component(by: .amount).setValue(newValue: convertedValue)
                }
            } else {
                if let convertedAmount = convertedAmount {
                    let formattedAmount = String(format: "%.2f", convertedAmount).splittedAmount
                    self?.component(by: .receiverAmount).setValue(newValue: formattedAmount)
                } else {
                    self?.component(by: .receiverAmount).setValue(newValue: convertedValue)
                }
            }
            if let exchangeRate = Sum(rateBargain) {
                let formattedExchangeRate = String(format: "%.2f", exchangeRate)
                self?.component(by: .exchangeRate).setValue(newValue: formattedExchangeRate)
            } else {
                self?.component(by: .exchangeRate).setValue(newValue: rateBargain)
            }
            
            if let amount = isReceivingAmount ? Sum(amount) : convertedAmount {
                if let amountThreshold = exchangeModel["amountThreshold"] as? String,
                    let thresholdAmount = Sum(amountThreshold) {
                    self?.checkThreshold(amount: amount, threshold: thresholdAmount)
                }
                if let amountBuy = exchangeModel["buy"] as? String,
                    let buyAmount = Sum(amountBuy) {
                    self?.checkBuy(amount: amount, buy: buyAmount, currency: fromCurrency)
                }
            }
            self?.component(by: .individualRate).isVisible = false
            perform?(true, nil)
        }
        return true
    }
    
    func setAdditionalInfo(using model:  ForeignExchangeContract) {
        if let conNumber = model.contractNumber, let conDate = model.contractDate {
            let info = conNumber + " от " + conDate
            self.component(by: .info).setValue(newValue: info)
        }
    }
    
    private func checkThreshold(amount: Sum, threshold: Sum) {
        if amount > threshold {
            self.component(by: .dealPurpose).constraints = BaseConstraint(isRequired: true)
        } else {
            self.component(by: .dealPurpose).constraints = BaseConstraint(isRequired: false)
            self.component(by: .dealPurpose).errorDescription = nil
        }
    }
    
    private func checkBuy(amount: Sum, buy: Sum, currency: String) {
        guard let residencyCode = self.sourсeData?.customerView?.residencyCode,
              let code = Int(residencyCode) else { return }
        
        if 11...18 ~= code && amount > buy &&
            currency == Constants.Сurrency.KZT {
            self.component(by: .info).constraints = BaseConstraint(isRequired: true)
        } else {
            self.component(by: .info).constraints = BaseConstraint(isRequired: false)
            self.component(by: .info).errorDescription = nil
        }
    }
    
    func loadPayDays(onCompletion perform: @escaping (_ success: Bool, _ errorDescription: String?) -> Void) {
        let url = baseURL + "api/documents/mobile/paydays?benefBankCode=&paymentType=MAX_VALUE_DAYS_CURRENCY_CONVERSION"
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
    
    func loadContracts(currency: String) {
        let url = baseURL + "api/frgnexchange/for-fortex-transfer?creditCurrency=\(currency)&status=1"
        sessionManager.request(url).responseJSON { [unowned self] response in
            if response.result.isSuccess && response.error == nil {
                guard let json = response.result.value as? [[String: Any]] else {
                    return
                }
                self.currencyContracts = json.compactMap{ CurrencyContract(JSON: $0) }
            }
        }
    }
}
