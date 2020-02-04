//
//  PersonalCodable.swift
//  TransfersVIP
//
//  Created by psuser on 10/14/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

struct PersonalCodable: Codable {
    var phone: String?
    var fullName: String?
    var id: Int
    var position: String?
    var login: String?
    var requireSMS: Bool?
    var email: String?
    var defaultOrgName: String?
    
    enum CodingKeys: String, CodingKey {
        case requireSMS = "require_sms"
        case phone, fullName, id, position, login, email, defaultOrgName
    }
}

enum PersonalFields {
    case login
    case phone
    case fullName
    case position
    case email
    case language
}
