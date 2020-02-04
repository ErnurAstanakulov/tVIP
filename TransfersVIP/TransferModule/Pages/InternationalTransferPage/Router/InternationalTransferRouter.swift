//
//  InternationalTransferRouter.swift
//  TransfersVIP
//
//  Created by psuser on 10/1/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

protocol InternationalTransferRouterInput: TransferRouterInput {}

class InternationalTransferRouter: InternationalTransferRouterInput {
    private var networkService: NetworkService
    private var title: String
    
    init(networkService: NetworkService,
         title: String
        ) {
        self.networkService = networkService
        self.title = title
    }
    
    func createModule(viewModel: OperationViewModel) -> UIViewController {
        guard let internationalViewModel = viewModel as? InternationalTransferViewModel else { fatalError("Internal not set")}
        let view = InternationalTransferViewController(viewModel: internationalViewModel, title: title)
        
        let documentActionsService = DocumentActionsService(networkService: networkService, .internationTransfer)
        
        let presenter: InternationalTransferPresenterInput = InternationalTransferPresenter(view: view)
        
        let interactor: InternationalTransferInteractorInput = InternationalTransferInteractor(presenter: presenter, networkService: networkService, documentActionsManager: documentActionsService, viewModel: internationalViewModel)
        
        view.interactor = interactor
        view.router = self
        return view
    }
}
