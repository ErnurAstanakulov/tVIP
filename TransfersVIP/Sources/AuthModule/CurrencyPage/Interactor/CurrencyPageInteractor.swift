//
//  CurrencyPageInteractor.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/12/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

class CurrencyPageInteractor {
    private(set) var presenter: CurrencyPagePresenterInput
    private var networkService: NetworkService
    
    init(presenter: CurrencyPagePresenterInput, networkService: NetworkService) {
        self.presenter = presenter
        self.networkService = networkService
    }
}

extension CurrencyPageInteractor: CurrencyPageInteractorInput {
    func loadCurrencyList() {
        loadList(loadable: true) { [weak self] (currencyItemList) in
            guard let self = self, let currencyItemList = currencyItemList else {
                return
            }
            self.presenter.show(currencyItemList: currencyItemList)
        }
    }
    
    func onRefresh() {
        loadList(loadable: false) { [weak self] (currencyItemList) in
            guard let self = self, let currencyItemList = currencyItemList else {
                return
            }
            self.presenter.clearList()
            self.presenter.show(currencyItemList: currencyItemList)
            self.presenter.endRefreshing()
        }
    }
}

extension CurrencyPageInteractor {
    private func loadList(loadable: Bool, complation: @escaping ([CurrencyItem]?) -> ()) {
        let context = CurrencyListNetworkContext()
        if (loadable) {
            presenter.startLoading()
        }
        networkService.load(context: context) { [weak self] (networkResponse) in
            guard let self = self else {
                return
            }
            self.presenter.stopLoading()
            
            guard networkResponse.isSuccess else {
                self.presenter.showError(error: networkResponse.networkError ?? .unknown)
                complation(nil)
                return
            }
            
            guard let currencyItemList: [CurrencyItem] = networkResponse.decode() else {
                self.presenter.showError(error: NetworkError.dataLoad)
                complation(nil)
                return
            }
        
            complation(currencyItemList)
        }
    }
}
