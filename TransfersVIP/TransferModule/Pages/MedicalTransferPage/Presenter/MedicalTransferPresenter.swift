//
//  File.swift
//  TransfersVIP
//
//  Created by psuser on 10/1/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

protocol MedicalTransferPresenterInput: BasePresenterInput {
}
class MedicalTransferPresenter {
    
    private(set) var view: BaseTransferViewControllerInput?
    
    init(view: MedicalTransferViewControllerInput) {
        self.view = view
    }
}
extension MedicalTransferPresenter: MedicalTransferPresenterInput {
}
