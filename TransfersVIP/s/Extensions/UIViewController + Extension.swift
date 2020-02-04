//
//  UIViewController + Extension.swift
//  Compas
//
//  Created by Nikola Andriiev on 01.11.16.
//  Copyright © 2016 Andriiev.Mykola. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func getView<R>() -> R? {
        if #available(iOS 9.0, *) {
            return self.viewIfLoaded.flatMap { $0 as? R }
        } else {
            return self.isViewLoaded ? self as? R : nil
        }
    }
        
    func debagDealloc() {
        #if DEBUG
            print("\(String(describing: self)) dealloc")
        #endif
    }
    
    // add parent child relationship. controller.view will be embedded into "toContainerView
    func addChildViewControoler(_ controller: UIViewController, toContainerView view: UIView) {
        self.addChild(controller)
        controller.view.frame = view.bounds;
        view.addSubview(controller.view)
        controller.didMove(toParent: self)
    }
    
    func getViewController(_ identifier: String, withStoryboardName name: String) -> UIViewController {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let pvc = storyboard.instantiateViewController(withIdentifier: identifier)
        pvc.modalPresentationStyle = .overCurrentContext
        
        return pvc
    }
}
