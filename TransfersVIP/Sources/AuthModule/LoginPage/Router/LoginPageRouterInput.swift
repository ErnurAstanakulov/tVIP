//
//  LoginPageRouterInput.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/5/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

protocol LoginPageRouterInput {
    func createModule() -> UIViewController
    func routeToMainMenuTabBar()
    func presentSynchronizeOTPForm(complation: @escaping (String?, String?) -> ())
}
