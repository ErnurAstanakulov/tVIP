//
//  RevokeTransferRouter.swift
//  TransfersVIP
//
//  Created by psuser on 10/5/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

protocol RevokeTransferRouterInput: TransferRouterInput {}

class RevokeTransferRouter: RevokeTransferRouterInput {
    private var networkService: NetworkService
    private var title: String
    
    init(
        networkService: NetworkService,
        title: String
        ) {
        self.networkService = networkService
        self.title = title
    }
    
    func createModule(viewModel: OperationViewModel) -> UIViewController {
        guard let viewModel = viewModel as? PaymentRevokeViewModel else { fatalError("Revoke not set")}
        let view = RevokeTransferViewController(viewModel: viewModel, title: title)
        
        let documentActionsService = DocumentActionsService(networkService: networkService, .paymentsRevokes)
        
        let presenter: RevokeTransferPresenterInput = RevokeTransferPresenter(view: view)
        
        let interactor: RevokeTransferInteractorInput = RevokeTransferInteractor(presenter: presenter, networkService: networkService, documentActionsManager: documentActionsService, viewModel: viewModel)
        
        view.interactor = interactor
        view.router = self
        return view
    }
}
