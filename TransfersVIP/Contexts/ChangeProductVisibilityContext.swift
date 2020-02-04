//
//  changeProductVisibilityContext.swift
//  DigitalBank
//
//  Created by iosDeveloper on 6/20/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import Alamofire

class ChangeProductVisibilityContext: Context {
    public var visibility: Bool!
    
    private(set) var type: ProductType
    
    init(type: ProductType) {
        self.type = type
    }

    override func urlString() -> String {
        return baseURL + "api/personal/products-view-state"
    }
    
    override func parametres() -> [String: Any]? {
        let type = self.type.rawValue
        let isVisible = self.visibility!
        return ["type": type, "showAll" : isVisible]
    }
    
    override func HTTPMethod() -> HTTPMethod {
        return .put
    }
    
    override func load(isSuccsess: @escaping SuccessfulLoaded, ifFailed: LoadingError? = nil) {
        let request = sessionManager.request(urlString(), method: HTTPMethod(), parameters: parametres(), encoding: encoding(), headers: HTTPHeaders())
        let validateRequest = request.validate()
        self.request = validateRequest
        validateRequest.responseJSON { (serverResponse) in
            guard let responce = serverResponse.response, 200..<300 ~= responce.statusCode else {
                ifFailed.map { $0(serverResponse.result.error) }
                return
            }
            
            isSuccsess(serverResponse)
        }
    }
}
