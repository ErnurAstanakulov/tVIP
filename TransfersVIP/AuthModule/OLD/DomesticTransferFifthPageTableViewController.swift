//
//  DomesticTransferFifthPageTableViewController.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 3/10/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DropDown

class DomesticTransferFifthPageTableViewController: UIViewController, DomesticTransferProtocol {
    var rootView: DomesticTransferFifthPageRootView { return self.getView()! }
    @IBOutlet var markAllButton: CheckBox!
    @IBOutlet var saveWorkerkButton: CheckBox!
    @IBOutlet var navBar: NavBar!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var actionButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    fileprivate var actionsDropDown: DropDown?
    let disposeBag = DisposeBag()
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var bottomLayoutContraint: NSLayoutConstraint!
    @IBOutlet weak var bottomToolbarHeightContraint: NSLayoutConstraint!
    
    let loadEmployeeContext = LoadEmployeesContext()
    
    public var viewModel: (OperationViewModel & ContributionViewModel)!
    
    var isSelectingEmployees: Bool = false
    var selectingEmployees: [Employee] = []

    var employees: [Employee] {
        return isSelectingEmployees ? selectingEmployees : viewModel.employees
    }
    
    var filteredEmployees: [Employee] {
        guard let text = searchBar.text, !text.isEmpty else { return employees }
        return employees.filter({ (employee) -> Bool in
            return employee.birthDate?.containsIgnoringCase(text) == true
                || employee.taxCode?.containsIgnoringCase(text) == true
                || employee.period?.containsIgnoringCase(text) == true
                || employee.fullName.containsIgnoringCase(text)
        })
    }
    
    var onEmployeesUpdate: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewInitiaConfig()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.keyboardDismissMode = .onDrag
        self.setActionsDropDown()
        self.setupViews()
        self.setupBindings()
        if let sourceData = viewModel?.initialDocument, viewModel.employees.isEmpty && !isSelectingEmployees {
            fillFrom(template: sourceData)
        }
        
