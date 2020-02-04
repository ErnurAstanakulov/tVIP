//
//  TransferWorkPresenterInput.swift
//  TransfersVIP
//
//  Created by psuser on 31/08/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import UIKit

protocol TransferWorkPresenterInput: SignFormPresenterInput {
    func setWorkDocuments(documents: [TransferProtocol])
    func showAlertController(action: [UIAlertAction])
    func setPaymentTransfer(viewModel: OperationViewModel, with title: String)
    func showHistoryViewController(id: Int)
    func reloadWorkDocuments()
    func endRefreshing()
} 
