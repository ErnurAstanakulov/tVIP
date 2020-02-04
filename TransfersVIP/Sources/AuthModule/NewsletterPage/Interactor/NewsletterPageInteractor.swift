//
//  NewsletterPageInteractor.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/14/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

class NewsletterPageInteractor {
    private(set) var presenter: NewsletterPagePresenterInput
    private var networkService: NetworkService
    
    init(presenter: NewsletterPagePresenterInput, networkService: NetworkService) {
        self.presenter = presenter
        self.networkService = networkService
    }
}

extension NewsletterPageInteractor: NewsletterPageInteractorInput {
    func loadNewsletterList() {
        loadList(loadable: true) { [weak self] (newsletterItemList) in
            guard let self = self, let newsletterItemList = newsletterItemList else {
                return
            }
            
            self.presenter.set(newsletterItemList: newsletterItemList)
        }
    }
    
    func onRefresh() {
        loadList(loadable: false) { [weak self] (newsletterItemList) in
            guard let self = self else {
                return
            }
            self.presenter.endRefreshing()
            if let newsletterItemList = newsletterItemList {
                self.presenter.set(newsletterItemList: newsletterItemList)
            }
        }
    }
}

extension NewsletterPageInteractor {
    private func loadList(loadable: Bool, complation: @escaping ([NewsletterItem]?) -> () ) {
        let newsletterListNetworkContext = NewsletterListNetworkContext()
        if (loadable) {
            presenter.startLoading()
        }
        networkService.load(context: newsletterListNetworkContext) { [weak self] (networkResponse) in
            guard let self = self else {
                return
            }
            self.presenter.stopLoading()
            
            guard networkResponse.isSuccess else {
                self.presenter.showError(error: networkResponse.networkError ?? .unknown)
                complation(nil)
                return
            }
            
            guard let pageableResponse: PageableResponse<NewsletterItem> = networkResponse.decode() else {
                self.presenter.showError(error: NetworkError.dataLoad)
                complation(nil)
                return
            }
            
            complation(pageableResponse.rows)
        }
    }
}
