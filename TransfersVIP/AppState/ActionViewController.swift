//
//  ActionViewController.swift
//  DigitalBank
//
//  Created by Misha Korchak on 02.06.17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import UIKit

class ActionViewController: UIViewController, UIGestureRecognizerDelegate {
    
    weak var actionView: UIView?
    var gest: UITapGestureRecognizer? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ActionViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ActionViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Gestures
    
    func prepareGestures(actionView: UIView) {
        gest = OneTapGesture(target: self,
                             action: #selector(ActionViewController.backViewTapped(sender:)))
        gest?.delegate = self
        self.actionView = actionView
    }
    
    @objc func backViewTapped(sender: UITapGestureRecognizer) {
        let touch = sender.location(in: actionView)
        guard touch.x < 0 || touch.y < 0 || touch.y > (actionView?.frame.size.height)! || touch.x > (actionView?.frame.size.width)! else {
            return
        }
        
        willDismiss()
        self.dismiss(animated: true, completion: {
        })
    }
    
    func willDismiss() { }
    
    
    //MARK: - Keyboard
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                let height = self.view.frame.size.height - (self.actionView?.frame.origin.y)! - (self.actionView?.frame.size.height)!
                self.view.frame.origin.y -= keyboardSize.height - height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
         self.view.frame.origin.y = 0
    }
}

class OneTapGesture: UITapGestureRecognizer {
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        
        if let target = target as? UIViewController {
            target.view.isUserInteractionEnabled = true
            target.view.addGestureRecognizer(self)
        }
        
        self.numberOfTapsRequired = 1
        self.numberOfTouchesRequired = 1
        self.cancelsTouchesInView = false
        self.isEnabled = true
    }
}

