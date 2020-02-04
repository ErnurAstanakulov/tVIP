//
//  TransferWorkIteractorInput.swift
//  TransfersVIP
//
//  Created by psuser on 31/08/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

protocol TransferWorkIteractorInput: TransferAbstractDocumentsProtocol, SingFormInteractorInput {
    func showAlert(id: Int, _ selectedDocument: WorkDocumentsModel)
    func performPagination(index: Int)
    func onRefresh()
}

