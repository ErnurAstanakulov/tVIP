//
//  UIAllertViewController + Extension.swift
//  VidMeTest
//
//  Created by Nikola Andriiev on 1/17/17.
//  Copyright © 2017 Andriiev.Mykola. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    static func presentSimpleError(title: String?, message: String?) -> UIAlertController {
        let allertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        allertController.addAction(cancelAction)
        
        return allertController
    }
}


    
