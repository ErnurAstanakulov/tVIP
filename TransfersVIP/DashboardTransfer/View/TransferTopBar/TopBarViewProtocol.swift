//
//  TopBarViewProtocol.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/31/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

protocol TopBarViewProtocol where Self: UIView {
    
    var leftSideImageView: UIImageView { get }
    
}

extension TopBarViewProtocol {
    
    func setupTopBarView() {
        addHeaderSubviews()
        setupHeaderConstraints()
        stylizeHeaderViews()
    }
    
    func addHeaderSubviews() {
        addSubview(leftSideImageView)
    }
    
    func setupHeaderConstraints() {
        leftSideImageView.addConstaintsToVertical()
        leftSideImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        leftSideImageView.widthAnchor.constraint(equalTo: leftSideImageView.heightAnchor).isActive = true
    }
    
    func stylizeHeaderViews() {
        backgroundColor = AppColor.green.uiColor
        
        leftSideImageView.image = AppImage.logo.uiImage?.withRenderingMode(.alwaysTemplate)
        leftSideImageView.tintColor = AppColor.lightGray.uiColor
        leftSideImageView.contentMode = .scaleAspectFit
    }
}
enum AppColor {
    case white
    case black
    case green
    case lightGray
    case light
    case title
    case gray
    case dark
    case lineColor
}

extension AppColor: ColorProtocol {
    var uiColor: UIColor {
        switch self {
        case .white:
            return UIColor(rgb: 255, 255, 255)
        case .black:
            return UIColor(rgb: 0, 0, 0)
        case .green:
            return UIColor(rgb: 42, 151, 63)
        case .lightGray:
            return UIColor(rgb: 229,229,229)
        case .light:
            return UIColor(rgb: 240, 240, 240)
        case .gray:
            return UIColor(rgb: 119, 119, 119)
        case .dark:
            return UIColor(rgb: 22, 22, 22)
        case .lineColor:
            return UIColor(rgb: 230, 230, 230)
        case .title:
            return UIColor(rgb: 196, 196, 196)
        }
    }
}


enum AppFont {
    case light
    case regular
    case semibold
}

extension AppFont: FontProtocol {
    var uiFont: UIFont {
        switch self {
        case .light:
            return UIFont(name: "OpenSans-Light", size: 16) ?? .systemFont(ofSize: 16, weight: .light)
        case .regular:
            return UIFont(name: "OpenSans-Regular", size: 16) ?? .systemFont(ofSize: 16, weight: .regular)
        case .semibold:
            return UIFont(name: "OpenSans-Semibold", size: 16) ?? .systemFont(ofSize: 16, weight: .semibold)
        }
    }
}
protocol FontProtocol {
    var uiFont: UIFont { get }
}

extension FontProtocol {
    func with(size: CGFloat) -> UIFont {
        return uiFont.withSize(size)
    }
}

protocol ColorProtocol {
    var uiColor: UIColor { get }
}

extension UIColor {
    
    /// Initialize from integral RGB values (+ alpha channel in range 0-100)
    convenience init(rgb: UInt8..., alpha: UInt = 100) {
        self.init(
            red:   CGFloat(rgb[0]) / 255.0,
            green: CGFloat(rgb[1]) / 255.0,
            blue:  CGFloat(rgb[2]) / 255.0,
            alpha: CGFloat(min(alpha, UInt(100))) / 100.0
        )
    }
}

enum AppImage: String, ImageProtocol {
    case hideKeyboardIcon
    case backgroundNurlytau
    case logo
    case logoFull
    case menuPage
    case briefcase
    case editPage
    case exchangePage
    case home
    case arrowDown
    case arrowBack
    case dollar
    case newspaper
    case position
    case opportunity
    case information
    case productBank
    case money
    case contract
    case ready
    case arrowDownLight
    case open
    case close
    case accountBackground
    case depositBackground
    case creditBackground
    case bankBackground
    case contractBackground
    case taskBackground
    case cardBackground
    case logoNew
    
    case unpaid
    case error
    
    var bundle: Bundle? {
        return nil
    }
}
//
//  ImageProtocol.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/4/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

/// Protocol to access image from bundle
/// For **enum** extension with raw type **String**
public protocol ImageProtocol {
    
    /// Image asset value
    var rawValue: String { get }
    
    /// Image related bundle
    var bundle: Bundle? { get }
}

public extension ImageProtocol {
    
    /// Get value as **UIImage**
    var uiImage: UIImage? {
        if let bundle = bundle {
            return UIImage(named: rawValue, in: bundle, compatibleWith: nil)
        }
        return UIImage(named: rawValue)
    }
    
    /// Get value as **CGImage**
    var cgImage: CGImage? { return self.uiImage?.cgImage }
}
