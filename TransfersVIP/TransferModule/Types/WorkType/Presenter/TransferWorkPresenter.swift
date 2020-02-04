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
    
    func showHistoryViewController(id: Int) {
        view.showHistoryViewController(id: id)
    }
    
    func showAlertController(action: [UIAlertAction]) {
        view.showAlertController(action: action)
    }
    
    var baseView: BaseViewInputProtocol {
        return view
    }
    
    func setWorkDocuments(documents: [TransferProtocol]) {
        view.setWorkDocuments(documents: documents)
    }
    
    func setPaymentTransfer(viewModel: OperationViewModel, with title: String) {
        view.setPaymentTransfer(viewModel: viewModel, with: title)
    }
    
    func reloadWorkDocuments() {
        view.reloadWorkDocuments()
    }
    
    func showOTPForm(_ canSkip: Bool) {
        view.showOTPForm(canSkip)
    }
    
    func showSMSForm(_ canSkip: Bool) {
        view.showSMSForm(canSkip)
    }
    
    func endRefreshing() {
        view.endRefreshing()
    }

}
