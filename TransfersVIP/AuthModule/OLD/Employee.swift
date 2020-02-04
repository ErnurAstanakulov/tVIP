//
//  СoWorker.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 3/10/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift

class Employee: BaseModel {
    var firstName: String? { didSet { _firstName.onNext(firstName ?? "") } }
    var lastName: String? { didSet { _lastName.onNext(lastName ?? "")  } }
    var middleName: String? { didSet { _middleName.onNext(middleName ?? "") } }
    var taxCode: String? { didSet { taxCode.map { _taxCode.onNext($0) } } }
    var birthDate: String? { didSet { birthDate.map { _birthDate.onNext($0) } } }
    var account: String? { didSet { account.map { _account.onNext($0) } } }
    var amount: Double? 
    var period: String? { didSet { period.map { _period.onNext($0) } } }
    var reason: String? { didSet { period.map { _reason.onNext($0) } } }
    var payroll: Double? { didSet { payroll.map
        { _payroll.onNext($0) } } }
    var medical: Double? { didSet { medical.flatMap(Double.init).map
    { _medical.onNext($0) } } }
    var social: Double? { didSet { social.map
    { _social.onNext($0) } } }
    var pension: Double? { didSet { pension.map
    { _pension.onNext($0) } } }
    
    var payrollString: String?  { didSet { payrollString.flatMap(Double.init).map
    { _payroll.onNext($0) } } }
    var pensionString: String?  { didSet { pensionString.flatMap(Double.init).map
    { _pension.onNext($0) } } }
    var socialString: String?   { didSet { socialString.flatMap(Double.init).map
    { _social.onNext($0) } } }
    var medicalString: String?  { didSet { medicalString.flatMap(Double.init).map
    { _medical.onNext($0) } } }
    
    var _firstName = StringSubject(1)
    var _lastName = StringSubject(1)
    var _middleName = StringSubject(1)
    var _birthDate = StringSubject(1)
    var _taxCode = StringSubject(1)
    var _account = StringSubject(1)
    var _period = StringSubject(1)
    var _reason = StringSubject(1)
    var _payroll = DoubleSubject(1)
    var _medical = DoubleSubject(1)
    var _social = DoubleSubject(1)
    var _pension = DoubleSubject(1)
    
    
    //Additional custom properties
    var _isSelected = BoolSubject(1)
    var isSelected: Bool = false { didSet { _isSelected.onNext(isSelected) } }
    
    public var fullName: String {
        return String(format: "%@ %@ %@", self.lastName ?? "", self.firstName ?? "", self.middleName ?? "")
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        middleName <- map["middleName"]
        taxCode <- map["taxCode"]
        birthDate <- map["birthDate"]
        account <- map["account"]
        period <- map["period"]
        reason <- map["reason"]
        payrollString <- map["amountPayroll"]
        socialString <- map["amountSocial"]
        pensionString <- map["amountPension"]
        medicalString <- map["amountMedical"]
        if let payroll = payrollString {
            self.payroll = Double(payroll)
        }
        if let social = socialString {
            self.social = Double(social)
        }
        if let pension = pensionString {
            self.pension = Double(pension)
        }
        if let medical = medicalString {
            self.medical = Double(medical)
        }
    }
    
    public func fillFromEmployee(_ employee: EmployeeSender) {
        self.id = employee.id
        self.firstName = employee.firstName
        self.lastName = employee.lastName
        self.middleName = employee.middleName
        self.taxCode = employee.taxCode
        self.birthDate = employee.birthDate
        self.account = employee.account
        self.period = employee.period

        self.isSelected = employee.checked ?? false
    }
}

