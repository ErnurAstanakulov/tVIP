//
//  String + ParameterEncoding.swift
//  DigitalBank
//
//  Created by Misha Korchak on 15.05.17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import Alamofire

extension String: ParameterEncoding {
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
}

extension Double: ParameterEncoding {
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        var value = self
        request.httpBody = Data(buffer: UnsafeBufferPointer(start: &value, count: 1))
        return request
    }
}

