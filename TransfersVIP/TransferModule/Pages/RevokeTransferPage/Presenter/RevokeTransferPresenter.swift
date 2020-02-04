//
//  RevokeTransferPresenter.swift
//  TransfersVIP
//
//  Created by psuser on 10/5/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

protocol RevokeTransferPresenterInput: BasePresenterInput {
}
class RevokeTransferPresenter {
    
    private(set) var view: BaseTransferViewControllerInput?
    
    init(view: RevokeTransferViewControllerInput) {
        self.view = view
    }
}
extension RevokeTransferPresenter: RevokeTransferPresenterInput {
}
