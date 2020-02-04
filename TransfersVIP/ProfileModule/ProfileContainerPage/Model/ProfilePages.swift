//
//  ProfilePages.swift
//  TransfersVIP
//
//  Created by psuser on 10/11/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

enum ProfilePages: String, CaseIterable {
    case organization
    case notification
    case information
    
    var name: String {
        switch self {
        case .organization:
            return "Организация".uppercased()
        case .notification:
            return "Уведомления".uppercased()
        case .information:
            return "Информация".uppercased()
        }
    }
    
    var index: Int {
        switch self {
        case .information:
            return 0
        case .organization:
            return 1
        case .notification:
            return 2
        }
    }
}
