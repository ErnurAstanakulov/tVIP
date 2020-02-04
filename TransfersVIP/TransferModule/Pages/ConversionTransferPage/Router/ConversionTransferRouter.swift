//
//  ConversionTransferRouter.swift
//  TransfersVIP
//
//  Created by psuser on 10/1/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

protocol ConversionTransferRouterInput: TransferRouterInput {}

class ConversionTransferRouter: ConversionTransferRouterInput {
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
        guard let conversionViewModel = viewModel as? ConversionViewModel else { fatalError("Internal not set")}
        let view = ConversionTransferViewController(viewModel: conversionViewModel, title: title)
        
        let documentActionsService = DocumentActionsService(networkService: networkService, .accountTransfer)
        
        let presenter: ConversionTransferPresenterInput = ConversionTransferPresenter(view: view)
        
        let interactor: ConversionTransferInteractorInput = ConversionTransferInteractor(presenter: presenter, networkService: networkService, documentActionsManager: documentActionsService, viewModel: conversionViewModel)
        
        view.interactor = interactor
        view.router = self
        return view
    }
}
