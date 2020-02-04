//
//  LoadPaymantTemplateContext.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 3/6/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation

class LoadPaymantOrderTemplateContext: Context {
    var template: DomesticTransferTemplate?
    
    override func urlString() -> String {
        let url = baseURL + "api/payment/domestic-transfer/"
        if let id = template?.id {
            return url + String(id)
        }
        
        return url
    }
}
