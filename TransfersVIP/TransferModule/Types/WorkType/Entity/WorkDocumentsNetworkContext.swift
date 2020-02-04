//
//  WorkDocumentsNetworkContext.swift
//  TransfersVIP
//
//  Created by psuser on 03/09/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

class WorkDocumentsNetworkContext: NetworkContext {
    var route: Route = .apiCustomerDocumentsWork
    var method: NetworkMethod = .get
    var encoding: NetworkEncoding = .urlString
    var parameters: [String: Any] {
        var params:  [String: Any] = [
            "sort" : "document.updated",
            "order" : "desc",
            "documentKind" : page.documentType,
            "page": pageToLoad,
            "size": Constants.objectsToLoad
        ]
        if let types = documentTypes {
            params["types"] = types.map { $0.rawValue }.joined(separator: ",")
        }
        return params
    }

    private let documentTypes: [Constants.DocumentType]?
    private let pageToLoad: Int
    private let page: Pages
    
    init(_ pageToLoad: Int, page: Pages, documentTypes: [Constants.DocumentType]) {
        self.page = page
        self.documentTypes = documentTypes
        self.pageToLoad = pageToLoad
    }
}
