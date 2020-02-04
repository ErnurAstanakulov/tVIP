//
//  ProfileContainerPresenterInput.swift
//  TransfersVIP
//
//  Created by psuser on 10/14/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

protocol ProfileContainerPresenterInput: BasePresenterInputProtocol {
    func setProfilePages(_ pages: [ProfilePages])
}

class ProfileContainerPresenter: ProfileContainerPresenterInput {
    
    private(set) var view: ProfileContainerViewInput
    var baseView: BaseViewInputProtocol {
        return view
    }
    
    init(view: ProfileContainerViewInput) {
        self.view = view
    }
    
}
extension ProfileContainerPresenter {
    func setProfilePages(_ pages: [ProfilePages]) {
        view.setProfilePages(pages)
    }
}
