//
//  Actions.swift
//  DigitalBank
//
//  Created by Misha Korchak on 10.07.17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation

struct ParsedActions {
    
    enum Actions: String, Decodable {
        case bad = "bad"
        case remove = "remove"
        case sentToRBS = "sentToRBS"
        case toDraft = "toDraft"
        case sign = "sign"
        case submit = "submit"
        case pay = "pay"
        case reject = "reject"
        case edit = "edit"
        case editTemplate = "editTemplate"
        case view = "view"
        case history = "history"
        case creteCopy = "creteCopy"
        case print = "print"
        case createStandingOrder
        case sentForRevokation = "sentForRevokation"
        case sentToReceiver
        case activate
        case suspend
        case rate
        case signRate
        case roughCopy
        
        var documentDetailsLocalizedValue: String {
            switch self {
            case .bad: return "Отправить в непринятые"
            case .remove: return "Удалить"
            case .sentToRBS: return "Отправить в банк"
            case .toDraft: return "Вернуть на доработку"
            case .sign: return "Подписать"
            case .submit: return "Отправить на подписание"
            case .pay: return "Оплатить"
            case .reject: return "Отказать"
            case .edit: return "Сохранить документ"
            case .editTemplate: return "Сохранить шаблон"
            case .view: return "Просмотр"
            case .history: return "История"
            case .creteCopy: return "Создать копию"
            case .print: return "Печать"
            case .createStandingOrder: return "Создать регулярный перевод"
            case .sentForRevokation: return "Отозвать"
            case .activate: return "Активировать"
            case .suspend: return "Приостановить"
            case .sentToReceiver: return "Отправить получателю"
            case .rate: return "Запросить курс"
            case .signRate: return "Сохранить"
            case .roughCopy: return "Черновик"
            }
        }
    }
    
    enum LocalizedActions: String, Codable {
        case sentForRevokation = "Отозвать"
        case bad = "Отправить в непринятые"
        case remove = "Удалить"
        case sentToRBS = "Отправить в банк"
        case toDraft = "Вернуть на доработку"
        case sign = "Подписать"
        case submit = "Отправить на подписание"
        case pay = "Оплатить"
        case reject = "Отказать"
        case edit = "Изменить"
        case editTemplate = "Редактировать как шаблон"
        case view = "Просмотр"
        case history = "История"
        case creteCopy = "Создать копию"
        case print = "Печать"
        case createStandingOrder = "Создать регулярный перевод"
        case activate = "Активировать"
        case suspend = "Приостановить"
        case sentToReceiver = "Отправить получателю"
        case rate = "Запросить курс"
        case signRate = "Подтвердить"
        case roughCopy = "Черновик"
    }
    
    var aviableActions: [ParsedActions.Actions] = []
    var aviableLocalizedActions: [ParsedActions.LocalizedActions] = []
    

    init(_ model: [ActionStyle]) {
        let actions = model.map { $0.name }
       self.aviableActions =  getActions(actions)
        self.aviableLocalizedActions = getLocalizedActions(self.aviableActions)
    }
    
    init(_ actions: AnyDict?) {
        self.aviableActions = getActions(getArrayOfKeys(actions))
        self.aviableLocalizedActions = getLocalizedActions(self.aviableActions)
    }
    
    private func getArrayOfKeys(_ dictionary: AnyDict?) -> [String] {
        guard let actions = dictionary else { return [] }
        var array: [String] = []
        actions.forEach { (key, _) in
            array.append(key)
        }
        
        return array
    }
    
    private func getActions(_ array: [String]) -> [ParsedActions.Actions] {
        var actions: [ParsedActions.Actions] = []
        array.forEach({
            guard let action = Actions(rawValue: $0) else { return }
            actions.append(action)
        })
        
        return actions
    }
    
    private func getLocalizedActions(_ actions: [ParsedActions.Actions]) -> [ParsedActions.LocalizedActions] {
        var currentActions: [ParsedActions.LocalizedActions] = []
        actions.forEach({
            switch $0 {
            case .view: currentActions.append(.view)
            case .sentForRevokation: currentActions.append(.sentForRevokation)
            case .bad: currentActions.append(.bad)
            case .remove: currentActions.append(.remove)
            case .sentToRBS: currentActions.append(.sentToRBS)
            case .toDraft: currentActions.append(.toDraft)
            case .sign: currentActions.append(.sign)
            case .submit: currentActions.append(.submit)
            case .pay: currentActions.append(.pay)
            case .reject: currentActions.append(.reject)
            case .edit: currentActions.append(.edit)
            case .editTemplate: currentActions.append(.editTemplate)
            case .history: currentActions.append(.history)
            case .creteCopy: currentActions.append(.creteCopy)
            case .print: currentActions.append(.print)
            case .createStandingOrder: currentActions.append(.createStandingOrder)
            case .activate: currentActions.append(.activate)
            case .suspend: currentActions.append(.suspend)
            case .sentToReceiver: currentActions.append(.sentToReceiver)
            case .rate: currentActions.append(.rate)
            case .signRate: currentActions.append(.signRate)
            case .roughCopy: currentActions.append(.roughCopy)
            }
        })
        
        return currentActions
    }
    
    static func localizationForAction(_ action: ParsedActions.Actions) -> ParsedActions.LocalizedActions {
        switch action {
        case .view: return .view
        case .sentForRevokation: return .sentForRevokation
        case .bad: return .bad
        case .remove: return .remove
        case .sentToRBS: return .sentToRBS
        case .toDraft: return .toDraft
        case .sign: return .sign
        case .submit: return .submit
        case .pay: return .pay
        case .reject: return .reject
        case .edit: return .edit
        case .editTemplate: return .editTemplate
        case .history: return .history
        case .creteCopy: return .creteCopy
        case .print: return .print
        case .createStandingOrder: return .createStandingOrder
        case .activate: return .activate
        case .suspend: return .suspend
        case .sentToReceiver: return .sentToReceiver
        case .rate: return .rate
        case .signRate: return .signRate
        case .roughCopy: return .roughCopy
        }
    }
    
}
