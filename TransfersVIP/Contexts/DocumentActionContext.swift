//
//  DocumentActionContext.swift
//  DigitalBank
//
//  Created by Alex Vovkotrub on 11.09.17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import UIKit
import Alamofire

class DocumentActionContext: Context {
    
    var parameters : AnyDict?
    
    override func parametres() -> [String: Any]? {
        return parameters
    }
    
    override func urlString() -> String {
        return baseURL + "api/workflow/documentAction"
    }
    
    override func HTTPMethod() -> HTTPMethod {
        return .post
    }
    
    override func encoding() -> ParameterEncoding {
        return JSONEncoding.default
    }
    
    override func load(isSuccsess: @escaping SuccessfulLoaded, ifFailed: LoadingError? = nil) {
        let request = sessionManager.request(urlString(), method: HTTPMethod(), parameters: parametres(), encoding: encoding(), headers: HTTPHeaders())
        let validateRequest = request.validate()
        self.request = validateRequest
        validateRequest.responseString { (serverResponse) in
            guard serverResponse.result.isSuccess else {
                ifFailed.map { $0(serverResponse.result.error) }
                return
            }
            let result = serverResponse.result.value ?? ""
            isSuccsess(result)
        }
    }
}
