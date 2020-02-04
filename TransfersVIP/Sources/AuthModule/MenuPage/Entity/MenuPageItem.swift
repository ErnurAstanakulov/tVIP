//
//  MenuPageItem.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/12/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

//TODO: Rename to MenuItem after remove old
struct MenuPageItem {
    var type: MenuPageItemType
    var icon: AppImage
    var title: String
}

enum MenuPageItemType {
    case currencies
    case newsletters
    case branches
    case opportunities
    case aboutBank
}
