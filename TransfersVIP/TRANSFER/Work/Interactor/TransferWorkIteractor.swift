//
//  TransferWorkIteractor.swift
//  TransfersVIP
//
//  Created by psuser on 31/08/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import UIKit

class TransferWorkIteractor {
    private(set) var presenter: TransferWorkPresenterInput
    private var networkService: NetworkService
    
    init(presenter: TransferWorkPresenterInput, networkService: NetworkService) {
        self.presenter = presenter
        self.networkService = networkService
    }
    
    
}
extension TransferWorkIteractor: TransferWorkIteractorInput {
    func getWorkDocuments() {
        var parameters = mainParameters
        parameters.update(other: ["page" : self.pageToLoad, "size" : Constants.objectsToLoad])
        parameters.update(other: self.filterParameters)
        self.taskType.map({ parameters["state"] = $0.filterValue })
        let documentTypes = getDocumentTypes()
        parameters.update(other: ["types": documentTypes.map { $0.rawValue } .joined(separator: ",")])
        self.loadFromServer(url: self.mainURL, parameters: parameters, encoding: URLEncoding.queryString) {[weak self] response in
            guard let vc = self, let json = response as? [String : Any] else { return }
            guard let models = json["rows"] as? [[String : Any]] else { return }
            var localDataSource: [BaseDocumentModel] = []
            if (vc.pageToLoad != 0) {
                localDataSource = vc.workDocuments
            }
            models.forEach({
                BaseDocumentModel(JSON: $0).map({ localDataSource.append($0) })
            })
            vc.workDocuments = localDataSource
            print(vc.workDocuments.count)
        }
    }
}
