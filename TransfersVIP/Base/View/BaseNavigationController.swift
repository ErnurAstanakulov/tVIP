//
//  BaseNavigationController.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 6/28/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController, BaseViewControllerProtocol {
    
    var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        activityIndicator.backgroundColor = UIColor.brown.withAlphaComponent(0.5)
        return activityIndicator
    }()
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewControllers.last?.navigationItem.backBarButtonItem = EmptyTitleBarButtonItem()
        super.pushViewController(viewController, animated: animated)
    }
    
    func hideBackButton() {
        guard let viewController = viewControllers.last else { return }
        viewController.navigationItem.setHidesBackButton(true, animated: true)
    }
}
