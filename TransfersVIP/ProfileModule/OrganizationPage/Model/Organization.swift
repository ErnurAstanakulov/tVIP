//
//  Organization.swift
//  TransfersVIP
//
//  Created by psuser on 10/17/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

struct Organization: Decodable {
    var id: Int
    var name: String?
    var bin: String?
    var isBlocked: Bool?
    var branch: String?
    var ownership: String?
}
