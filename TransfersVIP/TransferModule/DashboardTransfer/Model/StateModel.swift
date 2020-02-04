//
//  StateModel.swift
//  TransfersVIP
//
//  Created by psuser on 03/09/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

struct StateModel: Decodable {
    var id: Int?
    var deleted: Bool?
    var externalId: String?
    var category: String?
    var code: String?
    var label: String?
}
