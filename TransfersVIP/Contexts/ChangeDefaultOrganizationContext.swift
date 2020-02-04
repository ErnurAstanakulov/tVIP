//
//  setOrganizationContext.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 2/17/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import Alamofire

class ChangeDefaultOrganizationContext: Context {
    public var organization: Organization? = nil
    
    public override func urlString() -> String {
        return "\(baseURL)api/personal/change-default"
    }
    
    public override func parametres() -> [String: Any]? {
        guard let id = organization?.id else { return nil }
        return ["id": id]
    }
    
    // By default .get, this function can be reloaded
    public override func HTTPMethod() -> HTTPMethod {
        return .put
    }
    
    // By default .URLEncoding.default, this function can be reloaded
    public override func encoding() -> ParameterEncoding {
        return JSONEncoding.default
    }
    
    override func load(isSuccsess: @escaping SuccessfulLoaded, ifFailed: LoadingError? = nil) {
        let request = sessionManager.request(urlString(), method: HTTPMethod(), parameters: parametres(), encoding: encoding(), headers: HTTPHeaders())
        let validateRequest = request.validate()
        self.request = validateRequest
        validateRequest.responseJSON { (serverResponse) in
            if 200..<300 ~= serverResponse.response!.statusCode {
                isSuccsess(serverResponse)
            } else {
                ifFailed.map { $0(serverResponse.result.error) }
                return
            }
        }
    }
}
    
