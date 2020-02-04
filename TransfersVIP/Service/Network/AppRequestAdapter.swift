//
//  AppRequestAdapter.swift
//  DigitalBank
//
//  Created by iosDeveloper on 11/8/16.
//  Copyright © 2016 iosDeveloper. All rights reserved.
//

import Alamofire

class AppRequestAdapter: RequestAdapter {
    
    var accessToken: String?
    var refreshToken: String?
    let userAgent: String = "mobile"
    let digitalBankDeviceKeySignature: String
    let appName = "Sberbank-iOS"
    var notificationToken: String?
    var encryptedUsername: String?
    
    init() {
        digitalBankDeviceKeySignature = GlobalFunctions.randomDigitStringAsDeviceKey()
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
        if let accessToken = accessToken {
            if urlRequest.allHTTPHeaderFields?["Authorization"] == nil {
                urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
            }
        }
        if let notificationToken = notificationToken {
            urlRequest.setValue(notificationToken, forHTTPHeaderField: "X-DigitalBank-application-id")
        }
        urlRequest.setValue(userAgent, forHTTPHeaderField: "IBankUser-Agent")
        urlRequest.setValue(digitalBankDeviceKeySignature, forHTTPHeaderField: "X-DigitalBank-device-id")
        urlRequest.setValue(appName, forHTTPHeaderField: "X-DigitalBank-app-name")
        
        let language = AppState.sharedInstance.language.localizationHeader
        urlRequest.setValue("TRANSLATE_LANGUAGE=" + language, forHTTPHeaderField: "Cookie")
        
        return urlRequest
    }
}

extension RequestAdapter {
    
    func closeSession() {
        if let adapter = self as? AppRequestAdapter {
            adapter.accessToken = nil
        }
    }
    
}
