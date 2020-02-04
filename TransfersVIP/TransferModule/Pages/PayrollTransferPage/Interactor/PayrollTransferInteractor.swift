//
//  PayrollTransferInteractor.swift
//  TransfersVIP
//
//  Created by psuser on 24/09/2019.
//  Copyright © 2019 psuser. All rights reserved.
//
import Foundation

protocol PayrollTransferInteractorInput: BaseSetTransferInteractorInput {
}

class PayrollTransferInteractor: PayrollTransferInteractorInput, BaseTransferInteractorInput  {
    
    typealias viewModelType = PayrollPaymentViewModel
    var viewModel: PayrollPaymentViewModel
    
    required init(presenter: BasePresenterInput, networkService: NetworkService, documentActionsManager: DocumentActionsService, viewModel: PayrollPaymentViewModel) {
        self.presenter = presenter
        self.networkService = networkService
        self.documentActionsManager = documentActionsManager
        self.viewModel = viewModel
        self.viewModel.documentActionDataArray = defaultActions
    }
    
    var presenter: BasePresenterInput
    
    var networkService: NetworkService
    
    var documentActionsManager: DocumentActionsService
}
