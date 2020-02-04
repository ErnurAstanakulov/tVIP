//
//  DocumentHistoryCell.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 3/20/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import UIKit

class DocumentHistoryCell: ShadedTableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var fromStateLabel: UILabel!
    @IBOutlet var toStateLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var arrowImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.arrowImageView.image = UIImage(named: "arrow_left")?.withRenderingMode(.alwaysTemplate)
        self.arrowImageView.tintColor = UIColor.colorFromHex(hex: "#655C59")
        self.arrowImageView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }
    
    public func fillFromEvent(_ event: DocumentHistory) {
        self.nameLabel.text = event.fullName
        self.descriptionLabel.text = event.descr
        self.fromStateLabel.text = event.fromStateLabel
        self.toStateLabel.text = event.toStateLabel
        self.dateLabel.text = event.when
    }
}
