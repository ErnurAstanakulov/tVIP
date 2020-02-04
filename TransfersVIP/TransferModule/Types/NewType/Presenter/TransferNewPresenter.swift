//
//  TransferNewPresenter.swift
//  TransfersVIP
//
//  Created by psuser on 30/08/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

class TransferNewPresenter: BasePresenterInputProtocol {

    private(set) unowned var view: TransferNewControllerInput
    
    init(view: TransferNewControllerInput) {
        self.view = view
    }
}
extension TransferNewPresenter: TransferNewPresenterInput {
    
    var baseView: BaseViewInputProtocol {
        return view
    }
    
    func showError(message: String) {
        view.showError(message: message)
    }
    
    func setTitles(titles: [TransferNew]) {
        view.setNewTransferTitles(titles: titles)
    }
    
    func setPaymentTransfer(viewModel: OperationViewModel, with title: String) {
        view.setPaymentTransfer(viewModel: viewModel, with: title)
    }
}
