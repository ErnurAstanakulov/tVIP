//
//  DashboardTransferPresenter.swift
//  TransfersVIP
//
//  Created by psuser on 29/08/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

class DashboardTransferPresenter {
    private(set) var view: TransferPageContainerViewControllerInput
    init(view: TransferPageContainerViewControllerInput) {
        self.view = view
    }
}

extension DashboardTransferPresenter: DashboardTransferPresenterInput {
    func setPages(with pages: [Pages]) {
        view.setPages(with: pages)
    }
}
