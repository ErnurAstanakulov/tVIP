//
//  UIViewController+extension.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/2/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

extension UIViewController {
    var topbarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
    
    var tabBarHeight: CGFloat {
        return tabBarController?.tabBar.frame.height ?? 0.0
    }
    
    var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    
    func addChild(viewController: UIViewController) {
        self.addChild(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
}
