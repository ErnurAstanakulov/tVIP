//
//  TransferNewIteractor.swift
//  TransfersVIP
//
//  Created by psuser on 30/08/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

class TransferNewIteractor {
    
    private(set) var presenter: TransferNewPresenterInput
    init(presenter: TransferNewPresenterInput) {
        self.presenter = presenter
    }
    
    let newTransfers = [
        TransferNew(title: "Переводы в тенге", icon: #imageLiteral(resourceName: "tenge")),
        TransferNew(title: "Медицинское отчисление", icon: #imageLiteral(resourceName: "medical")),
        TransferNew(title: "Пенсионное отчисление", icon: #imageLiteral(resourceName: "pension")),
        TransferNew(title: "Социальное отчисление", icon: #imageLiteral(resourceName: "social")),
        TransferNew(title: "Зарплатное отчисление", icon: #imageLiteral(resourceName: "payroll")),
        TransferNew(title: "Переводы в валюте", icon: #imageLiteral(resourceName: "international")),
        TransferNew(title: "Перевод между счетами", icon: #imageLiteral(resourceName: "internal")),
        TransferNew(title: "Конвертация", icon: #imageLiteral(resourceName: "conversion"))
    ]
}

extension TransferNewIteractor: TransferNewIteractorInput {
    func setTitles() {
        presenter.setTitles(titles: newTransfers)
    }
}
