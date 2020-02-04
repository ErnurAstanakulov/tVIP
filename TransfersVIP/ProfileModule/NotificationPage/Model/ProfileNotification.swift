//
//  ProfileNotification.swift
//  TransfersVIP
//
//  Created by psuser on 10/18/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

struct ProfileNotification: Decodable {
    var id: Int
    var description: String?
    var isAllAccounts: Bool?
    var accounts: String?
    var certificate: String?
    var isAllDocumentTypes: Bool?
    var documentTypes: String?
    var isAllStatuses: Bool?
    var statuses: String?
    var isAllChannels: Bool?
    var channels: String?
}

struct NotificationProperty: Codable {
    var fields: [String]?
    var description: String?
    var typeId: Int?
    var notificationPeriod: Int?
    var certificate_id: String?
    var amount: Double?
    var id: Int
    
    var statuses: [NotificationItem]?
    var documentTypes: [NotificationItem]?
    var accounts: [NotificationItem]?
    var channels: [NotificationItem]?
    
    var isAllDocumentTypes: Bool?
    var isAllStatuses: Bool?
    var isAllChannels: Bool?
    var isAllAccounts: Bool?
}

struct NotificationItem: Codable, SelectionType {
    var code: String?
    var label: String?
    var isChecked: Bool?
    
    enum CodingKeys: String, CodingKey {
        case label = "descriptions"
        case code, isChecked
    }
    
}
protocol SelectionType {
    var label: String? { get set }
    var isChecked: Bool? { get set }
}
