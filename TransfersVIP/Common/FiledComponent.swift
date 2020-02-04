//
//  FiledComponent.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/3/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation
import UIKit

struct FiledComponent<TypeId>{
    let id: TypeId
    var fieldType: FieldType
    var title: String
    var description: String?
    var placeholder: String?
    var optionalDescription: (text: String, asWarning: Bool)?
    var isOn: Bool?
    var fileUrl: URL?
    var iconImage: UIImage?
    
    init (
        id: TypeId,
        fieldType: FieldType,
        title: String,
        description: String? = nil,
        placeholder: String? = nil,
        optionalDescription: (text: String, asWarning: Bool)? = nil,
        isOn: Bool? = nil,
        fileUrl: URL? = nil,
        iconImage: UIImage? = nil
    ) {
        self.id = id
        self.fieldType = fieldType
        self.title = title
        self.description = description
        self.placeholder = placeholder
        self.optionalDescription = optionalDescription
        self.isOn = isOn
        self.fileUrl = fileUrl
        self.iconImage = iconImage
    }
}
