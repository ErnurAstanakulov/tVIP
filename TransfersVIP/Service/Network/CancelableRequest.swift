//
//  CancelableRequest.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 6/27/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Alamofire

protocol CancelableRequest{
    func cancel()
    func resume()
}

extension DataRequest: CancelableRequest {}
