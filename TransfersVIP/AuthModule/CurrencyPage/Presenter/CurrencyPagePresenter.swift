//
//  CurrencyPagePresenter.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/12/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

class CurrencyPagePresenter {
    private(set) unowned var view: CurrencyViewInput
    
    init(view: CurrencyViewInput) {
        self.view = view
    }
}

extension CurrencyPagePresenter: CurrencyPagePresenterInput {
    var baseView: BaseViewInputProtocol {
        return view
    }
    
    func show(currencyItemList: [CurrencyItem]) {
        view.show(currencyItemList: currencyItemList)
    }
    
    func clearList() {
        view.clearList()
    }
    
    func endRefreshing() {
        view.endRefreshing()
    }
}
