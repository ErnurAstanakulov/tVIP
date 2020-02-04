//
//  NewsletterPagePresenterInput.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/14/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

protocol NewsletterPagePresenterInput: BasePresenterInputProtocol {
    func set(newsletterItemList: [NewsletterItem])
    func endRefreshing()
}
