////
////  TabBarPageRouter.swift
////  DigitalBank
////
////  Created by Adilbek Mailanov on 7/19/19.
////  Copyright © 2019 iosDeveloper. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//class TransferRouter {
//    private(set) weak var view: TransferViewController?
//    private var networkService: NetworkService
//
//    init(networkService: NetworkService) {
//        self.networkService = networkService
//    }
//}
//
//extension TransferRouter: TransferRouterInput {
//    func createModule() -> UIViewController {
//        let view = TransferViewController()
//        let presenter = TransferPresenter(view: view)
//        let interactor = TransferInteractor(
//            presenter: presenter,
//            networkService: networkService
//        )
//        view.interactor = interactor
//        view.router = self
//
//        return view
//    }
//}
