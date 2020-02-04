//
//  PageableResponse.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/15/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation

struct PageableResponse<T: Decodable>: Decodable {
    var rows: [T]
    var total: Total
    
    struct Total: Decodable {
        var count: Int
    }
}
