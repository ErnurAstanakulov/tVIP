//
//  TransferNewRouterInput.swift
//  TransfersVIP
//
//  Created by psuser on 30/08/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import UIKit

protocol TransferNewRouterInput {
    func createModule() -> UIViewController
    func pushNewTransfer(viewModel: OperationViewModel, with title: String)
}
