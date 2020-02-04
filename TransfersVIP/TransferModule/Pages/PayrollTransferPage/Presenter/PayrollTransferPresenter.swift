//
//  PayrollTransferPresenter.swift
//  TransfersVIP
//
//  Created by psuser on 24/09/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import UIKit
protocol PayrollTransferPresenterInput: BasePresenterInput {
}
class PayrollTransferPresenter {
    
    private(set) var view: BaseTransferViewControllerInput?
    
    init(view: PayrollTransferViewControllerInput) {
        self.view = view
    }
}
extension PayrollTransferPresenter: PayrollTransferPresenterInput {
}
