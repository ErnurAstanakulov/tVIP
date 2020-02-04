//
//  ProductModel.swift
//  DigitalBank
//
//  Created by Misha Korchak on 26.04.17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import ObjectMapper

class ProductModel: BaseModel {
    var actions: [String]?
    var demandActions: [DemandAction]?
    var currency: String?
    var currencyName: String?
    var displayOrder: Double?
    var status: Status?
    var accountId: Int?
    
    //DESC: computed property, for amount presentation(reloaded in each product)
    private(set) var amountToDisplay: String? 
    public var amountWithCurrency: String? {
        guard let amount = self.amountToDisplay, let currency = currency else { return nil }
        return String(format: "%@ %@", amount, (GlobalFunctions.unicodeFromCurrency(currency) ?? ""))
    }
    
    var isAmountPositive: Bool {
        return false
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        currency <- map["currency"]
        currencyName <- map["currencyName"]
        actions <- map["actions"]
        demandActions <- map["demandActions"]
        displayOrder <- map["displayOrder"]
        status <- map["status"]
        // DESC: this property has Deposit/ Credit => referance for product accotun
        // Needs for transaction histrory
        accountId <- map["accountId"]
    }
    
    public var productTitle: String?
    
    struct Status: Mappable {
        
        var id: Int?
        var code: String?
        var label: String?
        var subCode: String?
        var subLabel: String?
        
        init(_ smStatus: SMProductStatus) {
            self.id = smStatus.id
            self.code = smStatus.code
            self.label = smStatus.label
            self.subCode = smStatus.subCode
            self.subLabel = smStatus.subLabel
        }
        
        init?(map: Map) {
            if map.JSON["code"] == nil || map.JSON["label"] == nil {
                return nil
            }
        }
        
        mutating func mapping(map: Map) {
            id <- map["id"]
            code <- map["code"]
            label <- map["label"]
            subCode <- map["subCode"]
            subLabel <- map["subLabel"]
        }
        
        var statusCode: ProductStatus? {
            guard let code = code else { return nil }
            return ProductStatus(rawValue: code)
        }
    }
    
    struct DemandAction: Mappable {
        var action: String?
        var demandTypeId: Int?
        var privilege: String?
        
        init(_ smDemandAction: SMDemandAction) {
            self.action = smDemandAction.action
            self.demandTypeId = smDemandAction.demandTypeId
            self.privilege = smDemandAction.privilege
        }
        
        init?(map: Map) { }
        
        mutating func mapping(map: Map) {
            action <- map["action"]
            demandTypeId <- map["demandTypeId"]
            privilege <- map["privilege"]
        }
    }
}


struct SMProductStatus: Codable {
    var id: Int?
    var code: String?
    var label: String?
    var subCode: String?
    var subLabel: String?
}

struct SMDemandAction: Codable {
    var action: String?
    var demandTypeId: Int?
    var privilege: String?
}
