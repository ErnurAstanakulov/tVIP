//
//  LoadingResult.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/31/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation

enum LoadingResult<T> {
    case success(T)
    case error(AppError)
}
