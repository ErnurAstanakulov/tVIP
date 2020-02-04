//
//  AppRequestAdapter.swift
//  DigitalBank
//
//  Created by iosDeveloper on 11/8/16.
//  Copyright © 2016 iosDeveloper. All rights reserved.
//

import Alamofire

let userDefaults = UserDefaults.standard
func randomDigitStringAsDeviceKey() -> String {
    if let key = userDefaults.string(forKey: "DigitalBankDeviceKeySignature") {
        return key
    } else {
        let min: UInt32 = 100_000_000
        let max: UInt32 = 999_999_999
        let key = "\(min + arc4random_uniform(max - min + 1))"
        userDefaults.setValue(key, forKey: "DigitalBankDeviceKeySignature")
        userDefaults.synchronize()
        return key
    }
}
class AppRequestAdapter: RequestAdapter {
    
    var accessToken: String?
    var refreshToken: String?
    let userAgent: String = "mobile"
    let digitalBankDeviceKeySignature: String
    let appName = "Sberbank-iOS"
    var notificationToken: String?
    var encryptedUsername: String?

    init() {
        digitalBankDeviceKeySignature =
            randomDigitStringAsDeviceKey()
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
        
        urlRequest.setValue("TRANSLATE_LANGUAGE=RU", forHTTPHeaderField: "Cookie")
        
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
