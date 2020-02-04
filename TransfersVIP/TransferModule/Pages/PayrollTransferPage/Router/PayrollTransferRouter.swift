//
//  PayrollTransferRouter.swift
//  TransfersVIP
//
//  Created by psuser on 24/09/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation
protocol PayrollTransferRouterInput: TransferRouterInput {}

class PayrollTransferRouter: PayrollTransferRouterInput {
    private var networkService: NetworkService
    private var title: String
    
    init(networkService: NetworkService,
         title: String
        ) {
        self.networkService = networkService
        self.title = title
    }
    
    func createModule(viewModel: OperationViewModel) -> UIViewController {
        guard let payrollViewModel = viewModel as? PayrollPaymentViewModel else { fatalError("payrollViewModel not set")}
        let view = PayrollTransferViewController(viewModel: payrollViewModel, title: title)
        
        let documentActionsService = DocumentActionsService(networkService: networkService, .domesticTransfer)
        
        let presenter: PayrollTransferPresenterInput = PayrollTransferPresenter(view: view)
        
        let interactor: PayrollTransferInteractorInput = PayrollTransferInteractor(presenter: presenter, networkService: networkService, documentActionsManager: documentActionsService, viewModel: payrollViewModel)
        
        view.interactor = interactor
        view.router = self
        return view
    }
}
