//
//  ModelConverter.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/31/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation

protocol ModelConverter {
    associatedtype ClientModel
    associatedtype ServerModel
    
    static func convert(serverModel: ServerModel) -> ClientModel
    static func convert(clientModel: ClientModel) -> ServerModel
}
