//
//  TabBarPageInteractor.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/19/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation

class TabBarPageInteractor {
    private(set) var presenter: TabBarPagePresenterInput
    private var networkService: NetworkService
    
    init(presenter: TabBarPagePresenterInput, networkService: NetworkService) {
        self.presenter = presenter
        self.networkService = networkService
    }
}

extension TabBarPageInteractor: TabBarPageInteractorInput {
    
}
