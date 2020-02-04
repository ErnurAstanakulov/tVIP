//
//  SocialPaymentViewModel+Extensions.swift
//  DigitalBank
//
//  Created by Алем Утемисов on 09.05.2018.
//  Copyright © 2018 iosDeveloper. All rights reserved.
//

import Foundation

protocol SocialAutoFillDataLoadable {
    var autoFillByKnp: [TransferEmployee]? { get }
    func requestAutofillByKnp(onCompletion perform: @escaping (_ success: Bool, _ errorMessage: String?) -> Void)
    func setAutoFillComponentsByKnp(model: TransferEmployee?)
}

extension SocialPaymentViewModel: OperationViewModelDataLoadable, SocialAutoFillDataLoadable {
    
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
            self?.sourceData = sourceData
            self?.requestAutofillByKnp(onCompletion: perform)
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
    
    func saveDocument(isTemplate: Bool, onCompletion perform: @escaping (_ success: Bool, _ errorMessage: String?) -> Void) {
        guard let document = domesticTransferToSend else { return }
        document.isTemplate = isTemplate
        let save = SaveDomesticTransferContext()
        save.finalDocument = document
        save.documentID = initialDocument?.id
        if isTemplate && initialDocument?.id != nil {
            save.reSaveTemplate = true
        }

        save.execute(isSuccsess: {(response) in
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
    
    func loadPayDays(onCompletion perform: @escaping (_ success: Bool, _ errorDescription: String?) -> Void) {
        let url = baseURL + "api/documents/mobile/paydays?benefBankCode=&paymentType=\(keyPayDays)"
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
