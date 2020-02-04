//
//  TransferNewPresenter.swift
//  TransfersVIP
//
//  Created by psuser on 30/08/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

class TransferNewPresenter {
    private(set) unowned var view: TransferNewControllerInput
    
    init(view: TransferNewControllerInput) {
        self.view = view
    }
}
extension TransferNewPresenter: TransferNewPresenterInput {
    func setTitles(titles: [TransferNew]) {
        view.setNewTransferTitles(titles: titles)
    }
    
    
}
