//
//  CurrencyViewInput.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/12/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

protocol CurrencyViewInput: BaseViewInputProtocol {
    func show(currencyItemList: [CurrencyItem])
    func clearList()
    func endRefreshing()
}
