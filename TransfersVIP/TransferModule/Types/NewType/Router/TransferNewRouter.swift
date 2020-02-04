//
//  TransferNewRouter.swift
//  TransfersVIP
//
//  Created by psuser on 30/08/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import UIKit

class TransferNewRouter {

    private var networkService: NetworkService
    private(set) weak var view: TransferNewController?

    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension TransferNewRouter: TransferNewRouterInput {
    func createModule() -> UIViewController {
        let view = BaseNavigationController(rootViewController: TransferNewController())
        guard let viewController = view.topViewController as? TransferNewController else { return UIViewController() }
        let presenter = TransferNewPresenter(view: viewController)
        let iteractor = TransferNewIteractor(presenter: presenter)
        
        viewController.iteractor = iteractor
        viewController.router = self

        self.view = viewController
        return viewController
    }
    
    func pushNewTransfer(viewModel: OperationViewModel, with title: String) {
        
        let router: TransferRouterInput
        switch viewModel {
        case is DomesticTransferViewModel:
            router = TengeTransferRouter(networkService: networkService, title: title)
        case is PayrollPaymentViewModel:
            router = PayrollTransferRouter(networkService: networkService, title: title)
        case is PensionPaymentViewModel:
            router = PensionTransferRouter(networkService: networkService, title: title)
        case is SocialPaymentViewModel:
            router = SocialTransferRouter(networkService: networkService, title: title)
        case is MedicalPaymentViewModel:
            router = MedicalTransferRouter(networkService: networkService, title: title)
        case is InternalTransferViewModel:
            router = InternalTransferRouter(networkService: networkService, title: title)
        case is InternationalTransferViewModel:
            router = InternationalTransferRouter(networkService: networkService, title: title)
        case is ConversionViewModel:
            router = ConversionTransferRouter(networkService: networkService, title: title)
        default:
            fatalError("TransferRouter not set")
        }
        
        view?.navigationController?.pushViewController(router.createModule(viewModel: viewModel), animated: true)
    }
}
