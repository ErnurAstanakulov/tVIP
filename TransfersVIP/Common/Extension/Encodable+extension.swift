//
//  Encodable+extension.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/2/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation

extension Encodable {
    func asDictionary() -> [String: Any] {
        let data = try! JSONEncoder().encode(self)
        guard let dictionary = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            return [:]
        }
        return dictionary
    }
}
