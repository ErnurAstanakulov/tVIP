//
//  UIImage+extension.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/4/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

extension UIImage {
    /// Get resized image by keeping its aspect ratio
    ///
    /// - Parameter size: maximum size
    /// - Returns: resized image
    func fitted(in size: CGSize) -> UIImage? {
        let newSize: CGSize
        let aspectRatio = self.size.width / self.size.height
        
        if aspectRatio < 1 {
            let width = size.height * aspectRatio
            if width > size.width {
                let newHeight = size.width / aspectRatio
                newSize = CGSize(width: size.width, height: newHeight)
            } else {
                newSize = CGSize(width: width, height: size.height)
            }
        } else {
            let height = size.width / aspectRatio
            if height > size.height {
                let newWidth = size.height * aspectRatio
                newSize = CGSize(width: newWidth, height: size.height)
            } else {
                newSize = CGSize(width: size.width, height: height)
            }
        }
        
        return resized(to: newSize)
    }
    
    /// Get resized image
    ///
    /// - Parameter size: new image size
    /// - Returns: resized UIImage object
    func resized(to size: CGSize) -> UIImage? {
        let rect = CGRect(origin: .zero, size: size)
        let renderingMode = self.renderingMode
        // Perform image resizing
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        draw(in: rect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result?.withRenderingMode(renderingMode)
    }
    
    /// Get image centered inside the transparent area with provided size;
    /// If provided width (height) is less than the original width (height) then return will be nil
    func centered(in size: CGSize) -> UIImage? {
        if size.width < self.size.width || size.height < self.size.height { return nil }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        _ = UIGraphicsGetCurrentContext()
        let origin = CGPoint(x: (size.width - self.size.width) / 2, y: (size.height - self.size.height) / 2)
        draw(at: origin)
        let centeredImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return centeredImage
    }
}

