//
//  InternalTransferPresenter.swift
//  TransfersVIP
//
//  Created by psuser on 10/1/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

protocol InternalTransferPresenterInput: BasePresenterInput {
}
class InternalTransferPresenter {
    
    private(set) var view: BaseTransferViewControllerInput?
    
    init(view: InternalTransferViewControllerInput) {
        self.view = view
    }
}
extension InternalTransferPresenter: InternalTransferPresenterInput {
}
