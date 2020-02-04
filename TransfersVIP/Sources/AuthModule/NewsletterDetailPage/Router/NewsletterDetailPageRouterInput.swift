//
//  NewsletterDetailPageRouterInput.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/15/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

protocol NewsletterDetailPageRouterInput {
    func createModule(newsletterItem: NewsletterItem) -> UIViewController
}
