//
//  AuthMainPageRouterInput.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/12/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

protocol AuthMainPageRouterInput {
    func createModule() -> UIViewController
    func setupLoginPageModule() -> UIViewController
    func setupMenuPageModule() -> UIViewController
}
