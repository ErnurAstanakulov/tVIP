//
//  PayrollTransferViewController.swift
//  TransfersVIP
//
//  Created by psuser on 24/09/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

protocol PayrollTransferViewControllerInput: BaseTransferViewControllerInput {
}
class PayrollTransferViewController: OperationsTableViewController  {

    var interactor: BaseSetTransferInteractorInput?
    var router: TransferRouterInput?
    
    override func loadView() {
        super.loadView()
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension PayrollTransferViewController: PayrollTransferViewControllerInput {
    
}
