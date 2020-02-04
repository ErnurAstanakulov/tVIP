//
//  DocumentHistory.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 3/20/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import ObjectMapper

class DocumentHistory: BaseModel {
    var fromState: String?
    var fromStateLabel: String?
    var toState: String?
    var toStateLabel: String?
    var fullName: String?
    var when: String?
    var descr: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        fromState <- map["fromState"]
        fromStateLabel <- map["fromStateLabel"]
        toState <- map["toState"]
        toStateLabel <- map["toStateLabel"]
        fullName <- map["fullName"]
        when <- map["actionTime"]
        descr <- map["description"]
    }
}

class DocumentHistoryState: BaseModel {
    var deleted: Bool?
    var category: String?
    var code: String?
    var label: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        deleted <- map["deleted"]
        category <- map["category"]
        code <- map["code"]
        label <- map["label"]
    }
}

