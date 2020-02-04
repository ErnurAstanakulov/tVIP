//
//  TransferContainerViewController.swift
//  TransfersVIP
//
//  Created by psuser on 29/08/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import UIKit

class TransferNavigationController: UINavigationController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
//        UINavigationBar.appearance().alpha = 0
//        UINavigationBar.appearance().isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .`default`
        UINavigationBar.appearance().alpha = 1
        UINavigationBar.appearance().isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setViewControllers([DashboardTransferContainerViewController()], animated: true)
    }
}


class WorkDocumentsViewController: UIViewController, PagesDelegate {
    
    var page = Pages.work
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
    }
}

class TemplateViewController: UIViewController, PagesDelegate {
    
    var page = Pages.template
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
}

class RegularViewController: UIViewController, PagesDelegate {
    
    var page = Pages.regular
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
    }
}

protocol PagesDelegate where Self: UIViewController{
    var page: Pages { get }
}

