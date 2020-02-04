//
//  LoadProductHistoryContext.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 5/25/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import Alamofire

class LoadProductHistoryContext: Context {
    enum ProductType: String {
        case account = "account"
//        case credit = "credit"
//        case deposit = "deposit"
        case card = "card"
        case frgnexchange = "frgnexchange"
    }
    
    private(set) var type: LoadProductHistoryContext.ProductType
    public var product: ProductModel!
    public var options: [String: Any]?
    
    required public init(type: LoadProductHistoryContext.ProductType) {
        self.type  = type
        
        super.init()
    }
    
    override func urlString() -> String {
        if self.type == .frgnexchange {
            return baseURL + "api/frgnexchange/get-exchange-contracts-pay"
        }
        
        let type = self.type.rawValue
        var id: String
        
        if self.product is Credit || self.product is Deposit {
            id = self.product.accountId.map({ String($0) }) ?? ""
        } else {
            id = String(product.id)
        }
        
        let url = baseURL + "api/\(type)/transaction-history/\(id)?sort=id&order=asc"
        
        return url
    }
    
    override func parametres() -> [String: Any]? {
        return self.options
    }
    
    override func HTTPMethod() -> HTTPMethod {
        if self.type == .frgnexchange {
            return .post
        }
        return .get
    }
    
    override func encoding() -> ParameterEncoding {
        if self.type == .frgnexchange {
            return JSONEncoding.default
        } else {
            return URLEncoding.default
        }
    }
}
