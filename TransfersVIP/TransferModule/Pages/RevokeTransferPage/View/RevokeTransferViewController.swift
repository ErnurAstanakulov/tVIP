//
//  RevokeTransferViewController.swift
//  TransfersVIP
//
//  Created by psuser on 10/5/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

protocol RevokeTransferViewControllerInput: BaseTransferViewControllerInput {
}
class RevokeTransferViewController: OperationsTableViewController  {
    
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

extension RevokeTransferViewController: RevokeTransferViewControllerInput {
    
}
