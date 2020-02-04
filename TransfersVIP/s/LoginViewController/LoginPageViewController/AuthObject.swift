//
//  AuthObject.swift
//  DigitalBank
//
//  Created by psuser on 01/04/2019.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation
import ObjectMapper

class AuthObject: NSObject, Mappable {
    
    var accessToken: String?
    var canSkip: Bool?
    var chainType: String?
    var customerExternalId: Int?
    var isPasswordChange: Bool?
    var tokenType: String?
    var refreshToken: String?
    var expiresIn: String?
    var scope: String?
    var rolesAuthFactors: [RolesAuthFactors]?
    var passedAuthFactors: [String]?
    var possibleChains: [[String]]?
    var role: String?
    var userType: String?
    var userId: Int?
    var roleId: Int?
    var roleVersion: Int?
    var customerUserId: Int?
    var customers: [Customer]?
    var customerId: Int?
    var jti: String?
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init()
    }
    
    func mapping(map: Map) {
        accessToken <- map["access_token"]
        canSkip <- map["can_skip"]
        chainType <- map["chain_type"]
        customerExternalId <- map["customer_external_id"]
        isPasswordChange <- map["is_password_change"]
        tokenType <- map["token_type"]
        refreshToken <- map["refresh_token"]
        expiresIn <- map["expires_in"]
        rolesAuthFactors <- map["roles_auth_factors"]
        role <- map["role"]
        passedAuthFactors <- map["passed_auth_factors"]
        possibleChains <- map["possible_chains"]
        scope <- map["scope"]
        userType <- map["user_type"]
        userId <- map["user_id"]
        roleId <- map["role_id"]
        roleVersion <- map["role_version"]
        customerUserId <- map["customer_user_id"]
        customers <- map["customers"]
        customerId <- map["customer_id"]
        jti <- map["jti"]
    }
}
