//
//  Event.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 2/20/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift

class Event: NSObject, Mappable {
    var id: Int!
    var deleted: Bool?
    var executor_customer: User?
    var executor_manager: Manager?
    var when: Date?
    var channel: String?
    var terminal: String?
    var manager_action: String?
    var customer_action: String?
    var status: String?
    var subjectId: Int?
    var comment: String?
    var uaData: UaData?
    
    required init?(map: Map) {
        if map.JSON["id"] == nil {
            return nil
        }
        
        super.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        deleted <- map["deleted"]
        executor_customer <- map["executor_customer"]
        executor_manager <- map["executor_manager"]
        when <- (map["when"], EventDateTransform())
        channel <- map["channel"]
        terminal <- map["terminal"]
        manager_action <- map["manager_action"]
        customer_action <- map["customer_action"]
        status <- map["status"]
        subjectId <- map["subjectId"]
        comment <- map["comment"]
        uaData <- map["uaData"]
    }
}

class UaData: Mappable {
    var deviceCategory: String?
    var browser: String?
    var operatingSystem: String?
    
    required init?(map: Map) {
    
    }
    
    func mapping(map: Map) {
        deviceCategory <- map["deviceCategory"]
        browser <- map["browser"]
        operatingSystem <- map["operatingSystem"]
    }
}

class EventDateTransform: TransformType {
    let dateFormatter = DateFormatter()
    public init() {
        self.dateFormatter.dateFormat = "dd.MM,yyyy HH:mm"
    }
    
    public typealias Object = Date
    public typealias JSON = String
    
    func transformFromJSON(_ value: Any?) -> Date? {
        guard let dateString = value as? String else { return nil }
        return self.dateFormatter.date(from: dateString)
    }
    
    func transformToJSON(_ value: Date?) -> String? {
        guard let date = value else { return nil }
        return self.dateFormatter.string(from: date)
    }
}

class User: BaseModel {
    var defaultOrgName: String? { didSet { defaultOrgName.map { rxDefaultOrgName.onNext($0) } } }
    var email: String? { didSet { email.map { rxEmail.onNext($0) } } }
    var fullName: String? { didSet { fullName.map { rxFullName.onNext($0) } } }
    var login: String? { didSet { login.map { rxLogin.onNext($0) } } }
    var phone: String? { didSet { phone.map { rxPhone.onNext($0.getMaskedPhone() ?? "") } } }
    var position: String? { didSet { position.map { rxPosition.onNext($0) } } }
    var require_sms: Bool?
    
    
    var rxEmail = StringSubject(1)
    var rxPhone = StringSubject(1)
    var rxDefaultOrgName = StringSubject(1)
    var rxFullName = StringSubject(1)
    var rxLogin = StringSubject(1)
    var rxPosition = StringSubject(1)
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        defaultOrgName <- map["defaultOrgName"]
        email <- map["email"]
        fullName <- map["fullName"]
        login <- map["login"]
        phone <- map["phone"]
        position <- map["position"]
        require_sms <- map["require_sms"]
    }
}

extension String {
    
    func getMaskedPhone() -> String? {
        let phone = components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        guard !phone.isEmpty, phone.count == 10  else { return nil }
        let mask = "XXX) XXXXXXX"
        var index = phone.startIndex
        var maskedPhone = "+7 ("
        mask.forEach { (char) in
            if char == "X" {
                maskedPhone.append(phone[index])
                index = phone.index(after: index)
            }
            else {
                maskedPhone.append(char)
            }
        }
        return maskedPhone
    }
}
