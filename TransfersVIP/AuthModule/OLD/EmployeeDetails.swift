//
//  EmployeeDetails.swift
//  DigitalBank
//
//  Created by Misha Korchak on 21.07.17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import ObjectMapper

class EmployeeDetails: BaseModel {
    
    var deleted: Bool?
    var firstName: String?
    var lastName: String?
    var middleName: String?
    var amount: String?
    var account: Sum?
    var taxCode: String?
    var birthDate: String?
    var reason: String?
    var period: String?
    
    var fullName: String {
        return String(format: "%@ %@ %@", self.lastName ?? "", self.firstName ?? "", self.middleName ?? "")
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        deleted <- map["deleted"]
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        middleName <- map["middleName"]
        amount <- map["amount"]
        account <- map["account"]
        taxCode <- map["taxCode"]
        birthDate <- map["birthDate"]
        reason <- map["reason"]
        period <- map["period"]
    }
}
