//
//  LoadNotificationContext.swift
//  DigitalBank
//
//  Created by iosDeveloper on 7/12/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import Alamofire

class LoadNotificationsContext: Context {
    public override func urlString() -> String {
        return baseURL + "api/notifications/properties/?sort=id&order=asc"
    }
}
