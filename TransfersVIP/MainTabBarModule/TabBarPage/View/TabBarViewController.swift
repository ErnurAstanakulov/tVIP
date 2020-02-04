//
//  TabBarViewController.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/19/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

//TODO: Rename to MainTabBarViewController
class TabBarViewController: BaseViewController {
    var interactor: TabBarPageInteractorInput!
    var router: TabBarPageRouterInput!
    
    private var pagesTabBarController = UITabBarController()
    
    private var mainPageController: UINavigationController!
    private var transferController: UINavigationController!
    private var demandController: UINavigationController!
    private var menuController: UINavigationController!
    
    override func loadView() {
        super.loadView()
        
        initilizeChildViewControllers()
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    private func initilizeChildViewControllers() {
        mainPageController = router.createMainPageController()
        transferController = router.createTransferController()
        menuController = router.createMenuController()
        demandController = router.createDemandController()
    }
    
    private func getPrivilegeteViewControllers() -> [UIViewController] {
        var viewControllers: [UIViewController] = [mainPageController, transferController]
        
        viewControllers.append(menuController)
        return viewControllers
    }
}

extension TabBarViewController: TabBarViewInput {
    
}

extension TabBarViewController: ViewInitalizationProtocol {
    func addSubviews() {
        addChild(viewController: pagesTabBarController)
        
        pagesTabBarController.viewControllers = getPrivilegeteViewControllers()
    }
    
    func setupConstraints() {
        pagesTabBarController.view.addConstaintsToFill()
    }
    
    func stylizeViews() {
        setStatusBarBackground()
        
        pagesTabBarController.tabBar.tintColor = AppColor.green.uiColor
        pagesTabBarController.tabBar.unselectedItemTintColor = AppColor.gray.uiColor
        pagesTabBarController.tabBar.barTintColor = .white
        
        stylize(mainPageController, AppImage.briefcase, "Продукты")
        stylize(transferController, AppImage.exchangePage, "Переводы")
        stylize(demandController, AppImage.editPage, "Заявления")
        stylize(menuController, AppImage.menuPage, "Меню")
    }
    
    private func stylize(_ viewController: UINavigationController, _ image: AppImage, _ title: String) {
        viewController.navigationBar.isHidden = true
        
        viewController.tabBarItem.image = image.uiImage
        viewController.tabBarItem.title = title
    }
    
    private func setStatusBarBackground() {
        let statusBarBackgroundLayer = CALayer()
        statusBarBackgroundLayer.frame = UIApplication.shared.statusBarFrame
        statusBarBackgroundLayer.backgroundColor = AppColor.green.uiColor.cgColor
        view.layer.addSublayer(statusBarBackgroundLayer)
    }
}
