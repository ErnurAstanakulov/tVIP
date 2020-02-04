//
//  TransferWorkPresenter.swift
//  TransfersVIP
//
//  Created by psuser on 31/08/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

class TransferWorkPresenter {
    private(set) unowned var view: TransferWorkViewControllerInput
    
    init(view: TransferWorkViewControllerInput) {
        self.view = view
    }
}
extension TransferWorkPresenter: TransferWorkPresenterInput {
    func setWorkDocuments(documents: [String]) {
        view.setWorkDocuments(documents: documents)
    }
    
    
}
