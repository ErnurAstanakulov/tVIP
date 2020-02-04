//
//  UIViewController + Allert.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 5/22/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentErrorController(title: String?, message: String?) {
        let controller = UIAlertController.presentSimpleError(title: title, message: message)
        self.present(controller, animated: true)
    }
    
    typealias RepeatAction = (_ sender: UIAlertAction) -> ()
    func presentRepeatErrorController(title: String = "Ошибка", error: Error, titleForAction: String = "Повторить", action: @escaping RepeatAction) {
        let message = error.localizedDescription
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: titleForAction, style: .default) { (sender) in
            action(sender)
        }
        
//        if let RXError = error as? RxRequstError {
//            switch RXError {
//            case let .httpRequestFailed(_, statusCode):
//                switch statusCode {
//                default: controller.addAction(defaultAction)
//                }
//            default: controller.addAction(defaultAction)
//            }
//        }
//
        self.present(controller, animated: true, completion: nil)
    }
    
}

class ToastMessage {
    class func show(message: String, closeAfter milliseconds: Int, onCompletion perform: (() -> Void)? = nil) {
        let alert = UIAlertController()
        alert.message = message
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(milliseconds)) {  alert.dismiss(animated: true, completion: perform) }
    }
}
