//
//  PaymentsRevokesSaveContext.swift
//  DigitalBank
//
//  Created by Misha Korchak on 08.05.17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import Alamofire

class PaymentsRevokesSaveContext: Context {
    public weak var containerController: PaymentsRevokesContainerViewController?
    public var finalDocument: PaymentsRevokesToSend!
    public var documentID: Int?
    public var reSaveTemplate = false
    
    override func urlString() -> String {
        guard let id = self.documentID else {
            return baseURL + "api/customer/documents/document-withdraw/new"
        }
        
        return baseURL + "api/customer/documents/document-withdraw/\(id)"
    }
    
    public override func parametres() -> [String: Any]? {
        guard let body = self.finalDocument else { return nil }
        
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
            guard let result = serverResponse.result.value else {
                ifFailed.map { $0(serverResponse.result.error) }
                return
            }
            
            isSuccsess(result)
        }
    }
}
