//
//  AccountTransfersContainerViewController.swift
//  DigitalBank
//
//  Created by Misha Korchak on 11.04.17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Alamofire
import ObjectMapper

enum AccountTransfersSelectedProductType {
    case from
    case to
}

extension String {
    
    func returnDouble() -> Double {
        return Double(self) ?? 0
    }
    
    func containsIgnoringCase(_ other: String) -> Bool {
        if(self.lowercased().contains(other.lowercased())) {
            return true
        }
        else {
            return false
        }
    }
}
