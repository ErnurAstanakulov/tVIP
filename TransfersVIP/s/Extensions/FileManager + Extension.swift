//
//  NSFileManager + Extension.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 1/19/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation

extension FileManager {
    class func pathToDirectory(_ rootDirectory: SearchPathDirectory, fileName: String? = nil) -> URL {
        var url = self.default.urls(for: .cachesDirectory, in: .allDomainsMask)[0]
        if let name = fileName {
            url.appendPathComponent(name)
        }
        
        return url
    }
    
    class func remove(atURL URL: URL) {
        do {
            try self.default.removeItem(at: URL)
        } catch _ {
            print("[ERROR] No such file at URL")
        }
    }
}

