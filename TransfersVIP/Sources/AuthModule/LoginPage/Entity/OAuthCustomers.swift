//
//  OAuthCustomers.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/9/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation

struct OAuthCustomers: Decodable {
    var customerList: [Customer]
    
    enum CodingKeys: String, CodingKey {
        case customerList = "customers"
    }
}
