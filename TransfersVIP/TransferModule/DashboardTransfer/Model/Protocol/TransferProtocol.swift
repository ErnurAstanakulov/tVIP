//
//  WorkDocumentsModelChecked.swift
//  TransfersVIP
//
//  Created by psuser on 02/09/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

protocol TransferProtocol where Self: Decodable {
    var id: Int { get }
    var isChecked: Bool { get set}
    var actions: [ParsedActions.Actions]? { get }
    var documentType: Constants.DocumentType? { get }
    var signFactors: [String]? { get }
}


//class LongTermAssigment: WorkDocumentsModel {
//    var periodic: Int?
//    var startDate: String?
//    var standingDate: String?
//    var finishDate: String?
//    var payerAccountNum: String?
//    var beneficiaryName: String?
//    var beneficiaryAccount: String?
//    var beneficiaryTaxCode: String?
//    var beneficiaryBankCode: String?
//    var currencyOut: String?
//    var currencyIn: String?
//    var draftAmount: Double?
//    var draftDocNumber: String?
//    var accountForTrans: String?
//    var domesticTransferType: String?
//    var orderState: String?
////    var type: [String: Any]?
//    override var documentType: Constants.DocumentType? {
//        return .standingOrder
//    }
//}
