//
//  MenuPageRouterInput.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/12/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

protocol MenuPageRouterInput {
    func createModule() -> UIViewController
    func pushCurrenciesModule()
    func pushNewslettersModule()
    func pushBranchesModule()
    func pushSafaryViewController(url: URL)
}
