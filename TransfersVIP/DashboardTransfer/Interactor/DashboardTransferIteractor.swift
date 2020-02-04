//
//  DashboardTransferIteractor.swift
//  TransfersVIP
//
//  Created by psuser on 29/08/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

class DashboardTransferIteractor {
    private(set) var presenter: DashboardTransferPresenterInput
    private var networkService: NetworkService
    
    init(
        presenter: DashboardTransferPresenterInput,
        networkService: NetworkService
        ) {
        self.presenter = presenter
        self.networkService = networkService
    }
}

extension DashboardTransferIteractor: DashboardTransferIteractorInput {
    
    func setPages() {
        presenter.setPages(with: [.new, .work, .template, .regular])
    }
}
