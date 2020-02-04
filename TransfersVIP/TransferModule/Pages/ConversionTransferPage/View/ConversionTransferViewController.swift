//
//  ConversionTransferViewController.swift
//  TransfersVIP
//
//  Created by psuser on 10/1/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

protocol ConversionTransferViewControllerInput: BaseTransferViewControllerInput {
}
class ConversionTransferViewController: OperationsTableViewController  {
    
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

extension ConversionTransferViewController: ConversionTransferViewControllerInput {
    
}
