//
//  InternationalTransferViewController.swift
//  TransfersVIP
//
//  Created by psuser on 10/1/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

protocol InternationalTransferViewControllerInput: BaseTransferViewControllerInput {
}
class InternationalTransferViewController: OperationsTableViewController  {
    
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

extension InternationalTransferViewController: InternationalTransferViewControllerInput {
    
}
