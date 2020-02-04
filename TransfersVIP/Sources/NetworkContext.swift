//
//  NetworkContext.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 6/27/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation

protocol NetworkContext {
    var route: Route { get }
    var method: NetworkMethod { get }
    var parameters: [String: Any] { get }
    var encoding: NetworkEncoding { get }
    var httpBody: Data? { get }
    var header: [String: String] { get }
}

extension NetworkContext {
    
    var urlString: String { return route.urlString }
    
    var parameters: [String: Any] { return [:] }
    
    var encoding: NetworkEncoding { return .url }
    
    static func encode<T: Codable>(_ object: T) -> Any? {
        if let data = try? JSONEncoder().encode(object) {
            return try? JSONSerialization.jsonObject(with: data)
        }
        return nil
    }
    
    var httpBody: Data? { return nil }
    
    var header: [String: String] { return [:] }
}
