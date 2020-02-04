//
//  ChangeDisplayOrderContext.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 5/22/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import Alamofire

class ChangeDisplayOrderContext: Context {
    public var product: ProductModel?
    public var newOrder: Double?
    
    public override func urlString() -> String {
        var url: String = baseURL
        guard let validProduct = self.product else { return url }
        let id = String(validProduct.id)
        switch validProduct {
        case is DetailedAccount: url = baseURL + "api/account/\(id)/display-order"
        case is Deposit: url =  baseURL + "api/deposits/view/\(id)/display-order"
        case is Credit: url =  baseURL + "api/credits/\(id)/display-order"
        case is Card: url =  baseURL + "api/card/\(id)/display-order"
        default: break
        }
        
        return url
    }
    
    public override func parametres() -> [String: Any]? {
        let oprions = self.newOrder.map({ ["displayOrder": String($0)] })
        return oprions
    }
    
    public override func HTTPMethod() -> HTTPMethod {
        return .put
    }
    
    public override func encoding() -> ParameterEncoding {
        return JSONEncoding.default
    }
    
    override func load(isSuccsess: @escaping SuccessfulLoaded, ifFailed: LoadingError? = nil) {
        let request = sessionManager.request(urlString(), method: HTTPMethod(), parameters: parametres(), encoding: encoding(), headers: HTTPHeaders())
        let validateRequest = request.validate()
        validateRequest.responseJSON { (serverResponse) in
            let statusCode = serverResponse.response?.statusCode
            if statusCode == 200 {
                isSuccsess(200)
            } else {
                ifFailed.map { $0(serverResponse.result.error) }
            }
        }
    }
}
