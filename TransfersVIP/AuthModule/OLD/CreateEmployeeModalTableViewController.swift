//
//  CreateEmployeeTableViewController.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 3/13/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import UIKit

class CreateEmployeeModalTableViewController: DomesticTransferAbstractTableViewController {
    //DESC: workers mandatory property for workers validations
    public var workers: [Employee]!
    public var workerToChange: Employee?
    public var innBuffers = [String]()
    public var accountBuffer = [String]()
    
    public var saveWorkerBlock: ((_ worker: Employee) -> ())?
    
    @IBOutlet var surnameTextField: UITextField!
    @IBOutlet var surnameAllertLabel: UILabel!
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var nameAllerLabel: UILabel!
    
    @IBOutlet var middleNameTextField: UITextField!
    @IBOutlet var middleNameAllerLabel: UILabel!
    
    @IBOutlet var taxCodeTextField: UITextField!
    @IBOutlet var taxCodeAllertLabel: UILabel!
    
    @IBOutlet var birthDateTextField: UITextField!
    fileprivate var birthDatePicker: UIDatePicker = UIDatePicker()
    @IBOutlet var birthDateAllertLabel: UILabel!
    
    @IBOutlet var accountTextField: UITextField!
    @IBOutlet var accountAllertLabel: UILabel!
    
    @IBOutlet var sumTextField: UITextField!
    @IBOutlet var sumAllertLabel: UILabel!
    
    @IBOutlet var periodTextField: UITextField!
    fileprivate var periodPicker: UIDatePicker = UIDatePicker()
    @IBOutlet var periodDateAllertLabel: UILabel!
    
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    
    var documentType: String?
    
    public var employeeConstraints: DomesticTransferEmployeeConstraints? {
        get {
            guard let documentType = documentType else { return nil }
            switch documentType {
            case Constants.paymentsTypes[0]:
                return AppState.sharedInstance.config?.documents?.domesticTransfer?.paymentOrder?.employeeConstraints
            case Constants.paymentsTypes[1]:
                return AppState.sharedInstance.config?.documents?.domesticTransfer?.payroll?.employeeConstraints
            case Constants.paymentsTypes[2]:
                return AppState.sharedInstance.config?.documents?.domesticTransfer?.pensionContribution?.employeeConstraints
            case Constants.paymentsTypes[3]:
                return AppState.sharedInstance.config?.documents?.domesticTransfer?.socialContribution?.employeeConstraints
            case Constants.paymentsTypes[4]:
                return AppState.sharedInstance.config?.documents?.domesticTransfer?.pensionContribution?.employeeConstraints
            default:
                return nil
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset.top += 80.0
        self.tableView.setContentOffset(CGPoint(x: 0, y: -80), animated: false)
        self.setupNavigationBar()
        self.initialBufferSetup()
        self.activeTapGestureOnView()
        self.fillUIFromWorker(self.workerToChange)
        self.toolbarActivate()
    }
    
    func setupNavigationBar() {
        let navBar = NavBar()
        view.addSubview(navBar)
        navBar.backButtonAction = { [unowned self] _ in
            self.navigationController?.popViewController(animated: true)
        }
        navBar.title = "Реестр"
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        navBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        navBar.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor).isActive = true
        navBar.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    // MARK: Actions
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        self.validateAll()
        if self.isAllValid() {
            let employee: Employee
            if let currentWorker = self.workerToChange {
                self.fillWorkerFromUI(currentWorker)
                employee = currentWorker
            } else {
                employee = Employee()
                self.fillWorkerFromUI(employee)
            }
            saveWorkerBlock?(employee)
            closeController()
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        closeController()
    }
    
    private func closeController(animated: Bool = true) {
        self.view.endEditing(true)
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: animated)
        } else {
            dismiss(animated: animated, completion: nil)
        }
    }
    
