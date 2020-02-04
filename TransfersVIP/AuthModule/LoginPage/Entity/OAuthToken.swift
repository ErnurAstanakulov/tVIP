//
//  OAuthToken.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/9/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation

struct OAuthToken: Decodable {
    var accessToken: String
    var refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
