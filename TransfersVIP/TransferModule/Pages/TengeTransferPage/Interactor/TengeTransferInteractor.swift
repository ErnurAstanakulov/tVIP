//
//  TengeTransferInteractor.swift
//  TransfersVIP
//
//  Created by psuser on 23/09/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

protocol TengeTransferInteractorInput: BaseSetTransferInteractorInput {
}

class TengeTransferInteractor: TengeTransferInteractorInput, BaseTransferInteractorInput {
   
    typealias viewModelType = DomesticTransferViewModel
    var viewModel: DomesticTransferViewModel = DomesticTransferViewModel()
    
    required init(presenter: BasePresenterInput, networkService: NetworkService, documentActionsManager: DocumentActionsService, viewModel: DomesticTransferViewModel) {
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
