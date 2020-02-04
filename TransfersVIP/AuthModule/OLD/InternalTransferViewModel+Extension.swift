//
//  InternalTransferViewModel+Extension.swift
//  DigitalBank
//
//  Created by Алем Утемисов on 09.05.2018.
//  Copyright © 2018 iosDeveloper. All rights reserved.
//

import Foundation

extension InternalTransferViewModel: OperationViewModelDataLoadable {        
    
    public func loadInitialData(onCompletion perform: @escaping (_ success: Bool, _ errorDescription: String?) -> Void) {
        let url = baseURL + "api/payment/domestic-transfer/source-field?fieldList=PURPOSES%2CPAYMENT_DATES%2CCOMPANY_PERSONS%2CKNP%2CACCOUNTS%2CFEE_ACCOUNTS%2CTEMPLATES%2CCONSTRAINTS%2CCOUNTERPARTIES%2CKBE%2CCUSTOMER%2CDOCUMENT_NUMBER&domesticTransferType=OwnAccountTransfer"
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
            
            perform(true, nil)
        }
    }
    
    func requestTemplate(withId id: Int, onCompletion perform: ((_ success: Bool, _ errorDescription: String?) -> Void)?) {
        let context = LoadAccountTransfersContext()
        context.ID = id.description
        context.execute(isSuccsess: { [weak self] (response) in
            guard let json = response as? [String: Any] else { perform?(false, nil); return }
            self?.initialDocument = DomesticTransfer(JSON: json)
            perform?(true, nil)
        }) { (error) in
            perform?(false, error?.localizedDescription)
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
    
    func set(accountNumber: String?, balance: String? = nil, type: AccountTransfersSelectedProductType) {
        
        let internalTransferComponent: InternalTransferComponent
        switch type {
        case .from:
            internalTransferComponent = .accountNumber
        case .to:
            internalTransferComponent = .enrollAccountNumber
        }
        
        component(by: internalTransferComponent).setValue(newValue: accountNumber)
        
        let description: String
        if let balance = balance {
            description = balance
        } else {
            guard let accountViews = sourceData?.accountViews,
                  let accountView = accountViews.first(where: { $0.number == accountNumber }),
                  let plannedBalance = accountView.plannedBalance,
                  let currency = accountView.currency else {
                return
            }
            description = String(plannedBalance) + " " + currency
        }
        
        component(by: internalTransferComponent).description = description
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
    
    func loadPayDays(onCompletion perform: @escaping (_ success: Bool, _ errorDescription: String?) -> Void) {
        let url = baseURL + "api/documents/mobile/paydays?benefBankCode=&paymentType=MAX_VALUE_DAYS_OWN_ACCOUNT_TRANSFER"
        sessionManager.request(url, method: .get).validate().responseJSON { [unowned self] response in
            log(serverResponse: response)
            if response.result.isSuccess && response.error == nil {
                guard let json = response.result.value as? [String: Any] else {
                    perform(false, response.error?.localizedDescription)
                    return
                }
                guard let days = json["payDays"]  as? [String] else {
                    perform(false, response.error?.localizedDescription)
                    return
                }
                self.payDays = days.map { fromServerDate($0) ?? $0 }
                perform(true, nil)
                return
                
            } else {
                perform(false, response.error?.localizedDescription)
                return
            }
        }
    }
}
