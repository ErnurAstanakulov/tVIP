//
//  AppImage.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/4/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation

enum AppImage: String, ImageProtocol {
    case hideKeyboardIcon
    case backgroundNurlytau
    case logo
    case logoFull
    case menuPage
    case briefcase
    case editPage
    case exchangePage
    case home
    case arrowDown
    case arrowBack
    case dollar
    case newspaper
    case position
    case opportunity
    case information
    case productBank
    case money
    case contract
    case ready
    case arrowDownLight
    case open
    case close
    case accountBackground
    case depositBackground
    case creditBackground
    case bankBackground
    case contractBackground
    case taskBackground
    case cardBackground
    case logoNew
    case tengeTransfer
    case conversionTransfer
    case internalTransfer
    case internationalTransfer
    case payrollTransfer
    case pensionTransfer
    case socialTransfer
    case medicalTransfer
    case createTransfer
    case unpaid
    case error
    case moreTransfer
    case pencilEdit
    case blockOrganization
    case search
    case cancel
    case checkOff
    case checkOn
    
    var bundle: Bundle? {
        return nil
    }
}
