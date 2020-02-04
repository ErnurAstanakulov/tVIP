//
//  TransferNewRouter.swift
//  TransfersVIP
//
//  Created by psuser on 30/08/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import UIKit

class TransferNewRouter {
//    private(set) weak var view: TransferNewController?

}

extension TransferNewRouter: TransferNewRouterInput {
    func createModule() -> UIViewController {
        let view = UINavigationController(rootViewController: TransferNewController())
        guard let viewController = view.topViewController as? TransferNewController else { return UIViewController() }
        let presenter = TransferNewPresenter(view: viewController)
        let iteractor = TransferNewIteractor(presenter: presenter)
        
        viewController.iteractor = iteractor
        viewController.router = self

//        self.view = view
        return viewController
    }
}
