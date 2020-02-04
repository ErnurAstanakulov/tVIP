//
//  ConversionTransferPresenter.swift
//  TransfersVIP
//
//  Created by psuser on 10/1/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

protocol ConversionTransferPresenterInput: BasePresenterInput {
}
class ConversionTransferPresenter {
    
    private(set) var view: BaseTransferViewControllerInput?
    
    init(view: ConversionTransferViewControllerInput) {
        self.view = view
    }
}
extension ConversionTransferPresenter: ConversionTransferPresenterInput {
}
