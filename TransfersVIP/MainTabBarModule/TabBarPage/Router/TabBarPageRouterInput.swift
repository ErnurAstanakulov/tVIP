//
//  TabBarPageRouterInput.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/19/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation
import UIKit

protocol TabBarPageRouterInput {
    func createModule() -> UIViewController
    
    func createMainPageController() -> UINavigationController
    func createTransferController() -> UINavigationController
    func createMenuController() -> UINavigationController
    func createDemandController() -> UINavigationController
}
