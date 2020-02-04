//
//  MedicalTransferRouter.swift
//  TransfersVIP
//
//  Created by psuser on 10/1/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

protocol MedicalTransferRouterInput: TransferRouterInput {}

class MedicalTransferRouter: MedicalTransferRouterInput {
    private var networkService: NetworkService
    private var title: String
    
    init(networkService: NetworkService,
         title: String
        ) {
        self.networkService = networkService
        self.title = title
    }
    
    func createModule(viewModel: OperationViewModel) -> UIViewController {
        guard let medicalViewModel = viewModel as? MedicalPaymentViewModel else { fatalError("medical not set")}
        let view = MedicalTransferViewController(viewModel: medicalViewModel, title: title)
        
        let documentActionsService = DocumentActionsService(networkService: networkService, .domesticTransfer)
        
        let presenter: MedicalTransferPresenterInput = MedicalTransferPresenter(view: view)
        
        let interactor: MedicalTransferInteractorInput = MedicalTransferInteractor(presenter: presenter, networkService: networkService, documentActionsManager: documentActionsService, viewModel: medicalViewModel)
        
        view.interactor = interactor
        view.router = self
        return view
    }
}
