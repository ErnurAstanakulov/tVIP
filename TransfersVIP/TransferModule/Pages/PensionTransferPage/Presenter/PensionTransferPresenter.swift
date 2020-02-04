//
//  PensionTransferPresenter.swift
//  TransfersVIP
//
//  Created by psuser on 13/09/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import UIKit

protocol PensionTransferPresenterInput: BasePresenterInput {
}
class PensionTransferPresenter {
    
    private(set) var view: BaseTransferViewControllerInput?
    
    init(view: PensionTransferViewControllerInput) {
        self.view = view
    }
}
extension PensionTransferPresenter: PensionTransferPresenterInput {
} 
