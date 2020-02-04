//
//  BaseViewControllerProtocol.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 6/28/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

protocol BaseViewControllerProtocol: BaseViewInputProtocol where Self: UIViewController {
    var activityIndicator: UIActivityIndicatorView { get }
}

extension BaseViewControllerProtocol {
    
    func setUI(interactionEnabled enabled: Bool) {
        view.isUserInteractionEnabled = enabled
    }
    
    func showError(message: String, completion: VoidCompletion?) {
        let alert = UIAlertController(title: "Внимание", message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Закрыть", style: .cancel) { _ in
            completion?()
        }
        
        alert.addAction(cancel)
        presentOnTop(alert: alert, animated: true)
    }
    
    private func presentOnTop(alert: UIAlertController, animated: Bool, completion: (() -> Void)? = nil) {
        let topViewController = getPresentedViewController()
        if topViewController is UIAlertController {
            let presentingViewController = topViewController?.presentedViewController
            topViewController?.dismiss(animated: false) {
                presentingViewController?.present(alert, animated: animated, completion: completion)
            }
        } else {
            topViewController?.present(alert, animated: animated, completion: completion)
        }
    }
    
    private func getPresentedViewController() -> UIViewController? {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentingViewController = topController.presentedViewController {
                topController = presentingViewController
            }
            return topController
        }
        return nil
    }
    
    func showError(_ error: AppError, onDismiss perform: VoidCompletion?) {
        showError(message: error.description, completion: perform)
    }
    
    func showSuccess(message: String, completion: VoidCompletion?) {
        let alert = UIAlertController(title: "Сообщение", message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Закрыть", style: .cancel) { _ in
            completion?()
        }
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func showActivityIndicator() {
        let viewController = tabBarController ?? navigationController ?? self
        activityIndicator.frame = CGRect(
            x: 0,
            y: 0,
            width: viewController.view.frame.width,
            height: viewController.view.frame.height
        )
        viewController.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    func showOption(message: String, onOptionSelect perform: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "Внимание", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in perform(true) }
        let cancel = UIAlertAction(title: "Отмена", style: .cancel) { _ in perform(false) }
        alert.addAction(okAction)
        alert.addAction(cancel)
        presentOnTop(alert: alert, animated: true)
    }
}

extension BaseViewControllerProtocol {
    func getTopmostViewController() -> UIViewController {
        return getTopmostViewControllerFromChain(thatContains: self)
    }
    
    private func getTopmostViewControllerFromChain(thatContains viewController: UIViewController) -> UIViewController {
        if let navigationController = viewController as? UINavigationController {
            if let visibleViewController = navigationController.visibleViewController {
                return getTopmostViewControllerFromChain(thatContains: visibleViewController)
            }
        } else if let tabBarController = viewController as? UITabBarController {
            if let selected = tabBarController.selectedViewController {
                return getTopmostViewControllerFromChain(thatContains: selected)
            }
        } else if let presentedViewController = viewController.presentedViewController {
            return getTopmostViewControllerFromChain(thatContains: presentedViewController)
        }
        
        return viewController
    }
    
    func presentWithTransitionFromRight(_ viewController: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .push
        transition.subtype = .fromRight
        transition.timingFunction = CAMediaTimingFunction(name: .easeIn)
        view.window?.layer.add(transition, forKey: kCATransition)
        
        present(viewController, animated: false) { [unowned self] in
            self.view.window?.layer.removeAnimation(forKey: kCATransition)
        }
    }
    
    func dismissWithTransitionFromLeft() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .moveIn
        transition.subtype = .fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: .easeOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false) { [unowned self] in
            self.view.window?.layer.removeAnimation(forKey: kCATransition)
        }
    }
}