    func toolbarActivate() {
        let toolbar = UIToolbar.toolbarPiker(target: periodTextField, action: #selector(resignFirstResponder))
        let cancelButton = UIBarButtonItem(title: "Отменить", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelAction))
        
        cancelButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.untTextStyle5Font()!], for: .normal)
        cancelButton.tintColor = UIColor.untGreyishBrownTwo
        
        toolbar.setItems([cancelButton] + (toolbar.items ?? []), animated: true)
        
        periodTextField.delegate = self
        periodTextField.inputAccessoryView = toolbar
    }
    
    @objc func cancelAction() {
        periodTextField.text = nil
        periodTextField.resignFirstResponder()
    }
    
    // MARK: Gestures
    
    private func activeTapGestureOnView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(_ :)))
        self.tableView.addGestureRecognizer(gesture)
    }
    
    @objc private func tapGestureAction(_ sender: UITapGestureRecognizer) {
        self.tableView.endEditing(true)
    }
    
    // MARK: DatePickerBinding
    
    private func bindBirthDatePicker() {
        self.bind(datePicker: birthDatePicker, toTextField: birthDateTextField, withSelector: #selector(birthDateDidSelect( _:)))
    }
    
    private func bindPeriodDatePicker() {
        self.bind(datePicker: periodPicker, toTextField: periodTextField, withSelector: #selector(periodDidSelect( _:)))
    }
    
    @objc private func birthDateDidSelect(_ sender: UIDatePicker) {
        let string = self.birthDateString(date: sender.date)
        self.birthDateTextField.text = string
    }
    
    @objc private func periodDidSelect(_ sender: UIDatePicker) {
        let string = self.periodDateString(date: sender.date)
        self.periodTextField.text = string
    }
    
    // MARK: Validations
    
    fileprivate func isAllValid() -> Bool {
        let isBaseValid =  self.validateAllertLabel(self.surnameAllertLabel)
                        && self.validateAllertLabel(self.nameAllerLabel)
                        && self.validateAllertLabel(self.middleNameAllerLabel)
                        && self.validateAllertLabel(self.taxCodeAllertLabel)
        
        let type = documentType
        
        if type == Constants.PaymentTypes.payroll {
            return isBaseValid && self.validateAllertLabel(self.accountAllertLabel)
        }
        
        if type == Constants.PaymentTypes.pensionContribution || type == Constants.PaymentTypes.medicalContribution || type == Constants.PaymentTypes.socialContribution {
           return isBaseValid
                    && self.validateAllertLabel(self.birthDateAllertLabel)
        }
        
        return isBaseValid
    }
    
    fileprivate func validateAll() {
        self.validateSurname()
        self.validateName()
        self.validateMiddleName()
        self.validateTaxCode()
        self.validateSum()
        
        if self.isDateBirthVisible() {
            self.validateBirthDate()
        }
        
        if self.isAccountVisible() {
             self.validateAccount()
        }
        
    }
    
    
    fileprivate func validateSurname() {
        self.validate(textField: surnameTextField,
                      errorLabel: surnameAllertLabel,
                      constraint: employeeConstraints?.lastName)
    }
    
    fileprivate func validateName() {
        self.validate(textField: nameTextField,
                      errorLabel: nameAllerLabel,
                      constraint: employeeConstraints?.firstName)
    }
    
    fileprivate func validateMiddleName() {
        self.validate(textField: middleNameTextField,
                      errorLabel: middleNameAllerLabel,
                      constraint: employeeConstraints?.middleName)
    }
    
    fileprivate func validateSum() {
        self.validate(textField: sumTextField,
                      errorLabel: sumAllertLabel,
                      constraint: employeeConstraints?.amount)
    }
    
    fileprivate func validateBirthDate() {
        self.validate(textField: birthDateTextField,
                      errorLabel: birthDateAllertLabel,
                      constraint: employeeConstraints?.birthDate)
    }
    
    fileprivate func validatePeriod() {
        self.validate(textField: periodTextField,
                      errorLabel: periodDateAllertLabel,
                      constraint: employeeConstraints?.period)
    }
    
    fileprivate func validateTaxCode() {
        self.validate(textField: taxCodeTextField,
                      errorLabel: taxCodeAllertLabel,
                      constraint: employeeConstraints?.taxCode)
    }
    
    fileprivate func validateAccount() {
        // КОСТЫЛЬ begin, бэк пока что не присылает это
        if employeeConstraints?.account?.account == nil {
            employeeConstraints?.account?.account = true
        }
        // КОСТЫЛЬ end
        self.validate(textField: accountTextField,
                      errorLabel: accountAllertLabel,
                      constraint: employeeConstraints?.account)
    }
    
    // MARK: Private functions
    
    private func fillWorkerFromUI(_ worker: Employee) {
        worker.lastName = self.surnameTextField.text
        worker.firstName = self.nameTextField.text
        worker.middleName = self.middleNameTextField.text
        worker.taxCode = self.taxCodeTextField.text
        
        guard let documentType = documentType else { return }
        switch documentType {
        case Constants.paymentsTypes[1]:
            worker.payrollString = self.sumTextField.text
        case Constants.paymentsTypes[2]:
            worker.pensionString = self.sumTextField.text
        case Constants.paymentsTypes[3]:
            worker.socialString = self.sumTextField.text
        case Constants.paymentsTypes[4]:
            worker.medicalString = self.sumTextField.text
        default: break
        }
        if self.isDateBirthVisible() {
            worker.birthDate = self.birthDateTextField.text
        }
        if self.isAccountVisible() {
            worker.account = self.accountTextField.text
        }
        if self.isPeriodVisible() {
            worker.period = self.periodTextField.text
        }
    }
    
    private func fillUIFromWorker(_ workerToChange: Employee?) {
        guard let worker = workerToChange else { return }
        self.surnameTextField.text = worker.lastName
        self.nameTextField.text = worker.firstName
        self.middleNameTextField.text = worker.middleName
        self.taxCodeTextField.text = worker.taxCode
        
        guard let documentType = documentType else { return }
        switch documentType {
        case Constants.paymentsTypes[1]:
            self.sumTextField.text = worker.payroll.flatMap{ String($0) }
        case Constants.paymentsTypes[2]:
            self.sumTextField.text = worker.pension.flatMap{ String($0) }
        case Constants.paymentsTypes[3]:
            self.sumTextField.text = worker.social.flatMap{ String($0) }
        case Constants.paymentsTypes[4]:
            self.sumTextField.text = worker.medical.flatMap{ String($0) }
        default: break
        }
        
        self.accountTextField.text = worker.account
        self.birthDateTextField.text = worker.birthDate
        self.periodTextField.text = worker.period
        
        self.validateAll()
    }
    
    private func initialBufferSetup() {
        self.innBuffers = workers.compactMap({ return $0.taxCode })
        workerToChange?.taxCode.map({ self.innBuffers.remove(object: $0) })
        self.accountBuffer = workers.compactMap({ return $0.account })
        workerToChange?.account.map({ self.accountBuffer.remove(object: $0) })
        
        self.bindBirthDatePicker()
        self.bindPeriodDatePicker()
    }
    
    private func isAccountVisible() -> Bool {
        return documentType == Constants.PaymentTypes.payroll
    }
    
    private func isDateBirthVisible() -> Bool {
        return documentType == Constants.PaymentTypes.socialContribution ||
                documentType == Constants.PaymentTypes.pensionContribution ||
                documentType == Constants.PaymentTypes.medicalContribution
    }
    
    private func isPeriodVisible() -> Bool {
        return documentType == Constants.PaymentTypes.pensionContribution ||
                documentType == Constants.PaymentTypes.socialContribution ||
                documentType == Constants.PaymentTypes.medicalContribution
    }
    
    //MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 4: return isDateBirthVisible() ? 70 : 0
        case 6: return isAccountVisible() ? 70 : 0
        case 7: return isPeriodVisible() ? 70 : 0
        default: return 70
        }
    }
    
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 4: return isDateBirthVisible() ? UITableView.automaticDimension : 0
        case 6: return isAccountVisible() ? UITableView.automaticDimension : 0
        default: return UITableView.automaticDimension
        }
    }
}

extension CreateEmployeeModalTableViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.sumTextField {
            if let amountText = textField.text, let amount = Double(amountText), amount.isZero {
                textField.text = ""
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.surnameTextField {
            self.validateSurname()
        } else if textField == self.nameTextField {
            self.validateName()
        } else if textField == self.middleNameTextField {
            self.validateMiddleName()
        } else if textField == self.taxCodeTextField {
            self.validateTaxCode()
        } else if textField == self.accountTextField {
            self.validateAccount()
        } else if textField == self.sumTextField {
            self.validateSum()
        } else if textField == self.birthDateTextField {
            self.validateBirthDate()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentCharactersCount = textField.text?.count ?? 0
        if range.length + range.location > currentCharactersCount { return false }
        guard let sourceString = textField.text  else { return true }
        let originString: NSString = sourceString as NSString
        let newString = originString.replacingCharacters(in: range, with: string)
        let newStringCount = newString.count
        
        if textField == self.taxCodeTextField {
            guard newStringCount <= Constants.maxINNCount else { return false }
        } else if textField == self.sumTextField {
            do {
                let expression = "^([0-9]+)?(\\.([0-9]{1,2})?)?$"
                let regex = try NSRegularExpression(pattern: expression, options: .caseInsensitive)
                let numberOfMatches = regex.numberOfMatches(in: newString, options: [], range: NSRange(location: 0, length: newString.count))
                if numberOfMatches == 0 {
                    return false
                }
            }
            catch _ {
            }
            return true
        } else if textField == self.accountTextField {
            return newStringCount <= Constants.maxIBANCount
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        
        return true
    }
}
