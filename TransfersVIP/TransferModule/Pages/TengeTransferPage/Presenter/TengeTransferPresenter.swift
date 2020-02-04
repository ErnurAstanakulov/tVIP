//
//  TengeTransferPresenter.swift
//  TransfersVIP
//
//  Created by psuser on 23/09/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import UIKit
protocol TengeTransferPresenterInput: BasePresenterInput {
    
}
class TengeTransferPresenter {
    
    private(set) var view: BaseTransferViewControllerInput?
    
    init(view: TengeTransferViewControllerInput) {
        self.view = view
    }
}

extension TengeTransferPresenter: TengeTransferPresenterInput {
    
}
