//
//  NewsletterPageInteractorInput.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/14/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

protocol NewsletterPageInteractorInput: BaseInteractorInputProtocol {
    func loadNewsletterList()
    func onRefresh()
}
