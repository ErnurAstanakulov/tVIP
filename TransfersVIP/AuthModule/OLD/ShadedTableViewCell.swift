//
//  ShadedTableViewCell.swift
//  DigitalBank
//
//  Created by Vlad on 18.07.17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import UIKit

enum ShadedTableViewCellRoundedCorners: Int {
    case none = 0
    case top
    case bottom
    case all
    
    func roundingCorners() -> UIRectCorner? {
        switch self {
        case .none:
            return nil
        case .top:
            return [.topLeft, .topRight]
        case .bottom:
            return [.bottomLeft, .bottomRight]
        case .all:
            return .allCorners
        }
    }
}

class ShadedTableViewCell: UITableViewCell {
    
    var roundedCorners: ShadedTableViewCellRoundedCorners = .none
    @IBInspectable  var roundedCornersRadius: CGFloat = 2.0
    
    @IBInspectable var roundedCornersStyle: Int = 0 {
        didSet {
            roundedCorners = ShadedTableViewCellRoundedCorners(rawValue: roundedCornersStyle) ?? .none
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .white
        contentView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.insetBy(dx: 8.0, dy: 0.0)
//        contentView.frame.size.height -= 1.0 / UIScreen.main.scale
        
        for view in contentView.subviews {
            guard let label = view as? UILabel else { continue }
            label.preferredMaxLayoutWidth = label.bounds.width
        }
        
        if let roundingCorners = roundedCorners.roundingCorners() {
            let maskLayer = CAShapeLayer()
            maskLayer.path = UIBezierPath(roundedRect: contentView.bounds,
                                          byRoundingCorners: roundingCorners,
                                          cornerRadii: CGSize(width: roundedCornersRadius, height: roundedCornersRadius)).cgPath
            contentView.layer.mask = maskLayer
        } else {
            contentView.layer.mask = nil
        }
    }
}
