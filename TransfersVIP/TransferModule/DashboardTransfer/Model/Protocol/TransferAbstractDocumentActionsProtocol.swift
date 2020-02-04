//
//  TransferAlertProtocol.swift
//  TransfersVIP
//
//  Created by psuser on 03/09/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

protocol TransferAbstractDocumentActionsProtocol {
    func performRemoteAction(_ actionKey: ParsedActions.Actions, documentId: Int, documentType: Constants.DocumentType)
    func showDocument(document: WorkDocumentsModel, createRegular: Bool, toEdit: Bool, isCopy: Bool)
    func performAuthFactors(documentIds: [Int], authFactors: [Constants.AuthentificationType])
    func showHistoryViewController(id: Int)
    func documentRevocation(document: WorkDocumentsModel)
}
