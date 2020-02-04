//
//  InternalTransferRouter.swift
//  TransfersVIP
//
//  Created by psuser on 10/1/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

protocol InternalTransferRouterInput: TransferRouterInput {}

class InternalTransferRouter: InternalTransferRouterInput {
    private var networkService: NetworkService
    private var title: String
    
    init(networkService: NetworkService,
         title: String
        ) {
        self.networkService = networkService
        self.title = title
    }
    
    func createModule(viewModel: OperationViewModel) -> UIViewController {
        guard let internalViewModel = viewModel as? InternalTransferViewModel else { fatalError("Internal not set")}
        let view = InternalTransferViewController(viewModel: internalViewModel, title: title)
        
        let documentActionsService = DocumentActionsService(networkService: networkService, .domesticTransfer)
        
        let presenter: InternalTransferPresenterInput = InternalTransferPresenter(view: view)
        
        let interactor: InternalTransferInteractorInput = InternalTransferInteractor(presenter: presenter, networkService: networkService, documentActionsManager: documentActionsService, viewModel: internalViewModel)
        
        view.interactor = interactor
        view.router = self
        return view
    }
}
