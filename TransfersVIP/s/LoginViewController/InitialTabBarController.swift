//
//  InitialTabBarController.swift
//  DigitalBank
//
//  Created by Daulet Tungatarov on 5/8/18.
//  Copyright © 2018 iosDeveloper. All rights reserved.
//

import UIKit

class InitialTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginViewController = UIStoryboard.controllerFromMainStorybourd(cls: LoginViewController.self)
        loginViewController.tabBarItem.title = "Главная"
        
//        let menuViewController = UINavigationController(rootViewController: MenuViewController())
//        menuViewController.tabBarItem.title = "Меню"
//        menuViewController.tabBarItem.image = AppData.Image.ic_menu.uiImage
//
//        viewControllers = [loginViewController, menuViewController]
//
//        tabBar.barTintColor = .white
//        tabBar.tintColor = AppData.Color.technolygedBlackGray.uiColor
    }
}


