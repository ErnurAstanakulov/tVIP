//
//  GenerateNewDocumentNumberContext.swift
//  DigitalBank
//
//  Created by Alex Vovkotrub on 11.09.17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import UIKit

class GenerateNewDocumentNumberContext: Context {
    convenience init(type: Constants.DocumentType) {
        self.init()
        self.documentType = type
    }
    
    public var documentType: Constants.DocumentType?
    
    override func parametres() -> [String : Any]? {
        if let type = documentType{
            return [ "documentType" : type.rawValue ]
        }
        return [:]
    }
    
    override func urlString() -> String {
        return baseURL + "api/customer/documents/generate-number"
    }
}
