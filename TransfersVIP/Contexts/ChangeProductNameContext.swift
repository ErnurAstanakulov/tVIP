//
//  ChangeProductNameContext.swift
//  DigitalBank
//
//  Created by iosDeveloper on 6/26/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import Alamofire

class ChangeProductNameContext: Context {
    public var newName: String!
    public var product: ProductModel!
    
    private(set) var productType: ProductType
    
    required init(produtType: ProductType) {
        self.productType = produtType
    }

    public override func urlString() -> String {
        let id = String(self.product.id)
        switch productType {
        case .account:
            return baseURL + "api/account/\(id)/alias"
        case .card:
            return baseURL + "api/card/\(id)/alias"
        case .deposit:
            return baseURL + "api/deposits/\(id)/alias"
        case .credit:
            return baseURL + "api/credits/\(id)/alias"
        case .guarantee:
            return baseURL + "api/guarantee/\(id)/alias"
        case .foreignExchangeContract:
            return baseURL + "api/frgnexchange/\(id)/alias"
        }
    }
    
    // This function can be reloaded
    public override func parametres() -> [String: Any]? {
        guard let name = self.newName else { return nil }
        return ["alias": name]
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
            log(serverResponse: serverResponse)
            guard let responce = serverResponse.response, 200..<300 ~= responce.statusCode else {
                ifFailed.map { $0(serverResponse.result.error) }
                return
            }
            
            isSuccsess(serverResponse)
        }
    }
}
