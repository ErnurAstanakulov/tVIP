//
//  SearchDocumentContext.swift
//  DigitalBank
//
//  Created by Alex Vovkotrub on 23.07.17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import UIKit
import Alamofire

class SearchDocumentContext: Context {
    public var search: String!

    init(queue: String) {
        self.search = queue
    }
    
    override func urlString() -> String {
        return baseURL + "api/smart-search" // TODO: Add url
    }
    
    override func parametres() -> [String: Any]? {
        return ["search": search ?? ""]
    }
    
    override func HTTPMethod() -> HTTPMethod{
        return .put
    }
    
}
