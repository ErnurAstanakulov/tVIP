//
//  DateFormat.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/3/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

public enum DateFormat {
    case ddMMyyyy(separator: String)
    case yyyyMMdd(separator: String)
    case ddMMMMyyyy(separator: String)
    case MMddyyyy(separator: String)
    
    var string: String {
        switch self {
        case .ddMMyyyy(let seperator):
            return ["dd", "MM", "yyyy"].joined(separator: seperator)
        case .yyyyMMdd(let separator):
            return ["yyyy", "MM", "dd"].joined(separator: separator)
        case .ddMMMMyyyy(let separator):
            return ["dd", "MMMM", "yyyy"].joined(separator: separator)
        case .MMddyyyy(let separator):
            return ["MM", "dd", "yyyy"].joined(separator: separator)
        }
    }
}
