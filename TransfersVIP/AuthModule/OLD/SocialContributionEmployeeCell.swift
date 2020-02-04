//
//  "PensionContribution" SocialContributionEmployeeCell.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 3/17/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import UIKit

class SocialContributionEmployeeCell: EmployeeCell {
    @IBOutlet var bitrhDateLabel: UILabel!
    
    public override func fillWithCoWorker(_ worker: Employee) {
        super.fillWithCoWorker(worker)
        bitrhDateLabel.text = nil
        let birthDayDisposable = worker._birthDate.asDriver(onErrorJustReturn: "").drive(bitrhDateLabel.rx.text)
        disposables.append(birthDayDisposable)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bitrhDateLabel.text = nil
    }
}
