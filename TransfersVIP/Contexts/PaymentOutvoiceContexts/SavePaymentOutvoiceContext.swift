//
//  SavePaymentOutvoiceContext.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 4/12/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import Alamofire

class SaveOutvoiceDocumentContext: Context {
    public weak var containerController: PaymentOutvoiceContainerViewController?
    public var finalDocument: PaymentOutvoiceToSend!
    public var documentID: Int?
    public var reSaveTemplate = false
    
    
    override func urlString() -> String {
        if finalDocument.isTemplate == true {
            if reSaveTemplate {
                finalDocument.templateName = containerController?.initialDocument?.templateName
            }
        }
        
        return baseURL + "api/exposedorder"
    }
    
    public override func parametres() -> [String: Any]? {
        guard let body = self.finalDocument else { return nil }
        // КОСТЫЛЬ begin
        //SESC: in tamplate purposeCode canNot be empty
        if finalDocument?.isTemplate == true && finalDocument?.purposeCode?.isEmpty == true {
            body.purposeCode = nil
        }
        // КОСТЫЛЬ end
        
        var json = body.toJSON()
        if let documentId = documentID {
            json["id"] = documentId
        }
        
        return json
    }
    
    public override func HTTPMethod() -> HTTPMethod {
        return documentID == nil ? .post : .put
    }
    
    public override func encoding() -> ParameterEncoding {
        return JSONEncoding.default
    }
}
