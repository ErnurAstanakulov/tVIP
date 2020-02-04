//
//  NewsletterPagePresenter.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/14/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

class NewsletterPagePresenter {
    private(set) unowned var view: NewsletterViewInput
    
    init(view: NewsletterViewInput) {
        self.view = view
    }
}

extension NewsletterPagePresenter: NewsletterPagePresenterInput {
    var baseView: BaseViewInputProtocol {
        return view
    }
    
    func set(newsletterItemList: [NewsletterItem]) {
        view.set(newsletterItemList: newsletterItemList)
    }
    
    func endRefreshing() {
        view.endRefreshing()
    }
}
