//
//  TransferWorkViewControllerInput.swift
//  TransfersVIP
//
//  Created by psuser on 31/08/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

protocol TransferWorkViewControllerInput: SignFactorFormInput {
    func setWorkDocuments(documents: [TransferProtocol])
    func showAlertController(action: [UIAlertAction])
    func setPaymentTransfer(viewModel: OperationViewModel, with title: String)
    func reloadWorkDocuments()
    func showHistoryViewController(id: Int)
    func endRefreshing()
}
