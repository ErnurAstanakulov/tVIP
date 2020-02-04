//
//  Date+extension.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/4/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation

extension Date {
    
    /// Convert Date to String with specified format
    ///
    /// - Parameter format: Date representation format
    /// - Returns: Date object as String
    public func string(withFormat dateFormat: DateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat.string
        return dateFormatter.string(from: self)
    }
    
    public func stringOfTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
}
