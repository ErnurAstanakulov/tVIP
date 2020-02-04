//
//  CheckBoxCellTableViewCell.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 7/15/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import UIKit

class CheckBoxCell: UITableViewCell {
    var checkBoxBlock: ((_ sender: CheckBox) -> ())?
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var checkBox: CheckBox!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkBox.type = .gray
    }
    
    public func filleWithModel(_ model: SelectionType) {
        self.nameLabel.text = model.label
        self.checkBox.isChecked = model.isChecked ?? false
    }
        
    @IBAction func checkBoxAction(_ sender: CheckBox) {
        self.checkBoxBlock.map({ $0(sender)})
    }
}
