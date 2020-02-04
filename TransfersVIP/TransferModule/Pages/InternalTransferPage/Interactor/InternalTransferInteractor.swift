//
//  InternalTransferInteractor.swift
//  TransfersVIP
//
//  Created by psuser on 10/1/19.
//  Copyright © 2019 psuser. All rights reserved.
//
import Foundation

protocol InternalTransferInteractorInput: BaseSetTransferInteractorInput {
}

class InternalTransferInteractor: InternalTransferInteractorInput, BaseTransferInteractorInput  {
    
    typealias viewModelType = InternalTransferViewModel
    var viewModel: InternalTransferViewModel
    
    required init(presenter: BasePresenterInput, networkService: NetworkService, documentActionsManager: DocumentActionsService, viewModel: InternalTransferViewModel) {
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
