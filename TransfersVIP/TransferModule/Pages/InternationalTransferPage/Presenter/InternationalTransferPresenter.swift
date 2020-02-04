//
//  InternationalTransferPresenter.swift
//  TransfersVIP
//
//  Created by psuser on 10/1/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

protocol InternationalTransferPresenterInput: BasePresenterInput {
}
class InternationalTransferPresenter {
    
    private(set) var view: BaseTransferViewControllerInput?
    
    init(view: InternationalTransferViewControllerInput) {
        self.view = view
    }
}
extension InternationalTransferPresenter: InternationalTransferPresenterInput {
}
