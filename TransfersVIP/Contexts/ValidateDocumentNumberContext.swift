//
//  ValidateDocumentNumberContext.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 4/4/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation

class ValidateDocumentNumberContext : Context {
    public let number: String
    private let documentType: Constants.DocumentType
    
    init(number: String, documentType: Constants.DocumentType) {
        self.number = number
        self.documentType = documentType
    }
    
    public override func urlString() -> String {
        return baseURL + "api/customer/documents/validate-number"
    }
    
    // This function can be reloaded
    public override func parametres() -> [String: Any]? {
        return ["number": number, "documentType": documentType.rawValue]
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
