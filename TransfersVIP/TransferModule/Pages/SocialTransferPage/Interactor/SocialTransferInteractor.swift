//
//  SocialTransferInteractor.swift
//  TransfersVIP
//
//  Created by psuser on 10/1/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

protocol SocialTransferInteractorInput: BaseSetTransferInteractorInput {
}

class SocialTransferInteractor: SocialTransferInteractorInput, BaseTransferInteractorInput  {
    
    typealias viewModelType = SocialPaymentViewModel
    var viewModel: SocialPaymentViewModel
    
    required init(presenter: BasePresenterInput, networkService: NetworkService, documentActionsManager: DocumentActionsService, viewModel: SocialPaymentViewModel) {
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
