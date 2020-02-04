//
//  OAuthFactors.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/9/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation

struct OAuthFactors: Decodable {
    var passedAuthFactorList: [String]
    var possibleChainList: [[String]]
    var canSkip: Bool

    enum CodingKeys : String, CodingKey {
        case passedAuthFactorList = "passed_auth_factors"
        case possibleChainList = "possible_chains"
        case canSkip = "can_skip"
    }
}
