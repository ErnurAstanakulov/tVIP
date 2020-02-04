//
//  WorkFlowDocumentNetworkContext.swift
//  TransfersVIP
//
//  Created by psuser on 10/1/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

class WorkFlowDocumentNetworkContext: NetworkContext {
    var route: Route = .apiWorkflowDocumentAction
    var method: NetworkMethod = .post
    var encoding: NetworkEncoding = .json
    var parameters: [String: Any] { return [
        "documentId": documentId,
        "documentType": documentType,
        "action": actionName
        ]}
    
    private let documentId: Int
    private let actionName: String
    private let documentType: String
    
    init(documentId: Int, documentType: String, actionName: String) {
        self.documentId = documentId
        self.documentType = documentType
        self.actionName = actionName
    }
}

