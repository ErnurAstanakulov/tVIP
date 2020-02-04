//
//  Pages.swift
//  TransfersVIP
//
//  Created by psuser on 29/08/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

enum Pages: String, CaseIterable {
    case new
    case work
    case template
    case regular
    
    var name: String {
        switch self {
        case .new:
            return "Новый"
        case .work:
            return "Рабочие"
        case .template:
            return "Шаблоны"
        case .regular:
            return "Регулярные"
        }
    }
    
    var index: Int {
        switch self {
        case .new:
            return 0
        case .work:
            return 1
        case .template:
            return 2
        case .regular:
            return 3
        }
    }
    
    var documentType: String {
        switch self {
        case .work:
            return "WORK"
        case .template:
            return "TEMPLATE"
        default: return self.rawValue
        }
    }
}
