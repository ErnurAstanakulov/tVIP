//
//  CheckBox.swift
//  DigitalBank
//
//  Created by iosDeveloper on 12/6/16.
//  Copyright © 2016 iosDeveloper. All rights reserved.
//

import UIKit

class CheckBox: UIButton {
    
    enum ImageType {
        case white, gray
    }
    
    var type = ImageType.gray

    // Images
    private var checkedImage: String {
        return type == .white ? ImageConstants.checkedGray : ImageConstants.checkedWhite
    }
    private var uncheckedImage: String {
        return type == .white ? ImageConstants.uncheckedWhite : ImageConstants.uncheckedGray
    }
    
    var isChecked: Bool = false {
        didSet {
            let image = isChecked ? AppImage.checkOn.uiImage : AppImage.checkOff.uiImage
            self.imageView?.image = image
            self.setImage(image, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        self.addTarget(self, action: #selector(CheckBox.checkButtonTapped(sender:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
        self.imageView?.contentMode = .scaleAspectFit
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    @objc private func checkButtonTapped(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
