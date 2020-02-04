//
//  NetworkResponse.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 6/27/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation

protocol NetworkResponse {
    var isSuccess: Bool { get }
    var data: Data? { get }
    var networkError: NetworkError? { get }
}

extension NetworkResponse {
    
    var json: [String: Any]? {
        guard let data = data,
            let result = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            else { return nil }
        return result
    }
    
    var string: String? {
        guard let data = data else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    func decode<T: Decodable>() -> T? {
        guard let data = data else {
            return nil
        }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            dump(error)
            return nil
        }
    }
}
