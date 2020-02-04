//
//  MenuPagePresenterInput.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/12/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation

protocol MenuPagePresenterInput: BasePresenterInputProtocol {
    func show(menuItemList: [MenuPageItem])
    func routeToCurrenciesModule()
    func routeToNewslettersModule()
    func routeToBranchesModule()
    func show(url: URL?)
}
