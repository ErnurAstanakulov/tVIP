//
//  TengeTransferPage.swift
//  TransfersVIP
//
//  Created by psuser on 23/09/2019.
//  Copyright © 2019 psuser. All rights reserved.
//
import UIKit
import Foundation

protocol TengeTransferViewControllerInput: BaseTransferViewControllerInput {
}

class TengeTransferViewController: OperationsTableViewController  {
    
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
extension TengeTransferViewController: TengeTransferViewControllerInput {
}
