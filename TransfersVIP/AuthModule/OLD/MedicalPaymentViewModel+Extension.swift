//
//  MedicalPaymentViewModel.swift
//  DigitalBank
//
//  Created by Zhalgas Baibatyr on 23.05.2018.
//  Copyright © 2018 InFin-It Solutions. All rights reserved.
//

extension MedicalPaymentViewModel: OperationViewModelDataLoadable, SocialAutoFillDataLoadable {
    
    func requestAutofillByKnp(onCompletion perform: @escaping (_ success: Bool, _ errorMessage: String?) -> Void) {
        let url = "\(baseURL)api/transfer-employee-requisites?page=0&size=1000&sort=id&order=asc"
        sessionManager.request(url, method: .get).validate().responseJSON { [weak self] serverResponse in
            log(serverResponse: serverResponse)
            guard let dictionary = serverResponse.result.value as? [String: Any],
                let rows = dictionary["rows"] as? [[String: Any]],
                serverResponse.result.isSuccess && serverResponse.error == nil else {
                    perform(false, serverResponse.getServerError()?.messageForShow() ?? serverResponse.error?.localizedDescription)
                    return
            }
            
            let results: [TransferEmployee] = rows.compactMap { TransferEmployee(JSON: $0) }
            self?.autoFillByKnp = results
            perform(true, nil)
        }
    }

	var initialDataUrl: String {
		let fieldList = ["ACCOUNTS", "COMPANY_PERSONS", "CUSTOMER", "DOCUMENT_NUMBER", "KNP", "MEDICAL_INSURANCE_CATEGORIES", "MEDICAL_INSURANCE_COMPANY", "PAYMENT_DATES", "PURPOSES", "TEMPLATES", "SUBSIDIARY_CUSTOMER"]
        let url = baseURL + "api/payment/domestic-transfer/source-field?" +
                  "domesticTransferType=" + documentType + "&" +
                  "fieldList=" + fieldList.joined(separator: "%2C")
        return url
    }
    
    func set(accountNumber: String?, balance: String?) {
        component(by: .accountNumber).setValue(newValue: accountNumber)
        component(by: .accountNumber).description = balance
    }

    public func loadInitialData(onCompletion perform: @escaping (_ success: Bool, _ errorDescription: String?) -> Void) {
        sessionManager.request(initialDataUrl, method: .get).responseJSON {[weak self] (serverResponse) in
            log(serverResponse: serverResponse)

            guard let dictionary = serverResponse.result.value as? [String: Any],
                serverResponse.result.isSuccess && serverResponse.error == nil else {
                perform(false, serverResponse.getServerError()?.messageForShow() ?? serverResponse.error?.localizedDescription)
                return
            }
            let sourceData = DomesticTransferSourсeData(JSON: dictionary)
            if let jsonRequisites = dictionary[self?.requisitesName ?? ""] as? [String: Any] {
                sourceData?.transferRequisites = TransferRequisites(JSON: jsonRequisites)
            }
            if let jsonMedicalInsuranceCategories = dictionary[self?.medicalInsuranceCategoryName ?? ""] as? [[String: Any]] {
                sourceData?.employeeTransferCategory = jsonMedicalInsuranceCategories.compactMap { EmployeeTransferCategory(JSON: $0) }
            }
            self?.sourceData = sourceData
            self?.requestAutofillByKnp(onCompletion: perform)
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
    
    func loadPayDays(onCompletion perform: @escaping (_ success: Bool, _ errorDescription: String?) -> Void) {
        let url = baseURL + "api/documents/mobile/paydays?benefBankCode=&paymentType=MAX_VALUE_DAYS_MEDICAL"
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

    func saveDocument(isTemplate: Bool, onCompletion perform: @escaping (_ success: Bool, _ errorMessage: String?) -> Void) {
        guard let document = domesticTransferToSend else { return }
        document.isTemplate = isTemplate
        let save = SaveDomesticTransferContext()
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

    func isEmployeesValid() -> String? {
        guard !employees.isEmpty else {
            return "Список сотрудников не заполнен"
        }
        for employee in employees {
            if employee.medical == 0.0 {
                return "Сумма для сотрудников не заполнена"
            }
        }
        return nil
    }
}
