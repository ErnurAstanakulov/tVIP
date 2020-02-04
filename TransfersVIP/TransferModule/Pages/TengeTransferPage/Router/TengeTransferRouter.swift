//
//  TengeRouter.swift
//  TransfersVIP
//
//  Created by psuser on 23/09/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

protocol TengeTransferRouterInput: TransferRouterInput { }

class TengeTransferRouter: TengeTransferRouterInput {
    private var networkService: NetworkService
    private var title: String
    
    init(networkService: NetworkService,
        title: String
    ) {
        self.networkService = networkService
        self.title = title
    }
    
    func createModule(viewModel: OperationViewModel) -> UIViewController {
        guard let domesticViewModel = viewModel as? DomesticTransferViewModel else {
                fatalError("TengeTransferViewController not set")
        }
        let view = TengeTransferViewController(viewModel: domesticViewModel, title: title)
        let documentActionsService = DocumentActionsService(networkService: networkService, .domesticTransfer)
        
        let presenter: TengeTransferPresenterInput = TengeTransferPresenter(view: view)
        
        let interactor: TengeTransferInteractorInput = TengeTransferInteractor(presenter: presenter, networkService: networkService, documentActionsManager: documentActionsService, viewModel: domesticViewModel)
        
        view.interactor = interactor
        view.router = self
        return view
    }
}
