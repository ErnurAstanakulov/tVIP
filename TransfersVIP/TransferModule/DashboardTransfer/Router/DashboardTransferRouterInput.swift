//
//  DashboardTransferRouterInput.swift
//  TransfersVIP
//
//  Created by psuser on 29/08/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import UIKit

protocol DashboardTransferRouterInput {
    func createModule() -> UIViewController
    func createTransferNewController() -> UIViewController
    func createTransferWorkController() -> UIViewController
    func createTransferTemplateMenuController() -> UIViewController
    func createTransferRegularController() -> UIViewController
}