        if isSelectingEmployees {
            loadUsers()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        navBar.backButtonAction = { [unowned self] _ in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func setupViews() {
        if isSelectingEmployees {
            deleteButton.isHidden = true
            actionButton.isHidden = true
        } else {
            bottomToolbarHeightContraint.constant = 0
        }
    }
    
    func setupBindings() {
        searchBar.rx.searchButtonClicked.bind {[unowned self] in
            self.searchBar.resignFirstResponder()
        }.disposed(by: disposeBag)
        searchBar.rx.cancelButtonClicked.bind {[unowned self] in
            self.searchBar.text = nil
            self.searchBar.resignFirstResponder()
            self.tableView.reloadData()
        }.disposed(by: disposeBag)
        searchBar.rx.textDidBeginEditing.bind {[unowned self] in
            self.searchBar.setShowsCancelButton(true, animated: true)
        }.disposed(by: disposeBag)
        searchBar.rx.textDidEndEditing.bind {[unowned self] in
            self.searchBar.setShowsCancelButton(false, animated: true)
        }.disposed(by: disposeBag)
        
        searchBar.rx.text
            .asObservable()
            .subscribe(onNext: {[weak self] value in
                self?.tableView.reloadData()
            }).disposed(by: disposeBag)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateEmployeeModalTableViewController" {
            let controller = segue.destination as! CreateEmployeeModalTableViewController
            controller.workers = filteredEmployees
            controller.documentType = viewModel?.documentType
            controller.saveWorkerBlock = { [weak self] worker in
                self?.appendNewWorker(worker)
            }
            controller.title = "Новый сотрудник"
        }
    }
    
    private func setActionsDropDown() {
        let actionTitles = ["ЗАПОЛНИТЬ ИЗ СПРАВОЧНИКА","ДОБАВИТЬ"]
        let dropDown = DropDown(anchorView: actionButton,
                                selectionAction: { [weak self] (index, _) in
                                    switch index {
                                    case 0: self?.fillFromDictionaryItem(); break
                                    case 1: self?.showCreateEmployeeScreen();  break
                                    default: break
                                    }
            },
                                dataSource: actionTitles,
                                topOffset: CGPoint(x: -8, y: -actionButton.bounds.height),
                                bottomOffset: CGPoint(x: -8, y: actionButton.bounds.height),
                                cellConfiguration: nil,
                                cancelAction: nil)
        
        dropDown.backgroundColor = UIColor.white
        
        UIFont(name: "Roboto-Medium", size: 16.0).map({ dropDown.textFont = $0 })
        dropDown.textColor = UIColor.colorFromHex(hex: "#514744")
        self.actionsDropDown = dropDown

    }
    
    func fillFromDictionaryItem() {
        self.markAllButton.isChecked = false
        self.tableView.reloadData()
        let employeesVC = UIStoryboard.controllerFromStorybourd("DomesticTransfer", cls: DomesticTransferFifthPageTableViewController.self)
        employeesVC.onEmployeesUpdate = onEmployeesUpdate
        employeesVC.isSelectingEmployees = true
        employeesVC.viewModel = viewModel
        navigationController?.pushViewController(employeesVC, animated: true)
    }
    
    func showCreateEmployeeScreen() {
        self.performSegue(withIdentifier: "CreateEmployeeModalTableViewController", sender: nil)
    }
    
    // MARK: Action
    
    @IBAction func showDropDownAction(_ sender: UIButton)  {
        self.actionsDropDown?.show()
    }
    
    @IBAction func deleteAction(_ sender: UIButton)  {
        for worker in self.viewModel.employees {
            if worker.isSelected {
                guard let index = self.viewModel.employees.index(of: worker) else { continue }
                self.viewModel.employees.remove(at: index)
                onEmployeesUpdate?()
            }
        }
        self.markAllButton.isChecked = false
        self.tableView.reloadData()
    }
    
    @IBAction func markAllAction(_ sender: CheckBox)  {
        self.filteredEmployees.forEach { $0.isSelected = !sender.isChecked }
        self.tableView.reloadData()
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        let filtered = selectingEmployees.filter { $0.isSelected }
        filtered.forEach { $0.isSelected = false }
        viewModel.employees.append(contentsOf: filtered)
        onEmployeesUpdate?()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: Private func
    
    public func tableViewInitiaConfig() {
        let tebleView = self.tableView
        tebleView?.rowHeight = UITableView.automaticDimension
        tebleView?.estimatedRowHeight = 100
        tableView.registerCell(withClass: PayRollEmployeeCell.self)
        tableView.registerCell(withClass: SocialContributionEmployeeCell.self)
        tableView.registerCell(withClass: PensionContributionEmployeeCell.self)
    }
    
    fileprivate func pushChangeEmployeeControllerWith(employee: Employee) {
        let controller = UIStoryboard.controllerFromStorybourd("DomesticTransfer", cls: CreateEmployeeModalTableViewController.self)
        controller.workers = self.viewModel.employees
        controller.workerToChange = employee
        controller.modalTransitionStyle = .crossDissolve
        controller.documentType = viewModel.documentType
        controller.title = "Сотрудник"
        controller.saveWorkerBlock = { [weak self] _ in
            self?.onEmployeesUpdate?()
        }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func appendNewWorker(_ worker: Employee) {
        let index = self.viewModel.employees.count
        self.viewModel.employees.insert(worker, at: index)
        onEmployeesUpdate?()
        let indexSet = IndexSet(integer: index)
        self.tableView.update {
//            self.tableView.insertRows(at: [path], with: .automatic)
            self.tableView.insertSections(indexSet, with: .automatic)
        }
        self.tableView.backgroundView = nil
    }
    
    fileprivate func deleteWorker(_ worker: Employee) {
        guard let index = viewModel.employees.index(of: worker) else { return }
        self.viewModel.employees.remove(at: index)
        onEmployeesUpdate?()
        self.tableView.reloadData()
        self.tableView.backgroundView = nil
    }
    
    fileprivate func loadUsers() {
        self.rootView.isLoadingViewVisible = true
        self.loadEmployeeContext.execute(isSuccsess: { response in
            guard let rows = response as? [String: Any] else { return }
            guard let jsons = rows["rows"] as? [[String: Any]] else { return }
            jsons.forEach({ jsons in
                Employee(JSON: jsons).map({
                    self.selectingEmployees.append($0)
                })
            })
            self.tableView.reloadData()
            self.tableView.backgroundView = nil
            self.rootView.isLoadingViewVisible = false
        }) { (error) in
            self.tableView.backgroundView = nil
            self.rootView.isLoadingViewVisible = false
        }
    }
    
    // MARK: DomesticTransferProtocol
    
    var sourсeData: DomesticTransferSourсeData?
    func fillFrom(sourсeData: DomesticTransferSourсeData) {}
    
    func fillFrom(template: DomesticTransfer) {
        self.viewModel.employees.removeAll()
        onEmployeesUpdate?()
        //will nullify balanceValue
        guard let employees = template.employees else { return }
        for employee in employees {
            let worker = Employee()
            switch viewModel.documentType {
            case Constants.paymentsTypes[1]:
                worker.payroll = employee.amount
            case Constants.paymentsTypes[2]:
                worker.pension = employee.amount
            case Constants.paymentsTypes[3]:
                worker.social = employee.amount
            case Constants.paymentsTypes[4]:
                worker.medical = employee.amount
            default: break
            }
            worker.fillFromEmployee(employee)
            if let items = worker.period?.components(separatedBy: "."), items.count >= 3 {
                worker.period = items[1] + "." + items[2]
            }
            self.viewModel.employees.append(worker)
            onEmployeesUpdate?()
        }
        self.tableView.reloadData()
    }
    
    func fillDocument(_ document: DomesticTransferToSend) {}
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let infoNSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardFrame = infoNSValue.cgRectValue
        let tabBarHeight: CGFloat = tabBarController?.tabBar.frame.height ?? 49.0
        let emptySpace: CGFloat = 2
        let coveredSpace = keyboardFrame.height - (tabBarHeight + emptySpace)
        if bottomLayoutContraint.constant == 0 {
            bottomLayoutContraint.constant += coveredSpace
        }
        let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        UIView.animate(withDuration: keyboardDuration ?? 0.5, animations: view.layoutIfNeeded)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        bottomLayoutContraint.constant = 0
        let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        UIView.animate(withDuration: keyboardDuration ?? 0.5, animations: view.layoutIfNeeded)
    }
}

extension DomesticTransferFifthPageTableViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredEmployees.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 6
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let documentType = viewModel.documentType
        let index = indexPath.section
        let cell: EmployeeCell
        if documentType == Constants.PaymentTypes.payroll {
            cell = tableView.dequeueCell(cls: PayRollEmployeeCell.self, indexPath: indexPath)
        } else if documentType == Constants.PaymentTypes.pensionContribution {
            cell = tableView.dequeueCell(cls: PensionContributionEmployeeCell.self, indexPath: indexPath)
        } else {
            cell = tableView.dequeueCell(cls: SocialContributionEmployeeCell.self, indexPath: indexPath)
        }
        
        cell.documentType = documentType
        let worker = filteredEmployees[index]
        cell.index = String(index + 1)
        cell.fillWithCoWorker(worker)
        
        if isSelectingEmployees {
            cell.changeEmployeeButton.isHidden = true
            cell.separatorView.isHidden = true
        }
        
        cell.changeEmployeeBlock = { [weak self] _ in
            self?.pushChangeEmployeeControllerWith(employee: worker)
        }
        
        cell.isSelecteBlock = { [weak self] sender in
            worker.isSelected = !sender.isChecked
            self?.markAllButton.isChecked = false
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        cell.deleteEmployeeBlock = { [weak self] sender in
            self?.deleteWorker(worker)
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
