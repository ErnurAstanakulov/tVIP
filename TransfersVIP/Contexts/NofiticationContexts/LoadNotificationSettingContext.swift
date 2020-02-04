//
//  NotificationSettingContext.swift
//  DigitalBank
//
//  Created by iosDeveloper on 7/13/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation

class NotificationSettingContext<NotificationSettings>: GenericContext<NotificationSettings> {
    public var notificationModel: NotificationModel?
    
    override func urlString() -> String {
        guard let stringID = notificationModel?.id else { return "" }
        return baseURL + "api/notifications/properties/\(String(stringID))"
    }
}
