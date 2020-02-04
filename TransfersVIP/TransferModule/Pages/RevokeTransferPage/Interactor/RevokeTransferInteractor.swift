//
//  RevokeTransferInteractor.swift
//  TransfersVIP
//
//  Created by psuser on 10/5/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

protocol RevokeTransferInteractorInput: BaseSetTransferInteractorInput {
}

class RevokeTransferInteractor: RevokeTransferInteractorInput, BaseTransferInteractorInput  {
    
    typealias viewModelType = PaymentRevokeViewModel
    var viewModel: PaymentRevokeViewModel
    
    required init(presenter: BasePresenterInput, networkService: NetworkService, documentActionsManager: DocumentActionsService, viewModel: PaymentRevokeViewModel) {
        self.presenter = presenter
        self.networkService = networkService
        self.documentActionsManager = documentActionsManager
        self.viewModel = viewModel
        self.viewModel.documentActionDataArray = Array(defaultActions.dropLast())
    }
    
    var presenter: BasePresenterInput
    
    var networkService: NetworkService
    
    var documentActionsManager: DocumentActionsService
}
