//
//  AuthMainViewController.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/12/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

class AuthMainViewController: BaseViewController {
    var interactor: AuthMainPageInteractorInput?
    var router: AuthMainPageRouterInput?
    
    private var backgroundImageView = UIImageView()
    private var effectView = UIView()
    private var pagesTabBarController = UITabBarController()
    
    override func loadView() {
        super.loadView()
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewLoaded()
    }
}

extension AuthMainViewController: AuthMainViewInput {
    func setupPages() {
        guard let router = router else {
            return
        }
        
        let loginViewController = router.setupLoginPageModule()
        let menuViewController = router.setupMenuPageModule()
        
        stylizePage(loginViewController, title: "Главная", icon: AppImage.home.uiImage)
        stylizePage(menuViewController, title: "Меню", icon: AppImage.menuPage.uiImage)
        
        pagesTabBarController.viewControllers = [loginViewController, menuViewController.navigationController!]
    }
    
    private func stylizePage(_ viewController: UIViewController, title: String?, icon: UIImage?) {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = icon
        
        viewController.navigationController?.navigationBar.isHidden = true
    }
}

extension AuthMainViewController: ViewInitalizationProtocol {
    func addSubviews() {
        view.addSubview(backgroundImageView)
        view.addSubview(effectView)
        
        addChild(viewController: pagesTabBarController)
    }
    
    func setupConstraints() {
        backgroundImageView.addConstaintsToFill()
        effectView.addConstaintsToFill()
        pagesTabBarController.view.addConstaintsToFill()
    }
    
    func stylizeViews() {
        backgroundImageView.image = AppImage.backgroundNurlytau.uiImage
        
        effectView.backgroundColor = UIColor.white.withAlphaComponent(0.35)
        
        pagesTabBarController.tabBar.shadowImage = UIImage()
        pagesTabBarController.tabBar.itemPositioning = .centered
        pagesTabBarController.tabBar.itemSpacing = 195
        pagesTabBarController.tabBar.backgroundColor = .white
        pagesTabBarController.tabBar.barTintColor = .white
        pagesTabBarController.tabBar.backgroundImage = UIImage()
        pagesTabBarController.tabBar.tintColor = AppColor.green.uiColor
    }
}
