//
//  InternalTranferViewController.swift
//  TransfersVIP
//
//  Created by psuser on 10/1/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import UIKit

protocol InternalTransferViewControllerInput: BaseTransferViewControllerInput {
}
class InternalTransferViewController: OperationsTableViewController  {
    
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

extension InternalTransferViewController: InternalTransferViewControllerInput {
    
}
