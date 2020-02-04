//
//  ChangeNotificationSettingsContext.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 7/15/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

class ChangeNotificationSettingsContext: GenericContext<NotificationSettings> {
    public var settings: NotificationSettings?
    
    public override func urlString() -> String {
        return baseURL + "api/notifications/properties"
    }
    
    // This function can be reloaded
    public override func parametres() -> [String: Any]? {
        guard let model = self.settings else { return nil }
        let json = model.toJSON()
//        print(json)
        return json
    }
    
    // By default .get, this function can be reloaded
    public override func HTTPMethod() -> HTTPMethod {
        return .put
    }
    
    // By default .URLEncoding.default, this function can be reloaded
    public override func encoding() -> ParameterEncoding {
        return JSONEncoding.default
    }
}
