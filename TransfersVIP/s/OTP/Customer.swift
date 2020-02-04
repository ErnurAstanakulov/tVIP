//
//  Company.swift
//  Login
//
//  Created by Zhalgas Baibatyr on 26/04/2018.
//

import Foundation
import ObjectMapper

class Customer: Mappable, Decodable {
    
    var id: Int?
    var name: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
}
