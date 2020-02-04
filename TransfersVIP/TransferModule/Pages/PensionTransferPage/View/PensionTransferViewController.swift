//
//  PensionTransferViewController.swift
//  TransfersVIP
//
//  Created by psuser on 09/09/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import UIKit
import Foundation

protocol PensionTransferViewControllerInput: BaseTransferViewControllerInput {
}
class PensionTransferViewController: OperationsTableViewController  {
    
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

extension PensionTransferViewController: PensionTransferViewControllerInput {
    
}
