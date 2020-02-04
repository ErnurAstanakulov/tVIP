//
//  InternationalTransferViewModel+Extension.swift
//  DigitalBank
//
//  Created by Алем Утемисов on 09.05.2018.
//  Copyright © 2018 iosDeveloper. All rights reserved.
//

import Foundation
import ObjectMapper

extension InternationalTransferViewModel: OperationViewModelDataLoadable {
    func setupComponents() {
        // Local function
        func str(_ component: InternationalTransferComponent) -> String { return component.rawValue }
        
        let optionsPlaceholder = "Выберите из списка"
        let textFieldPlaceholder = "Введите данные"
        let pickDatePlaceholder = "Выберите дату"
        let constraints = AppState.sharedInstance.config?.documents?.internatTransfer?.constraints
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
                placeholder: textFieldPlaceholder,
                constraints: constraints?.number
            ),
            .init(
                type: .textfield,
                name: str(.intlAddress),
                title: "Адрес отправителя",
                placeholder: textFieldPlaceholder
            ),
            .init(
                type: .options,
                name: str(.accountCurrency),
                title: "Валюта",
                placeholder: optionsPlaceholder,
                constraints: constraints?.accountCurrency
            ),
            .init(
                type: .switcher,
                name: str(.transliterate),
                title: "Транслитерация",
                isVisible: false,
                uiProperties: [.isUserInteractionEnabled(false)]
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
                name: str(.receiverName),
                title: "Наименование получателя",
                placeholder: textFieldPlaceholder,
                constraints: constraints?.benefName
            ),
            .init(
                type: .searchTextField,
                name: str(.iin),
                title: "БИН/ИИН/ИНН получателя",
                placeholder: textFieldPlaceholder
            ),
            .init(
                type: .searchTextField,
                name: str(.countryCode),
                title: "Код страны Резиденства",
                placeholder: textFieldPlaceholder,
                constraints: constraints?.benefCountryCode
            ),
            .init(
                type: .label,
                name: str(.country),
                title: "Страна Резиденства",
                isVisible: false
            ),
            .init(
                type: .textfield,
                name: str(.city),
                title: "Страна, город",
                placeholder: textFieldPlaceholder,
                constraints: constraints?.benefCity
            ),
            .init(
                type: .textfield,
                name: str(.address),
                title: "Адрес",
                placeholder: textFieldPlaceholder,
                constraints: constraints?.benefAddress
            ),
            .init(
                type: .searchTextField,
                name: str(.kbe),
                title: "КБЕ получателя",
                placeholder: textFieldPlaceholder,
                constraints: constraints?.benefResidencyCode
            ),
            .init(
                type: .label,
                name: str(.descriptionKbe),
                title: "Наименование КБЕ",
                dependency: Dependency(
                    name: str(.kbe),
                    condition: .visibility),
                isVisible: false
            ),
            .init(
                type: .textfield,
                name: str(.kpp),
                title: "КПП",
                placeholder: textFieldPlaceholder,
                isVisible: false
            ),
            .init(
                type: .searchTextField,
                name: str(.receiverAccount),
                title: "Счет получателя",
                placeholder: textFieldPlaceholder,
                constraints: constraints?.benefAccount
            ),
            .init(
                type: .searchTextField,
                name: str(.receiverBankBik),
                title: "БИК/SWIFT банка получателя",
                placeholder: textFieldPlaceholder,
                constraints: constraints?.benefBankCode
            ),
            .init(
                type: .label,
                name: str(.receiverBankName),
                title: "Наименование банка получателя",
                dependency: Dependency(
                    name: str(.receiverBankBik),
                    condition: .visibility),
                isVisible: false),
            .init(
                type: .textfield,
                name: str(.receiverCorrespondentAccount),
                title: "Корреспондентский счет банка получателя",
                placeholder: textFieldPlaceholder
            ),
            .init(
                type: .label,
                name: str(.receiverBankCountryCode),
                title: "Код страны",
                isVisible: false
            ),
            .init(
                type: .label,
                name: str(.receiverBankCountry),
                title: "Страна",
                isVisible: false
            ),
            .init(
                type: .label,
                name: str(.receiverBankCity),
                title: "Город",
                isVisible: false
            ),
            .init(
                type: .label,
                name: str(.receiverBankAddress),
                title: "Адрес",
                isVisible: false
            ),
            .init(
                type: .searchTextField,
                name: str(.agentBankBik),
                title: "БИК/SWIFT банка посредника",
                placeholder: textFieldPlaceholder,
                constraints: constraints?.agentBankCode
            ),
            .init(
                type: .label,
                name: str(.agentBankName),
                title: "Наименование банка посредника",
                dependency: Dependency(
                    name: str(.agentBankBik),
                    condition: .visibility)
            ),
            .init(
                type: .textfield,
                name: str(.agentCorrespondentAccount),
                title: "Корреспондентский счет банка посредника",
                placeholder: textFieldPlaceholder
            ),
            .init(
                type: .label,
                name: str(.agentBankCountryCode),
                title: "Код страны",
                isVisible: false
            ),
            .init(
                type: .label,
                name: str(.agentBankCountry),
                title: "Страна",
                isVisible: false
            ),
            .init(
                type: .label,
                name: str(.agentBankCity),
                title: "Город",
                isVisible: false
            ),
            .init(
                type: .label,
                name: str(.agentBankAddress),
                title: "Адрес",
                isVisible: false
            ),
            .init(
                type: .options,
                name: str(.valueDate),
                title: "Дата валютирования",
                placeholder: optionsPlaceholder,
                constraints: constraints?.valueDate
            ),
            .init(
                type: .amount,
                name: str(.amount),
                title: "Сумма",
                placeholder: textFieldPlaceholder,
                constraints: constraints?.amount
            ),
            .init(
                type: .searchTextField,
                name: str(.VOCode),
                title: "Код VO",
                placeholder: optionsPlaceholder,
                isVisible: false
            ),
            .init(
                type: .options,
                name: str(.contractNumber),
                title: "Контракт",
                placeholder: optionsPlaceholder,
                constraints: constraints?.contractNumber
            ),
            .init(
                type: .date,
                name: str(.contractDate),
                title: "Дата контракта",
                placeholder: pickDatePlaceholder,
                uiProperties: [.isUserInteractionEnabled(false)]
            ),
            .init(
                type: .textfield,
                name: str(.contractConsideredNumber),
                title: "УНВД",
                placeholder: textFieldPlaceholder,
                constraints: constraints?.contractAuditNumber,
                uiProperties: [.isUserInteractionEnabled(false)]
            ),
            .init(
                type: .date,
                name: str(.contractConsideredDate),
                title: "Дата учетного номера контракта",
                placeholder: pickDatePlaceholder,
                uiProperties: [.isUserInteractionEnabled(false)]
            ),
            .init(
                type: .textfield,
                name: str(.invoice),
                title: "Инвойс/счет",
                placeholder: textFieldPlaceholder
            ),
            .init(
                type: .date,
                name: str(.invoiceDate),
                title: "Дата инвойса/счета",
                placeholder: pickDatePlaceholder
            ),
            .init(
                type: .options,
                name: str(.commissionType),
                title: "Тип комиссии",
                placeholder: optionsPlaceholder,
                constraints: constraints?.feeTypeCode
            ),
            .init(
                type: .label,
                name: str(.commissionTypeName),
                title: "Описание комиссии",
                dependency: Dependency(
                    name: str(.commissionType),
                    condition: .visibility)),
            .init(
                type: .searchTextField,
                name: str(.commissionAccount),
                title: "Счет взимания комиссии",
                placeholder: textFieldPlaceholder,
                constraints: constraints?.feeAccount
            ),
            .init(
                type: .searchTextField,
                name: str(.knp),
                title: "КНП",
                placeholder: textFieldPlaceholder,
                constraints: constraints?.purposeCode
            ),
            .init(
                type: .label,
                name: str(.descriptionKnp),
                title: "Описание КНП",
                dependency: Dependency(
                    name: str(.knp),
                    condition: .visibility),
                constraints: nil
            ),
            .init(
                type: .searchTextField,
                name: str(.kvo),
                title: "КВО",
                placeholder: textFieldPlaceholder,
                constraints: nil
            ),
            .init(
                type: .label,
                name: str(.descriptionKvo),
                title: "Описание КВО",
                dependency: Dependency(
                    name: str(.kvo),
                    condition: .visibility),
                constraints: nil
            ),
            .init(
                type: .textfield,
                name: str(.paymentPurposeInfo),
                title: "Назначение платежа",
                placeholder: textFieldPlaceholder,
                constraints: constraints?.purpose
            ),
            .init(
                type: .label,
                name: str(.paymentPurpose),
                title: "70: ДЕТАЛИ ПЛАТЕЖА",
                placeholder: "",
                constraints: nil,
                uiProperties: [.isUserInteractionEnabled(false), .isMultiLineEnabled(true)]
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
                title: "Сообщение из банка",
                isVisible: false
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
            ),
            .init(
                type: .switcher,
                name: str(.noTerror),
                title: "Подтверждаю, что данный платеж и (или) перевод денег не связан с финансированием террористической или экстремистской деятельности и иным пособничеством терроризму либо экстремизму.",
                isVisible: false
            ),
            .init(
                type: .switcher,
                name: str(.noUnc),
                title: "Подтверждаю, что данный платеж и (или) перевод денег не связан с осуществлением физическим лицом валютной операции, требующей получения регистрационного свидетельства, свидетельства об уведомлении, учетного номера контракта.",
                isVisible: false
            ),
            .init(
                type: .switcher,
                name: str(.isPermitGiveInformation),
                title: "Разрешаю уполномоченному банку представление информации о данном платеже и (или) переводе денег в правоохранительные органы Республики Казахстан и Национальный Банк по их требованию.",
                isVisible: false
            ),
            .init(
                type: .options,
                name: str(.codeTypeOperation),
                title: "Код типа операции",
                placeholder: optionsPlaceholder,
                constraints: nil,
                isVisible: false
            ),
            .init(
                type: .textfield,
                name: str(.number4),
                title: "N4",
                placeholder: textFieldPlaceholder,
                constraints: nil,
                isVisible: false
            ),
            .init(
                type: .textfield,
                name: str(.number5),
                title: "N5",
                placeholder: textFieldPlaceholder,
                constraints: nil,
                isVisible: false
            ),
            .init(
                type: .options,
                name: str(.number6),
                title: "N6",
                placeholder: optionsPlaceholder,
                constraints: nil,
                isVisible: false
            ),
            .init(
                type: .textfield,
                name: str(.number7),
                title: "N7",
                placeholder: "XX.ММ.ГГГГ",
                constraints: nil,
                isVisible: false
            ),
            .init(
                type: .textfield,
                name: str(.number8),
                title: "N8",
                placeholder: textFieldPlaceholder,
                constraints: nil,
                isVisible: false
            ),
            .init(
                type: .date,
                name: str(.number9),
                title: "N9",
                placeholder: pickDatePlaceholder,
                isVisible: false
            ),
            .init(
                type: .options,
                name: str(.number10),
                title: "N10",
                placeholder: optionsPlaceholder,
                constraints: nil,
                isVisible: false
            )
        ]
    }
    
    public func loadInitialData(onCompletion perform: @escaping (_ success: Bool, _ errorDescription: String?) -> Void) {
        let url = baseURL + "api/payment/international-transfer/source-field?fieldList=ACCOUNTS%2CCOMPANY_PERSONS%2CCOUNTERPARTIES%2CFEE_ACCOUNTS%2CKNP%2CPURPOSES%2CKBE%2CFEE_TYPES%2CCOUNTRIES%2CCURRENCY_OPERATION_TYPES%2CTEMPLATES%2CCONSTRAINTS%2CKVO%2CCUSTOMER%2CDOCUMENT_NUMBER%2CUPLOAD_CONSTRAINTS%2CTRANSFER_RUB_CODE_OPERATIONS%2CTAX_DOCUMENT_TYPES%2CBASIS_TAX_PAYMENTS"
        sessionManager.request(url, method: .get).responseJSON {[weak self] (serverResponse) in
            log(serverResponse: serverResponse)
            guard let self = self else {
                return
            }
            
            guard let dictionary = serverResponse.result.value as? [String: Any],
                serverResponse.result.isSuccess && serverResponse.error == nil else {
                    perform(false, serverResponse.getServerError()?.messageForShow() ?? serverResponse.error?.localizedDescription)
                    return
            }
            
            let sourсeData = InternationalTransferDataSource(JSON: dictionary)
            self.sourceData = sourсeData
            
            let dispatchGroup = DispatchGroup()
            var isSuccess: Bool = true
            var errorDescription: String? = nil
            
            let completion: (_ success: Bool, _ errorDescription: String?) -> Void = { (success, errorMessage) in
                if !success {
                    isSuccess = false
                    errorDescription = errorMessage
                }
                dispatchGroup.leave()
            }
            
            if let isTemplate = self.initialDocument?.isTemplate, isTemplate {
                dispatchGroup.enter()
                self.loadPayDays(onCompletion: completion)
            }
            
            dispatchGroup.enter()
            self.loadCurrencyOperationLimit(onCompletion: completion)
            
            dispatchGroup.enter()
            self.loadBankBikTransactionLimitConsts(onCompletion: completion)
            
            perform(isSuccess, errorDescription)
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
                    perform(false, serverResponse.getServerError()?.messageForShow() ?? serverResponse.error?.localizedDescription)
                    return
            }
            
            self.currencyOperationLimit = Double((dictionary["value"] as? String) ?? "0")
            perform(true, nil)
        }
    }
    
    func requestTemplate(withId id: Int, onCompletion perform: ((_ success: Bool, _ errorDescription: String?) -> Void)?) {
        let context = LoadInternationalTransferContext()
        context.ID = id.description
        context.execute(isSuccsess: { [weak self] (response) in
            guard let json = response as? [String: Any],
                let template = InternationalTransfer(JSON: json)
                else { perform?(false, nil); return }
            self?.initialDocument = template
            if (template.account?.currency) != nil {
                self?.loadPayDays(onCompletion: perform)
            } else {
                perform?(true, nil)
            }
            
        }) { (error) in
            if let serverError = error as? ContextError {
                perform?(false, serverError.errorDescription)
            } else {
                perform?(false, error?.localizedDescription)
            }
        }
    }
    
    func loadBankBikTransactionLimitConsts(onCompletion perform: @escaping (_ success: Bool, _ errorDescription: String?) -> Void) {
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
    
    func convertAmountToUSD(_ amount: Double?, _ currency: String?, _ completion: @escaping (Double?) -> Void) {
        guard let amount = amount, let currency = currency else {
            completion(nil)
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
                    completion(nil)
                    return
            }
        
            guard let exchangeRate = CurrencyExchangeRate(JSON: dictionary) else {
                completion(nil)
                return
            }
            
            completion(self.convertAmount(amount, exchangeRate))
        }
    }
    
    private func convertAmount(_ amount: Double, _ exchangeRate: CurrencyExchangeRate) -> Double? {
        guard let currencyNbrkRate = exchangeRate.currencyNbrkRate,
            let usdNbrkRate = exchangeRate.usdNbrkRate else {
                return nil
        }
        return (amount * currencyNbrkRate) / usdNbrkRate
    }
    
    func saveDocument(isTemplate: Bool, onCompletion perform: @escaping (_ success: Bool, _ errorMessage: String?) -> Void) {
        let save = SaveInternationalTransferContext()
        save.documentID = initialDocument?.id
        save.finalDocument = transferToSend
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
    
    func set(accountNumber: String?, balance: String?, completion: Completion?) {
        // If account found among accounts backend sends us, then we load payment days according to the currency of the account and if the currency is RUB we should set VOCode and KPP fields to visible state, and also set currency and accountNumber to their components
        // And account is not found among accounts then we will just set account number, complete with success
        if let account = sourceData?.foreignAccountViews?.first(where: { $0.number == accountNumber }) {
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
                
                dispatchGroup.enter()
                loadCurrencyContractInfo(byCurrencyId: currency) { success, message in
                    if !success {
                        isSuccess = false
                    }
                    errorMessage = message
                    dispatchGroup.leave()
                }
            }
            dispatchGroup.notify(queue: .main) {
                completion?(isSuccess, errorMessage)
            }
            let currencyIsRUB = account.currency?.uppercased().contains(Constants.Сurrency.RUB) == true
            component(by: .VOCode).isVisible = currencyIsRUB
            component(by: .kpp).isVisible = currencyIsRUB
            component(by: .accountCurrency).setValue(newValue: account.currency)
            component(by: .accountNumber).description = balance
            component(by: .accountNumber).setValue(newValue: accountNumber)
            
            if currencyIsRUB {
                self.accountFromDepositRUB = accountNumber
            }
        
        } else {
            component(by: .accountNumber).setValue(newValue: accountNumber)
            component(by: .accountNumber).description = balance
            completion?(true, nil)
        }
    }
    
    func set(contractNumber: String?, contractDate: String?, contractConsideredNumber: String?, contractConsideredDate: String?) {
        component(by: .contractNumber).setValue(newValue: contractNumber)
        component(by: .contractDate).setValue(newValue: contractDate)
        component(by: .contractConsideredNumber).setValue(newValue: contractConsideredNumber)
        component(by: .contractConsideredDate).setValue(newValue: contractConsideredDate)
    }
    
    func loadBankSwifts(isNumeric: Bool = false, bik: String, optionsDataSourceCallback: (([OptionDataSource]) -> Void)?) {
        let context = LoadBankSwiftsContext()
        context.search = bik
        context.isNumeric = isNumeric
        context.execute(isSuccsess: { (responce) in
            guard let json = responce as? [String: Any] else { return }
            guard let rows = json["rows"] as? [[String: Any]] else { return }
            var bankSwifts = [BankSwift]()
            for bankSwiftJSON in rows {
                BankSwift(JSON: bankSwiftJSON).map{ bankSwifts.append($0) }
            }
            let dataSource = bankSwifts.compactMap { OptionDataSource(id: $0.id.description, title: $0.bik, description: $0.name) }
            optionsDataSourceCallback?(dataSource)
        }) { error in
            optionsDataSourceCallback?([])
        }
    }
    
    func loadBankInfo(id: Int?, onCompletion perform: ((InternationalBank?, Bool, String?) -> Void)?) {
        let context = LoadBankContext()
        context.bankID = id
        context.execute(isSuccsess: { (response) in
            guard let json = response as? [String: Any],
                let bank = InternationalBank(JSON: json)
                else { perform?(nil, false, nil); return }
            perform?(bank, true, nil)
        }) { (error) in
            if let serverError = error as? ContextError {
                perform?(nil, false, serverError.errorDescription)
            } else {
                perform?(nil, false, error?.localizedDescription)
            }
        }
    }
    
    func requestCurrencyContractInfo(currency: String, onCompletion perform: @escaping (_ success: Bool, _ errorDescription: String?) -> Void) {
        let url = "\(baseURL)api/frgnexchange/for-currency-transfer?creditCurrency=\(currency)"
        sessionManager.request(url, method: .get).responseJSON { [unowned self] (response) in
            log(serverResponse: response)
            guard let json = response.result.value as? [AnyDict] else {
                perform(false, response.error?.localizedDescription)
                return
            }
            
            self.currencyContracts = json.compactMap { InternationalCurrencyContract(JSON: $0) }
            perform(true, nil)
        }
    }
    
    func requestExchangeRate(currency: String, onCompletion perform: @escaping (_ success: Bool, _ errorDescription: String?) -> Void) {
        let url = "\(baseURL)api/exchange-rate/amount/\(currency)/detail"
        sessionManager.request(url, method: .get).responseJSON { [unowned self]
            (response) in
            log(serverResponse: response)
            guard let json = response.result.value as? AnyDict else {
                perform(false, response.error?.localizedDescription)
                return
            }
            guard let currencyLimitConst = json["currency_limit_const"] as? Double else {
                perform(false, "cannot convert currency_limit_const")
                return
            }
            self.currencyLimitConst = currencyLimitConst
            perform(true, nil)
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
    
    func loadFeeTypes(currency: String, onCompletion perform: ((Bool, String?) -> Void)?) {
        let url = "\(baseURL)api/payment/international-transfer/get-commission-type?currency=" + currency
        sessionManager.request(url, method: .get).validate().responseJSON { [unowned self] (response) in
            log(serverResponse: response)
            guard let json = response.result.value as? [AnyDict] else {
                perform?(false, response.error?.localizedDescription)
                return
            }
            let feeTypes = json.compactMap { FeeType(JSON: $0) }
            self.sourceData?.feeTypes = feeTypes
            perform?(true, nil)
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

    func loadPayDays(onCompletion perform: ((_ success: Bool, _ errorDescription: String?) -> Void)?) {
        let url = baseURL + "api/documents/mobile/paydays?benefBankCode=&paymentType=MAX_VALUE_DAYS_INTERNATIONAL_TRANSFER"
        sessionManager.request(url, method: .get).validate().responseJSON { [unowned self] response in
            log(serverResponse: response)
            if response.result.isSuccess && response.error == nil {
                guard let json = response.result.value as? [String: Any] else {
                    perform?(false, "there is an error with json file")
                    return
                }
                guard let days = json["payDays"]  as? [String] else {
                    perform?(false, "there is an error with json file")
                    return
                }
                
                self.payDays = days.map { fromServerDate($0) ?? $0 }
                perform?(true, nil)
                return
                
            } else {
                perform?(false, response.error?.localizedDescription)
                return
            }
        }
    }
}
