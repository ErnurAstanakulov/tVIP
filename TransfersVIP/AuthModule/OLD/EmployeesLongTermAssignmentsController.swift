//
//  EmployeesLongTermAssignmentsController.swift
//  DigitalBank
//
//  Created by InfinIT on 6/18/18.
//  Copyright © 2018 iosDeveloper. All rights reserved.
//

import UIKit

class EmployeesLongTermAssignmentsController: UIViewController {
    
    private let tableView = UITableView()
 
    public var employees = [Employee]()
    public var documentType: String? = nil
    public var viewModel: (OperationViewModel & ContributionViewModel)?
    
    var isRegularTransfer = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        stylize()
        setupConstraints()
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        
        guard !isRegularTransfer else { return }
     }
    
    private func stylize() {
        if isRegularTransfer {
            view.backgroundColor = .clear
        }
        
        tableView.backgroundColor = .clear
        tableView.contentInset.bottom = 8
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupConstraints() {
       
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}

extension EmployeesLongTermAssignmentsController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return employees.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        return UITableViewCell()
    }
}

extension EmployeesLongTermAssignmentsController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}
