//
//  TransferWorkRouter.swift
//  TransfersVIP
//
//  Created by psuser on 31/08/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import UIKit

class TransferWorkRouter {
    private var networkService: NetworkService
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}
extension TransferWorkRouter: TransferWorkRouterInput {
    func createModule() -> UIViewController {
        let view = UINavigationController(rootViewController: TransferWorkViewController())
        guard let viewController = view.topViewController as? TransferWorkViewController else { return UIViewController() }
        let presenter = TransferWorkPresenter(view: viewController)
        let iteractor = TransferWorkIteractor(presenter: presenter, networkService: networkService)
        viewController.iteractor = iteractor
        viewController.router = self
//        self.view = view
        return viewController
    }
    
    
}
