//
//  FailureNetworkResponse.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 6/27/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//
import UIKit
class FailureNetworkResponse: NetworkResponse {
    var isSuccess: Bool { return false }
    var data: Data? { return nil }
    var networkError: NetworkError?
    
    init(networkError: NetworkError) {
        self.networkError = networkError
    }
}
