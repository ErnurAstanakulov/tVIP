//
//  WorkDocumentsModel.swift
//  TransfersVIP
//
//  Created by psuser on 03/09/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation
struct DocumentType: Decodable {
    var code: Constants.DocumentType?
    var label: String?
    var subcode: Constants.PaymentTypes?
    var subLabel: String?
}

struct DomesticType: Decodable {
    var code: String?
    var label: String?
    var category: String?
}

struct WorkDocumentsModel: Decodable, TransferProtocol {
    var id: Int
    var payer: String?
    var payerAcc: String?
    var receiver: String?
    var receiverAcc: String?
    var number: String?
    var creation: String?
    var state: StateModel?
    var docType: DocumentType?
    var domesticType: DomesticType?
    var amount: Double?
    var currency: String?
    var isChecked: Bool = false
    var signActionModel: SignActionModel?
    var signFactors: [String]? {
        return signActionModel?.confirmation
    }
    var isTemplate: Bool?
    var templateName: String?
    var timeTo: String?
    var modelActions: [ActionStyle]?
    
    
    
    var documentType: Constants.DocumentType? {
        return self.docType?.code
    }
    
    var parsedActions: ParsedActions {
        return ParsedActions(modelActions!)
    }
    
    var actions: [ParsedActions.Actions]? {
        return parsedActions.aviableActions
    }
    
    var localizedActions: [ParsedActions.LocalizedActions] {
        return parsedActions.aviableLocalizedActions
    }
    
    enum CodingKeys: String, CodingKey {
        case modelActions = "actions"
        case docType = "type"
        case id, payer, payerAcc, receiver, receiverAcc, number, creation,state, domesticType, amount, currency, isChecked, isTemplate, templateName, timeTo
    }
    
    enum SignActionKey: String, CodingKey {
        case signActionModel
    }

     init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let baseContainer = try container.nestedContainer(keyedBy: ActionKey.self, forKey: .modelActions)
        var styles: [ActionStyle] = []
        for key in baseContainer.allKeys {
            styles.append(ActionStyle(name: key.stringValue))
            if key.stringValue == "sign" {
                signActionModel = try baseContainer.decode(SignActionModel?.self, forKey: key)
            }
        }
        self.modelActions = styles
        id = try container.decode(Int.self, forKey: .id)
        payer = try container.decodeIfPresent(String.self, forKey: .payer)
        payerAcc = try container.decodeIfPresent(String.self, forKey: .payerAcc)
        receiver = try container.decodeIfPresent(String.self, forKey: .receiver)
        receiverAcc = try container.decodeIfPresent(String.self, forKey: .receiverAcc)
        number = try container.decodeIfPresent(String.self, forKey: .number)
        creation = try container.decodeIfPresent(String.self, forKey: .creation)
        state = try container.decodeIfPresent(StateModel.self, forKey: .state)
        docType = try container.decodeIfPresent(DocumentType.self, forKey: .docType)
        domesticType = try container.decodeIfPresent(DomesticType.self, forKey: .domesticType)
        amount = try container.decodeIfPresent(Double.self, forKey: .amount)
        currency = try container.decodeIfPresent(String.self, forKey: .currency)
        isTemplate = try container.decodeIfPresent(Bool.self, forKey: .isTemplate)
        templateName = try container.decodeIfPresent(String.self, forKey: .templateName)
        timeTo = try container.decodeIfPresent(String.self, forKey: .timeTo)
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let id = try container.
//        self.modelActions = actions
    }
}

struct ActionStyle: Decodable {
    let name: String
//    let sign: SignActionModel?
}
//
//struct ActionsModel: Decodable {
//    var bad: EmptyModel?
//    var remove: EmptyModel?
//    var sentToRBS: EmptyModel?
//    var toDraft: EmptyModel?
//    var sign: EmptyModel?
//    var submit: EmptyModel?
//    var pay: EmptyModel?
//    var reject: EmptyModel?
//    var edit: EmptyModel?
//    var editTemplate: EmptyModel?
//    var view: EmptyModel?
//    var history: EmptyModel?
//    var creteCopy: EmptyModel?
//    var print: EmptyModel?
//    var createStandingOrder: EmptyModel?
//    var sentForRevokation: EmptyModel?
//    var sentToReceiver: EmptyModel?
//    var activate: EmptyModel?
//    var suspend: EmptyModel?
//    var rate: EmptyModel?
//    var signRate: SignActionModel?
//    var roughCopy: EmptyModel?
//    var dictionary: [String: Any] {
//        return [
//            "bad": bad ?? "",
//            "remove": remove ?? "",
//            "sentToRBS": sentToRBS ?? "",
//            "toDraft": toDraft ?? "",
//            "sign": sign ?? "",
//            "submit": submit ?? "",
//            "pay": pay ?? "",
//            "reject": reject ?? "",
//            "edit": edit ?? "",
//            "editTemplate": editTemplate ?? "",
//            "view": view ?? "",
//            "history": history ?? "",
//            "creteCopy": creteCopy ?? "",
//            "print": print ?? "",
//            "createStandingOrder": createStandingOrder ?? "",
//            "sentForRevokation": sentForRevokation ?? "",
//            "sentToReceiver": sentToReceiver ?? "",
//            "activate": activate ?? "",
//            "suspend": suspend ?? "",
//            "rate": rate ?? "",
//            "signRate": signRate ?? "",
//            "roughCopy": roughCopy ?? ""
//        ]
//    }
//
//}
struct ActionKey: CodingKey {
    var stringValue: String
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    var intValue: Int? { return nil }
    init?(intValue: Int) { return nil }
}
struct SignActionModel: Decodable {
    var confirmation: [String]?
    var preAuth: [String]?
}
