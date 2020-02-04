//
//  CurrencyListNetworkContext.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/12/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation

class CurrencyListNetworkContext: NetworkContext {
    var route: Route = .apiExchangeRate("KZT")
    var method: NetworkMethod = .get
}
