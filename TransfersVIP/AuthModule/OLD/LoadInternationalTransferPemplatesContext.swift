//
//  LoadInternationalTransferPemplatesContext.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 4/5/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation

class LoadTemplateListContext: Context {
    public var documentType: String!
    
    override func urlString() -> String {
        return baseURL + "api/customer/documents/template-list"
    }
    
    public override func parametres() -> [String: Any]? {
        return ["documentType": documentType ?? ""]
    }
    
    convenience init(documentType: String) {
        self.init()
        self.documentType = documentType
    }
}
