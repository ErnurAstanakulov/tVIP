//
//  PensionContributionEmployeeCell.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 3/17/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import UIKit

class PensionContributionEmployeeCell: EmployeeCell {
    @IBOutlet var periodLabel: UILabel!
    @IBOutlet var birthDateLabel: UILabel!
    
    public override func fillWithCoWorker(_ worker: Employee) {
        super.fillWithCoWorker(worker)
        periodLabel.text = nil
        birthDateLabel.text = nil
        let birthDayDisposable = worker._birthDate.asDriver(onErrorJustReturn: "").drive(birthDateLabel.rx.text)
        disposables.append(birthDayDisposable)

        let periodDisposable = worker._period.asDriver(onErrorJustReturn: "").drive(periodLabel.rx.text)
        disposables.append(periodDisposable)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        periodLabel.text = nil
        birthDateLabel.text = nil
    }
}
