//
//  SertificateContext.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 2/14/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation

class SertificateContext: Context {
    let urlPersons = "\(baseURL)api/signing/certificate"
    
    public override func urlString() -> String {
        return urlPersons
    }
}
