//
//  TransferComponentBuilder.swift
//  TransfersVIP
//
//  Created by psuser on 13/09/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

protocol ComponentBuilder {
    func createBuilder() -> OperationsTableViewController
    init(title: String)
}

class TransferComponentBuilder: ComponentBuilder {
    
    private var title: String
    
    required init(title: String) {
        self.title = title
    }
    
    func createBuilder() -> OperationsTableViewController {
        guard let controller = TransferFactory().createTransfer(title: title) else {
            fatalError("Transfer OperationViewModel doesnt initialize")
        }
        return controller
    }
}

class TransferFactory {
    
    func createTransfer(title: String) -> OperationsTableViewController? {
        switch title {
        case TransferTypeRus.paymentTenge.rawValue:
            let viewModel = DomesticTransferViewModel()
            return TengeTransferViewController(viewModel: viewModel, title: title)
        case TransferTypeRus.payroll.rawValue:
            let viewModel = PayrollPaymentViewModel()
            return PayrollTransferViewController(viewModel: viewModel, title: title)
        default: return nil
        }
    }
}
