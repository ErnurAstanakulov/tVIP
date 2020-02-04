//
//  PensionTransferRouter.swift
//  TransfersVIP
//
//  Created by psuser on 13/09/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

protocol PensionTransferRouterInput: TransferRouterInput {}

class PensionTransferRouter: PayrollTransferRouterInput {
    private var networkService: NetworkService
    private var title: String
    
    init(networkService: NetworkService,
         title: String
        ) {
        self.networkService = networkService
        self.title = title
    }
    
    func createModule(viewModel: OperationViewModel) -> UIViewController {
        guard let pensionViewModel = viewModel as? PensionPaymentViewModel else { fatalError("pension not set")}
        let view = PensionTransferViewController(viewModel: pensionViewModel, title: title)
        
        let documentActionsService = DocumentActionsService(networkService: networkService, .domesticTransfer)
        
        let presenter: PensionTransferPresenterInput = PensionTransferPresenter(view: view) 

        let interactor: PensionTransferInteractorInput = PensionTransferInteractor(presenter: presenter, networkService: networkService, documentActionsManager: documentActionsService, viewModel: pensionViewModel)
        
        view.interactor = interactor
        view.router = self
        return view
    }
}
