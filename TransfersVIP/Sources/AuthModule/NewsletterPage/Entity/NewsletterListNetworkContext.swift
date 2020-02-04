//
//  NewsletterListNetworkContext.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/15/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation

class NewsletterListNetworkContext: NetworkContext {
    var route: Route = .apiCustomerNews("newsDate", true)
    var method: NetworkMethod = .get
}
