//
//  CurrencyPageRouterInput.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/12/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

protocol CurrencyPageRouterInput {
    func createModule() -> UIViewController
    func popModule()
}
