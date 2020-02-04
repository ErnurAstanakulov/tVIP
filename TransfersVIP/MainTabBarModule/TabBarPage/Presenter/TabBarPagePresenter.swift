//
//  TabBarPagePresenter.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/19/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation

class TabBarPagePresenter {
    private(set) unowned var view: TabBarViewInput
    
    init (view: TabBarViewInput) {
        self.view = view
    }
}

extension TabBarPagePresenter: TabBarPagePresenterInput {
    var baseView: BaseViewInputProtocol {
        return view
    }
    
    
}
