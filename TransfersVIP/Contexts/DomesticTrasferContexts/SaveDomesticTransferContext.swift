//
//  DomesticTransferSubmitContext.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 3/7/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import Alamofire

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
