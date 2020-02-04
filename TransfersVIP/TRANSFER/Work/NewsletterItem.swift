//
//  NewsletterItem.swift
//  TransfersVIP
//
//  Created by psuser on 29/08/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

struct NewsletterItem: Decodable {
    var title: String?
    var date: String?
    var description: String?
    var link: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "head"
        case date = "newsDate"
        case description = "newsDesc"
        case link
    }
}
