//
//  SocialTransferRouter.swift
//  TransfersVIP
//
//  Created by psuser on 10/1/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

protocol SocialTransferRouterInput: TransferRouterInput {}

class SocialTransferRouter: SocialTransferRouterInput {
    private var networkService: NetworkService
    private var title: String
    
    init(networkService: NetworkService,
         title: String
        ) {
        self.networkService = networkService
        self.title = title
    }
    
    func createModule(viewModel: OperationViewModel) -> UIViewController {
        guard let socialViewModel = viewModel as? SocialPaymentViewModel else { fatalError("social not set")}
        let view = SocialTransferViewController(viewModel: socialViewModel, title: title)
        
        let documentActionsService = DocumentActionsService(networkService: networkService, .domesticTransfer)
        
        let presenter: SocialTransferPresenterInput = SocialTransferPresenter(view: view)
        
        let interactor: SocialTransferInteractorInput = SocialTransferInteractor(presenter: presenter, networkService: networkService, documentActionsManager: documentActionsService, viewModel: socialViewModel)
        
        view.interactor = interactor
        view.router = self
        return view
    }
}
