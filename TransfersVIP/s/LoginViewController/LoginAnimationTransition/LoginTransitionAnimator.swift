//
//  File.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 5/5/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import UIKit

class LoginTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    public var animationDuretion: TimeInterval = 2
    
    internal func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuretion
    }
    
    internal func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let sourceVC = transitionContext.viewController(forKey: .from) as? InitialLoadingViewController,
            let destinationVC = transitionContext.viewController(forKey: .to) as? LoginViewController else { return }
        
        let containerView = transitionContext.containerView
        let destinationView = destinationVC.rootView
        
        containerView.backgroundColor = UIColor.white
        containerView.addSubview(destinationVC.view)
        
        destinationVC.view.alpha = 0
        
        let duration = transitionDuration(using: transitionContext)
        
        let logo = sourceVC.logoImageView
        
        logo.removeFromSuperview()
        containerView.addSubview(logo)
        logo.didMoveToSuperview()
        
        destinationView.layoutSubviews()
        
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: [.calculationModeLinear],
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 2/3, animations: {
//                    let logoFrame = destinationView.logoImageView.frame
//                    let destinationLogoFrame = destinationView.convert(logoFrame, to: containerView)
//                    logo.frame = destinationLogoFrame
                })
                
                UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3, animations: {
                    logo.alpha = 0
                    destinationVC.view.alpha = 1
                })
        }, completion: { _ in
            logo.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
