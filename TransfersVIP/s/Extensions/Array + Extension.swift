//
//  Array + Extension.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 1/31/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}

extension Array {
    mutating func move(from formIndex: Int, to toIndex: Int) {
        insert(remove(at: formIndex), at: toIndex)
    }
}

