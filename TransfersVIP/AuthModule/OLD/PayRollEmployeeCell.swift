//
//  PayRollEmployeeCell.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 3/17/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import UIKit

class PayRollEmployeeCell: EmployeeCell {    
    @IBOutlet var accountLabel: UILabel!
    
    public override func fillWithCoWorker(_ worker: Employee) {
        super.fillWithCoWorker(worker)
        accountLabel.text = nil
        let accountDisposable = worker._account.asDriver(onErrorJustReturn: "").drive(accountLabel.rx.text)
        disposables.append(accountDisposable)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        accountLabel.text = nil
    }
}
