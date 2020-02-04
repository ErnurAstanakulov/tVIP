//
//  LoadEmployeesContext.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 3/10/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation

class LoadEmployeesContext: Context {
    public override func urlString() -> String {
        return baseURL + "api/employee?sort=id"
    }
}
