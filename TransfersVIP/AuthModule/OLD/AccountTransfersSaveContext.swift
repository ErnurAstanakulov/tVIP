//
//  AccountTransfersSaveContext.swift
//  DigitalBank
//
//  Created by Misha Korchak on 11.04.17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import Alamofire

class AccountTransfersSaveContext: Context {
    public var finalDocument: AccountTransfersToSend!
    public var documentID: Int?
    public var reSaveTemplate = false
    
    override func urlString() -> String {
        guard let id = self.documentID else {
            return baseURL + "api/payment/account-transfer/new"
        }
        
        if finalDocument.isTemplate == true {
            if reSaveTemplate {
                return baseURL + "api/payment/account-transfer/\(id)"
            } else {
                return baseURL + "api/payment/account-transfer/new"
            }
        }
        
        return baseURL + "api/payment/account-transfer/\(id)"
    }
    
    public override func parametres() -> [String: Any]? {
        guard let body = self.finalDocument else { return nil }
        // КОСТЫЛЬ begin
        //SESC: in tamplate purposeCode canNot be empty
        if finalDocument?.isTemplate == true {
            if finalDocument?.purposeCode?.isEmpty == true {
                body.purposeCode = nil
            }
            if finalDocument.account == nil {
                finalDocument.account = EmptyAccountView()
            }
            if finalDocument.creditAccount == nil {
                finalDocument.creditAccount = EmptyAccountView()
            }
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
            guard let result = serverResponse.result.value, let statusCode = serverResponse.response?.statusCode, 200..<300 ~= statusCode else {
                ifFailed.map {
                    if let statusCode = serverResponse.response?.statusCode {
                        $0(ContextError.httpRequestStringFailed(response: serverResponse, statusCode: statusCode))
                    } else {
                        $0(ContextError.unknown)
                    }
                }
                return
            }
            
            isSuccsess(result)
        }
    }
}
