//
//  ContributionViewModel.swift
//  DigitalBank
//
//  Created by Алем Утемисов on 12.05.2018.
//  Copyright © 2018 iosDeveloper. All rights reserved.
//

import Foundation

protocol ContributionViewModel {
    var employees: [Employee] {set get}
    var initialDocument: DomesticTransfer? {get set}
    var documentType: String {get}
    
    /// Condition where employees shouldn't be displayed at all
    var canViewEmployees: Bool { get set }
    
    func calculateSumEmployees() -> String
}

extension ContributionViewModel {
    func calculateSumEmployees() -> String {
        let amount: Double
        switch documentType {
        case Constants.paymentsTypes[1]:
            amount = employees.compactMap {  $0.payroll }.reduce(0, +)
        case Constants.paymentsTypes[2]:
            amount = employees.compactMap {  $0.pension }.reduce(0, +)
        case Constants.paymentsTypes[3]:
            amount = employees.compactMap {  $0.social }.reduce(0, +)
        case Constants.paymentsTypes[4]:
            amount = employees.compactMap {  $0.medical }.reduce(0, +)
        default:
            amount = 0
            break
        }
        return String(format: "%.2f", amount)
    }
}
