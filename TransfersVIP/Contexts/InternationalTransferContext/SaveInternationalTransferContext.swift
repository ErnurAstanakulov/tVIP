//
//  InternationalTransferSaveContext.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 4/4/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import Alamofire

class SaveInternationalTransferContext: Context {
    public var finalDocument: InternationalTransferToSend!
    public var documentID: Int?
    public var reSaveTemplate = false
    
    override func urlString() -> String {
        guard let id = self.documentID else {
            return baseURL + "api/payment/international-transfer/new"
        }
        
        if finalDocument.isTemplate == true {
            if reSaveTemplate {
                return baseURL + "api/payment/international-transfer/\(id)"
            } else {
                return baseURL + "api/payment/international-transfer/new"
            }
        }
        
        return baseURL + "api/payment/international-transfer/\(id)"
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
       // print(json)
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
            guard let result = serverResponse.result.value else {
                ifFailed.map { $0(serverResponse.result.error) }
                return
            }
            
            isSuccsess(result)
        }
    }
}
