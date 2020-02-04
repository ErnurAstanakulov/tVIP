//
//  LoginSideMenuTableViewController.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 5/3/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import UIKit

class LoginSideMenuTableViewController: UITableViewController {
    @IBOutlet var ratesLabel: UILabel!
    @IBOutlet var newsLabel: UILabel!
    @IBOutlet var officesLabel: UILabel!
    @IBOutlet var facilitiesLabel: UILabel!
    @IBOutlet var bankInfoLabel: UILabel!
    
    lazy var bankInfoURL: URL = {
        URL(string: "http://www.asiacreditbank.kz/p/about_bank.html")!
    }()
    
    lazy var facilitiesURL: URL = {
        URL(string: "https://myacb.kz/")!
    }()
    
    //MARK: View lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Navigation
    
    private func pushControllerWithStorybourdName(_ name: String) {
        let controller: UIViewController = UIStoryboard.initialControllerFromStorybourd(name)
        guard let navController = controller as? UINavigationController else {            
            navigationController?.pushViewController(controller, animated: true)
            return
        }
        navigationController?.pushViewController(navController.viewControllers[0], animated: true)
    }
    
    private func pushTerminalsViewController() {
//        let terminalsMapViewController: TerminalsMapViewController = {
//            return UIStoryboard.viewController("Terminals", identifier: "TerminalsMapViewController") as! TerminalsMapViewController
//        }()
//        let terminalsViewController: TerminalsViewController = {
//            return UIStoryboard.viewController("Terminals", identifier: "TerminalsViewController") as! TerminalsViewController
//        }()
//        let controller = TerminalsPageTabBarController(viewControllers: [terminalsMapViewController, terminalsViewController], selectedIndex: 0, pushedFromLoginPage: false)
//
//        navigationController?.pushViewController(controller, animated: true)
    }
    
    func openURL(_ url: URL) {
        GlobalFunctions.openWebView(url: url)
    }
    
    //MARK: UITableViewDelegate, UITableViewDataSource
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath != IndexPath(item: 0, section: 0) else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = indexPath.row
        switch row {
        case 1: self.pushControllerWithStorybourdName("ExchangeRates")
        case 2: self.pushControllerWithStorybourdName("News")
        case 3: self.pushTerminalsViewController()
        case 4: self.openURL(self.bankInfoURL)
        case 5: self.openURL(self.facilitiesURL)
        default: break
        }
    }
    
    public override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    public override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
}
