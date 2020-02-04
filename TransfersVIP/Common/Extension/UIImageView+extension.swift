//
//  UIImageView+extension.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/4/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

extension UIImageView {
    
    /// Load image from remote url
    ///
    /// - Parameter size: Image url
    /// - Returns: Image data
    
    func setImage(with url: URL) {
        sessionManager.request(url).response(queue: DispatchQueue.global()) { dataResponse in
            guard let data = dataResponse.data else { return }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }
    }
    
}

