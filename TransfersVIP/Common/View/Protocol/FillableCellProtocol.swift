//
//  FillableCellProtocol.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 8/7/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

protocol FillableCellProtocol: ReusableView where Self: UITableViewCell {
    associatedtype DataType
    
    func fill(with: DataType)
}
