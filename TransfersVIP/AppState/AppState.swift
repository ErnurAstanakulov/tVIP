//
//  File.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 1/31/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation

enum SelectedLanguage {
    case RUS
    case KZT
    case ENG
    
    var localizationHeader: String {
        switch self {
        case .RUS: return "ru"
        case .KZT: return "kk"
        case .ENG: return "en"
        }
    }
}

class AppState {
    //for defualt initialization
    static let sharedInstance = AppState()
    private init() {
    }
    
    //sharedInstance by defualt is unloggined
    public var isLoggined: Bool = false
    public var lastLogin: String? 
    
    public var language: SelectedLanguage = SelectedLanguage.RUS
    
    public var shouldAnimateToLoginWithTtansition = true
    public var shouldUpdateAccounts = false
    public var config: AppConfig?
}
