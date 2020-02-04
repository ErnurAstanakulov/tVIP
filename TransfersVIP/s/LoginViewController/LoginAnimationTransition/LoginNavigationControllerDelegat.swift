//
//  LoginNavigationControllerDelegat.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 5/5/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import UIKit

//Custom transition should be only after initial loading, 
class LoginNavigationControllerDelegat: NSObject, UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                    animationControllerFor operation: UINavigationController.Operation,
                                         from fromVC: UIViewController,
                                             to toVC: UIViewController
        ) -> UIViewControllerAnimatedTransitioning?
    {
        
        if toVC is LoginViewController && AppState.sharedInstance.shouldAnimateToLoginWithTtansition == true {
            return LoginTransitionAnimator()
        }
        
        return nil
    }
}
