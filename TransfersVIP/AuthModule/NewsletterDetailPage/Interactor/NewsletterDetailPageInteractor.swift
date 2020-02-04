//
//  NewsletterDetailPageInteractor.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/15/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

class NewsletterDetailPageInteractor {
    private(set) var presenter: NewsletterDetailPagePresenterInput
    private var networkService: NetworkService
    private var newsletterItem: NewsletterItem
    
    init(presenter: NewsletterDetailPagePresenterInput, networkService: NetworkService, newsletterItem: NewsletterItem) {
        self.presenter = presenter
        self.networkService = networkService
        self.newsletterItem = newsletterItem
    }
}

extension NewsletterDetailPageInteractor: NewsletterDetailPageInteractorInput {
    func setupNewsletterItem() {
        presenter.show(newsletterItem: newsletterItem)
    }
}
