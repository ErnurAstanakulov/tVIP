//
//  TransferNewPresenterInput.swift
//  TransfersVIP
//
//  Created by psuser on 30/08/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

protocol TransferNewPresenterInput: BasePresenterInputProtocol {
    func setTitles(titles: [TransferNew])
    func setPaymentTransfer(viewModel: OperationViewModel, with title: String)
}
