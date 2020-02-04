//
//  TransferRouterInput.swift
//  TransfersVIP
//
//  Created by psuser on 10/1/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation
protocol TransferRouterInput {
    func createModule(viewModel: OperationViewModel) -> UIViewController
}
