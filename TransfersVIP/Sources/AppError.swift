//
//  AppError.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 6/27/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

protocol AppError: Error {
    var description: String { get }
}
