//
//  DomesticTransferDeleteContext.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 3/15/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import Alamofire

class ChangeDocumentStateContext: Context {
    var action: String?
    var id: Int?
    var documentType: Constants.DocumentType = .domesticTransfer
    
    convenience init(documentType: Constants.DocumentType) {
        self.init()
        self.documentType = documentType
    }
    
    public override func urlString() -> String {
        return baseURL + "api/workflow/documentAction"
    }
    
    public override func parametres() -> [String: Any]? {
        guard let ID = self.id, let action = self.action else { return nil }
        let someAction = DocumentAction(action: action, ID: ID, documentType: self.documentType.rawValue)
        return someAction.toJSON()
    }
    
    public override func encoding() -> ParameterEncoding {
        return JSONEncoding.default
    }
    
    public override func HTTPMethod() -> HTTPMethod {
        return .post
    }
    
    override func load(isSuccsess: @escaping SuccessfulLoaded, ifFailed: LoadingError? = nil) {
        let request = sessionManager.request(urlString(), method: HTTPMethod(), parameters: parametres(), encoding: encoding(), headers: HTTPHeaders())
        let validateRequest = request.validate()
        self.request = validateRequest
        validateRequest.responseString { (serverResponse) in
            guard let result = serverResponse.result.value else {
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
