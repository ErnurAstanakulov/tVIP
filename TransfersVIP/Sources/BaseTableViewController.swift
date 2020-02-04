//
//  BaseTableViewController.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 6/28/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController, BaseViewControllerProtocol {
    var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        activityIndicator.backgroundColor = UIColor.brown.withAlphaComponent(0.5)
        return activityIndicator
    }()
}
