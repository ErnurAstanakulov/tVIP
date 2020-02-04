//
//  NewsletterDetailPagePresenter.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/15/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation

class NewsletterDetailPagePresenter {
    private(set) unowned var view: NewsletterDetailViewInput
    
    init(view: NewsletterDetailViewInput) {
        self.view = view
    }
}

extension NewsletterDetailPagePresenter: NewsletterDetailPagePresenterInput {
    var baseView: BaseViewInputProtocol {
        return view
    }
    
    func show(newsletterItem: NewsletterItem) {
        view.show(newsletterItem: newsletterItem)
    }
}
