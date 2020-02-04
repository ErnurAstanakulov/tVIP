//
//  Pagination.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/1/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

struct Pagination {
    private(set) var page: Int
    private(set) var size: Int
    var total: Total?
    
    init(page: Int, size: Int) {
        self.page = page
        self.size = size
        self.total = nil
    }
    
    func isMax() -> Bool {
        guard let total = total else {
            return false
        }
        return total.count < (page + 1) * size
    }
    
    mutating func nextPage() {
        self.page += 1
    }
    
    mutating func flush() {
        self.page = 0
    }
}
