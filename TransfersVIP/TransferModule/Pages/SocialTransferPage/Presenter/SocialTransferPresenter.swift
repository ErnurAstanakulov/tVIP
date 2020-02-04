//
//  SocialTransferPresenter.swift
//  TransfersVIP
//
//  Created by psuser on 10/1/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

protocol SocialTransferPresenterInput: BasePresenterInput {
}
class SocialTransferPresenter {
    
    private(set) var view: BaseTransferViewControllerInput?
    
    init(view: SocialTransferViewControllerInput) {
        self.view = view
    }
}
extension SocialTransferPresenter: SocialTransferPresenterInput {
}
