//
//  NewsletterItem.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/15/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
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
