//
//  NewsletterPageRouter.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/14/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

class NewsletterPageRouter {
    private(set) weak var view: NewsletterViewController?
    private var networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension NewsletterPageRouter: NewsletterPageRouterInput {
    func createModule() -> UIViewController {
        let view = NewsletterViewController()
        let presenter = NewsletterPagePresenter(view: view)
        let interactor = NewsletterPageInteractor(presenter: presenter, networkService: networkService)
        
        view.interactor = interactor
        view.router = self
        
        self.view = view
        return view
    }
    
    func routeToNewsletterDetailPage(newsletterItem: NewsletterItem) {
        let newsletterDetailPageRouter: NewsletterDetailPageRouterInput = NewsletterDetailPageRouter(networkService: networkService)
        let view = newsletterDetailPageRouter.createModule(newsletterItem: newsletterItem)
        self.view?.navigationController?.pushViewController(view, animated: false)
    }
}
