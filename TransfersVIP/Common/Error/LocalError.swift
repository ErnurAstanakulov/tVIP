//
//  LocalError.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/10/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation

enum LocalError: AppError {
    case `default`(_ description: String)
    case unknown
    
    var description: String {
        switch self {
        case .default(let description):
            return description
        case .unknown:
            return "Возникла непредвиденная ошибка. Приносим свои извинения за доставленные неудобства."
        }
    }
}
