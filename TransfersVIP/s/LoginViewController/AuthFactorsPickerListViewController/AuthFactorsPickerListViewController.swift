//
//  AuthFactorsPickerListViewController.swift
//  DigitalBank
//
//  Created by Zhalgas Baibatyr on 07/06/2018.
//  Copyright © 2018 iosDeveloper. All rights reserved.
//

import UIKit

class AuthFactorsPickerListViewController: PickerListViewController {
	
    let skipButton = UIButton()
    var performOnSkipButtonPress: (() -> Void)?
    
    override func loadView() {
        super.loadView()
        skipButton.addTarget(self, action: #selector(onSkipButtonPress), for: .touchUpInside)
    }
    
    override func setupViews() {
        view.addSubview(skipButton)
        
        super.setupViews()
    }
    
    override func stylizeViews() {
        super.stylizeViews()
        skipButton.backgroundColor = AppData.Color.technolygedBlackGray.uiColor
        skipButton.layer.cornerRadius = 4
        skipButton.setTitle("Пропустить", for: .normal)
        skipButton.titleLabel?.textColor = .white
        skipButton.titleLabel?.font = AppData.Font.arialRegular
    }
    
    override func setupConstraints() {
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 5).isActive = true
        cancelButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -5).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.topAnchor.constraint(equalTo: cancelButton.topAnchor).isActive = true
        skipButton.leftAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 5).isActive = true
        skipButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        skipButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    override func updateViewConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        contentView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, constant: -40).isActive = true
        contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        let tableViewMaxHeight = UIScreen.main.bounds.height - 64 - 48 - 45
        tableViewHeightAnchorConstraint?.isActive = false
        if tableView.contentSize.height > tableViewMaxHeight {
            tableViewHeightAnchorConstraint = tableView.heightAnchor.constraint(equalToConstant: tableViewMaxHeight)
            tableView.alwaysBounceVertical = true
        } else {
            tableViewHeightAnchorConstraint = tableView.heightAnchor.constraint(equalToConstant: tableView.contentSize.height)
            tableView.alwaysBounceVertical = false
        }
        tableViewHeightAnchorConstraint?.isActive = true
        tableView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        tableView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        super.updateViewConstraints()
    }
    
    @objc private func onSkipButtonPress() {
        performOnSkipButtonPress?()
    }
}
