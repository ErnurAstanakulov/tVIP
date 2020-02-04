//
//  NewsletterDetailPageRouter.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/15/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//
import UIKit
class NewsletterDetailPageRouter {
    private(set) weak var view: NewsletterDetailViewController?
    private var networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension NewsletterDetailPageRouter: NewsletterDetailPageRouterInput {
    func createModule(newsletterItem: NewsletterItem) -> UIViewController {
        let view = NewsletterDetailViewController()
        let presenter = NewsletterDetailPagePresenter(view: view)
        let interactor = NewsletterDetailPageInteractor(presenter: presenter, networkService: networkService, newsletterItem: newsletterItem)
        
        view.interactor = interactor
        view.router = self
        
        self.view = view
        return view
    }
}
