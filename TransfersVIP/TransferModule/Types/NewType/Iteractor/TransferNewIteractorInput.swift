//
//  TransferNewIteractorInput.swift
//  TransfersVIP
//
//  Created by psuser on 30/08/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

protocol TransferNewIteractorInput: BaseInteractorInputProtocol {
    func setTitles()
    func createPaymentTransfer(index: Int)
}
