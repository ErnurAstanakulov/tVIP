//
//  PensionTransferInteractor.swift
//  TransfersVIP
//
//  Created by psuser on 13/09/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

protocol PensionTransferInteractorInput: BaseSetTransferInteractorInput {
}

class PensionTransferInteractor: PensionTransferInteractorInput, BaseTransferInteractorInput  {
    
    typealias viewModelType = PensionPaymentViewModel
    var viewModel: PensionPaymentViewModel
    
    required init(presenter: BasePresenterInput, networkService: NetworkService, documentActionsManager: DocumentActionsService, viewModel: PensionPaymentViewModel) {
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
