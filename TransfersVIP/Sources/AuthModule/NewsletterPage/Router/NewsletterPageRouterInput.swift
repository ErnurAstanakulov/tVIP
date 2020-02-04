//
//  NewsletterPageRouterInput.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/14/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

protocol NewsletterPageRouterInput {
    func createModule() -> UIViewController
    func routeToNewsletterDetailPage(newsletterItem: NewsletterItem)
}
