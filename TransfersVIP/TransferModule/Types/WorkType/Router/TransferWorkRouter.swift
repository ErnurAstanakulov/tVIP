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
    var view: TransferWorkViewController?

    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}
extension TransferWorkRouter: TransferWorkRouterInput {
    
    func createModule() -> UIViewController {
        let navigationController = UINavigationController(rootViewController: TransferWorkViewController())
        guard let view = navigationController.topViewController as? TransferWorkViewController else { return UIViewController() }
        let presenter = TransferWorkPresenter(view: view)
        let documentActionsService = DocumentActionsService(networkService: networkService)
        let iteractor = TransferWorkIteractor(presenter: presenter, documentActionsService: documentActionsService)
        view.iteractor = iteractor
        view.router = self
        self.view = view
        return view
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
        case is PaymentRevokeViewModel:
            router = RevokeTransferRouter(networkService: networkService, title: title)
        default:
            fatalError("TransferRouter not set")
        }
        
        view?.navigationController?.pushViewController(router.createModule(viewModel: viewModel), animated: true)
    }
    
    func pushHistoryViewController(id: Int) {
        let controller = UINib.controller(controller: DocumetnHistoryViewController.self)
        if let controller = controller {
            controller.documentID = id
            view?.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
