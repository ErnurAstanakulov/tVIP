//
//  HeaderComponent.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/3/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation

struct HeaderComponent<HeaderTypeId, FieldTypeId> {
    let id: HeaderTypeId
    let title: String
    let description: String?
    var fieldComponentList: [FiledComponent<FieldTypeId>]
    
    init (
        id: HeaderTypeId,
        title: String,
        description: String? = nil,
        fieldComponentList: [FiledComponent<FieldTypeId>] = []
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.fieldComponentList = fieldComponentList
    }
}
