//
//  OperationsTableViewController.swift
//  DigitalBank
//
//  Created by Алем Утемисов on 06.05.2018.
//  Copyright © 2018 iosDeveloper. All rights reserved.
//

import UIKit
import RxSwift
import MobileCoreServices

public extension UITableViewCell {
    
    /// Table view cell reuse identifier
    public class var reuseIdentifier: String {
        return String(describing: self.self)
    }
}

class OperationsTableViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    let viewModel: OperationViewModel
    fileprivate let optionsButton: UIButton = UIButton()
    let tableView: UITableView = UITableView()
    let topBar = OperationsTableTopBar()
    fileprivate var keyboardActivatedCell: UITableViewCell?
    var inputFileOptionComponent: InputFileOptionComponent!
    
    // Proprerty indicator to detect if initial document was edited
    var isBeingEdited = false
    
    // MARK:
    fileprivate let optionsButtonHeight: CGFloat = 40
    fileprivate let defaultOffset: CGFloat = 16.0
    
    init(viewModel: OperationViewModel, title: String? = nil) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.title = title
        inputFileOptionComponent = InputFileOptionComponent(viewController: self)
    }
    
    override func loadView() {
        super.loadView()
        setupNavigationBar(title: title)
        setupTableView()
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        addKeyboardEvents()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardEvents()
    }
    
    func setupNavigationBar(title: String?) {
        view.addSubview(topBar)
        topBar.backButtonAction = { [unowned self] in
            if self.isBeingEdited {
                let alertController = UIAlertController(title: "СООБЩЕНИЕ", message: "Внесенные изменения будут потеряны. Вы уверены что хотите закрыть страницу документа?", preferredStyle: .alert)
                let yesAction = UIAlertAction(title: "Да", style: .default) { _ in
                    self.navigationController?.popViewController(animated: true)
                }
                alertController.addAction(yesAction)
                let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
        topBar.titleLabel.text = title
    }
    
    func setupViews() {
        view.addSubview(optionsButton)
        guard let actions = viewModel.documentActionDataArray, !actions.isEmpty else {
            optionsButton.isHidden = true
            return
        }
        optionsButton.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        optionsButton.backgroundColor = AppColor.green.uiColor
        optionsButton.layer.cornerRadius = optionsButtonHeight / 2
        optionsButton.layer.masksToBounds = false
        optionsButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        optionsButton.layer.shadowOpacity = 0.2
        optionsButton.layer.shadowRadius = 0.5
        optionsButton.addTarget(self, action: #selector(presentActionSheet), for: .touchUpInside)
    }
    
    func setupConstraints() {
        topBar.addConstaintsToHorizontal()
        topBar.topAnchor.constraint(equalTo: view.topAnchor, constant: statusBarHeight).isActive = true
        topBar.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: topBar.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        if let actions = viewModel.documentActionDataArray, !actions.isEmpty {
            tableView.contentInset.bottom = defaultOffset + optionsButtonHeight + defaultOffset
        } else {
            tableView.contentInset.bottom = defaultOffset
        }
        
        optionsButton.translatesAutoresizingMaskIntoConstraints = false
        optionsButton.widthAnchor.constraint(equalToConstant: optionsButtonHeight).isActive = true
        optionsButton.heightAnchor.constraint(equalToConstant: optionsButtonHeight).isActive = true
        optionsButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -defaultOffset).isActive = true
        optionsButton.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -defaultOffset).isActive = true
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        
        
        
        tableView.separatorColor = AppColor.lineColor.uiColor
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
        tableView.keyboardDismissMode = .onDrag
        tableView.allowsSelectionDuringEditing = false
        tableView.estimatedRowHeight = 58.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TitledTextFieldCell.self, forCellReuseIdentifier: TitledTextFieldCell.reuseIdentifier)
        tableView.register(StaticContentCell.self, forCellReuseIdentifier: StaticContentCell.reuseIdentifier)
        tableView.register(ToggleContentCell.self, forCellReuseIdentifier: ToggleContentCell.reuseIdentifier)
        tableView.register(TitledDatePickerCell.self, forCellReuseIdentifier: TitledDatePickerCell.reuseIdentifier)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadTableViewEntirely()
    }
    
    @objc private func presentActionSheet() {
        let actionSheet = UIAlertController(title: "Выберите операцию", message: nil, preferredStyle: .actionSheet)
        guard let actionDataArray = viewModel.documentActionDataArray, !actionDataArray.isEmpty else {
            return
        }
        
        for actionData in actionDataArray {
            let title = actionData.type.documentDetailsLocalizedValue
            let style: UIAlertAction.Style  = actionData.type == .remove ? .destructive : .default
            let alertAction = UIAlertAction(title: title, style: style) { _ in
                actionData.callback()
            }
            actionSheet.addAction(alertAction)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }
    
    func reloadTableViewByCells() {
        var rowsToReload: [IndexPath] = []
        for (index, component) in viewModel.visibleComponents.enumerated() {
            guard component.isReloadNeeded else { continue }
            rowsToReload.append(IndexPath(row: index, section: 0))
            component.isReloadNeeded = false
        }
        tableView.reloadRows(at: rowsToReload, with: UITableView.RowAnimation.automatic)
    }
    
    func reloadTableViewEntirely() {
        guard isViewLoaded else { return }
        viewModel.visibleComponents.forEach { $0.isReloadNeeded = false }
        tableView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension OperationsTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? TitledTextFieldCell
        let initialText = cell?.titledTextFieldView.valueTextField.text
        
        let component = viewModel.visibleComponents[indexPath.row]
        switch component.type {
        case .amount, .textfield:
            guard let cell = tableView.cellForRow(at: indexPath) as? TitledTextFieldCell else { return }
            cell.titledTextFieldView.valueTextField.becomeFirstResponder()
        case .searchTextField:
            let dataSource = viewModel.dataSource(for: component) ?? []
            let vc = OptionsViewController(dataSource: dataSource, textFieldTitle: component.title, textFieldDescription: component.placeholder ?? component.description, textFieldValue: component.value, editable: true, onOptionSelectCallback: {[unowned self] (selected) in
                if initialText != selected?.id {
                    self.isBeingEdited = true
                }
                if self.viewModel.optionSelectedWithLoaded(selected, component: component, completion: { [weak self] success, error in
                    Loader.shared.hide()
                    if let error = error {
                        self?.presentErrorController(title: "Ошибка", message: error)
                    }
                    self?.reloadTableViewEntirely()
                }) {
                    Loader.shared.show()
                }
                self.reloadTableViewEntirely()
            }) { [unowned self] (text) in
                if initialText != text {
                    self.isBeingEdited = true
                }
                if self.viewModel.textfieldValueChangedWithLoaded(text, component: component, completion:{ [weak self] success, error in
                    Loader.shared.hide()
                    if let error = error {
                        self?.presentErrorController(title: "Ошибка", message: error)
                    }
                    self?.reloadTableViewEntirely()
                }) {
                    Loader.shared.show()
                }
                self.reloadTableViewEntirely()
            }
            vc.textFieldValidation = {[unowned self] text in
                let isValid = self.viewModel.isValid(nil, typedText: text, for: component)
                vc.titledTextFieldView.errorText = component.errorDescription
                return isValid
            }
            vc.onSearchCallback = {[weak self] text, callback in
                self?.viewModel.searchResults(for: text ?? "", in: component, optionsDataSourceCallback: callback)
            }
            
            component.uiProperties.forEach { uiProperty in
                switch uiProperty {
                case .autocapitalizationType(let value):
                    vc.titledTextFieldView.valueTextField.autocapitalizationType = value
                case .isMultiLineEnabled(let value):
                    vc.titledTextFieldView.isMultiLineEnabled = value
                default:
                    break
                }
            }
            navigationController?.pushViewController(vc, animated: false)
        case .options:
            let dataSource = viewModel.dataSource(for: component) ?? []
            let vc = OptionsViewController(dataSource: dataSource, textFieldTitle: component.title, textFieldDescription: component.placeholder ?? component.description, editable: false, onOptionSelectCallback: { [unowned self] (selected) in
                if initialText != selected?.id {
                    self.isBeingEdited = true
                }
                if self.viewModel.optionSelectedWithLoaded(selected, component: component, completion:{ [weak self] success, error in
                    Loader.shared.hide()
                    if let error = error {
                        self?.presentErrorController(title: "Ошибка", message: error)
                    }
                    self?.reloadTableViewEntirely()
                }) {
                    Loader.shared.show()
                }
                self.reloadTableViewEntirely()
            })
            navigationController?.pushViewController(vc, animated: false)
        case .employees:
            if let viewModel = viewModel as? (OperationViewModel & ContributionViewModel) {
                if viewModel.canViewEmployees {
                    let employeesVC = EmployeesLongTermAssignmentsController()
                    employeesVC.employees = viewModel.employees
                    employeesVC.isRegularTransfer = false
                    employeesVC.documentType = viewModel.documentType
                    employeesVC.viewModel = viewModel
                    navigationController?.pushViewController(employeesVC, animated: true)
                }
                else {
                    let employeesVC = UIStoryboard.controllerFromStorybourd("DomesticTransfer", cls: DomesticTransferFifthPageTableViewController.self)
                    employeesVC.onEmployeesUpdate = { [weak self] in
                        self?.isBeingEdited = true
                    }
                    employeesVC.viewModel = viewModel
                    navigationController?.pushViewController(employeesVC, animated: true)
                }
            }
        case .date:
            guard let cell = tableView.cellForRow(at: indexPath) as? TitledDatePickerCell else { return }
            cell.titledDatePickerView.valueTextField.becomeFirstResponder()
        case .imageOptions:
            let dataSource = viewModel.dataSource(for: component) ?? []
            let vc = ImageOptionsViewController(dataSource: dataSource) { [unowned self] (selected) in
                print("selected image option")
                self.viewModel.optionSelectedWithLoaded(selected, component: component, completion:{ [weak self] success, error in
                    if let error = error {
                        self?.presentErrorController(title: "Ошибка", message: error)
                    }
                    self?.reloadTableViewEntirely()
                })
            }
            navigationController?.pushViewController(vc, animated: true)
        case .inputFile:
            if let fileIdString = component.value {
                self.viewModel.optionUnselectFile(fileId: Int(fileIdString)!, component: component) { [weak self] (success, error) in
                    guard let self = self else { return }
                    if let error = error {
                        self.presentErrorController(title: "Ошибка", message: error)
                    }
                    self.reloadTableViewEntirely()
                }
            } else {
                inputFileOptionComponent.showDocumentMenu { [weak self] (fileURL) in
                    guard let self = self else { return }
                    self.viewModel.optionSelectFile(fileURL: fileURL, component: component) { [weak self] (success, error) in
                        guard let self = self else { return }
                        if let error = error {
                            self.presentErrorController(title: "Ошибка", message: error)
                        }
                        self.reloadTableViewEntirely()
                    }
                }
            }
        default:
            break
        }
    }
}

extension OperationsTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let component = viewModel.visibleComponents[indexPath.row]
        switch component.type {
        case .amount:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TitledTextFieldCell.reuseIdentifier, for: indexPath) as? TitledTextFieldCell else { return TitledTextFieldCell() }
            cell.titledTextFieldView.titleLabel.text = component.title
            if let placeHolder = component.placeholder {
                cell.titledTextFieldView.setPlaceholder(placeHolder)
            }
            cell.titledTextFieldView.valueTextField.keyboardType = .decimalPad
            cell.titledTextFieldView.valueTextField.text = component.value ?? component.description
            cell.titledTextFieldView.errorText = component.errorDescription
            cell.titledTextFieldView.descriptionText = component.description
            cell.titledTextFieldView.performOnEndEditing = {[unowned self] text in
                if self.viewModel.amountFieldValueChangeWithLoaded(text, component: component, completion: {[weak self] success, error in
                    Loader.shared.hide()
                    if let error = error {
                        self?.presentErrorController(title: "Ошибка", message: error)
                    }
                    self?.reloadTableViewEntirely()
                }) {
                    Loader.shared.show()
                } else {
                    self.reloadTableViewEntirely()
                }
            }
            cell.titledTextFieldView.performOnBeginEditing = { [unowned self, unowned cell] in
                if let amount = Float(cell.titledTextFieldView.valueTextField.text ?? ""), amount.isZero {
                    cell.titledTextFieldView.valueTextField.text = ""
                }
                self.keyboardActivatedCell = cell
            }
            let initialText = cell.titledTextFieldView.valueTextField.text
            cell.titledTextFieldView.performOnEdit = { [unowned self] text in
                if initialText != text {
                    self.isBeingEdited = true
                }
            }
            component.uiProperties.forEach { uiProperty in
                switch uiProperty {
                case .isUserInteractionEnabled(let value):
                    cell.isUserInteractionEnabled = value
                    cell.titledTextFieldView.iconImageView.isHidden = !value
                case .autocapitalizationType(let value):
                    cell.titledTextFieldView.valueTextField.autocapitalizationType = value
                default:
                    break
                }
            }
            return cell
        case .textfield:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TitledTextFieldCell.reuseIdentifier, for: indexPath) as? TitledTextFieldCell else { return TitledTextFieldCell() }
            cell.titledTextFieldView.titleLabel.text = component.title
            if let placeHolder = component.placeholder {
                cell.titledTextFieldView.setPlaceholder(placeHolder)
            }
            cell.titledTextFieldView.valueTextField.text = component.value ?? component.description
            cell.titledTextFieldView.errorText = component.errorDescription
            cell.titledTextFieldView.descriptionText = component.description
            cell.titledTextFieldView.iconImageView.tintColor = AppColor.dark.uiColor
            let initialText = cell.titledTextFieldView.valueTextField.text
            cell.titledTextFieldView.performTextValidation = { [unowned self] text in
                let isValid = self.viewModel.isValid(cell.titledTextFieldView.valueTextField.text, typedText: text, for: component)
                if !isValid {
                    self.reloadTableViewByCells()
                }
                return isValid
            }
            cell.titledTextFieldView.performOnEdit = { [unowned self] text in
                if initialText != text {
                    self.isBeingEdited = true
                }
            }
            cell.titledTextFieldView.performOnEndEditing = {[unowned self] text in
                if self.viewModel.textfieldValueChangedWithLoaded(text, component: component, completion:{ [weak self] success, error in
                    Loader.shared.hide()
                    if let error = error {
                        self?.presentErrorController(title: "Ошибка", message: error)
                    }
                    self?.reloadTableViewByCells()
                }) {
                    Loader.shared.show()
                } else {
                    self.reloadTableViewByCells()
                }
            }
            cell.titledTextFieldView.performOnBeginEditing = { [unowned self, unowned cell] in
                self.keyboardActivatedCell = cell
            }
            
            component.uiProperties.forEach { uiProperty in
                switch uiProperty {
                case .isUserInteractionEnabled(let value):
                    cell.isUserInteractionEnabled = value
                    cell.titledTextFieldView.iconImageView.isHidden = !value
                case .autocapitalizationType(let value):
                    cell.titledTextFieldView.valueTextField.autocapitalizationType = value
                default:
                    break
                }
            }
            return cell
        case .searchTextField:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TitledTextFieldCell.reuseIdentifier, for: indexPath) as? TitledTextFieldCell else { return TitledTextFieldCell() }
            cell.titledTextFieldView.titleLabel.text = component.title
            cell.titledTextFieldView.valueTextField.text = component.value ?? component.description
            cell.titledTextFieldView.errorText = component.errorDescription
            cell.titledTextFieldView.canEdit = false
             cell.titledTextFieldView.descriptionText = component.description
            if let placeHolder = component.placeholder {
                cell.titledTextFieldView.setPlaceholder(placeHolder)
            }
 
            component.uiProperties.forEach { uiProperty in
                switch uiProperty {
                case .isUserInteractionEnabled(let value):
                    cell.isUserInteractionEnabled = value
                    cell.titledTextFieldView.iconImageView.isHidden = !value
                case .isBlockedAccountFillTextColor(let value):
                    cell.titledTextFieldView.valueTextField.textColor = value
                    cell.titledTextFieldView.setDescriptionLabelTextColor(textColor: value)
                default:
                    break
                }
            }
            return cell
        case .label:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StaticContentCell.reuseIdentifier, for: indexPath) as? StaticContentCell else { return StaticContentCell() }
            cell.staticContentView.title = component.title
            cell.staticContentView.value = component.value ?? component.description
            cell.staticContentView.error = component.errorDescription
            return cell
        case .switcher:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ToggleContentCell.reuseIdentifier, for: indexPath) as? ToggleContentCell else { return ToggleContentCell() }
            cell.toggleContentView.titleLabel.text = component.title
            cell.toggleContentView.errorDescription = component.errorDescription
            cell.toggleContentView.toggle.isOn = component.getValue() ?? false
            let initialToggleState = cell.toggleContentView.toggle.isOn
            cell.toggleContentView.performOnSwitch = {[unowned self] isOn in
                self.view.endEditing(true)
                if initialToggleState != isOn {
                    self.isBeingEdited = true
                }
                if self.viewModel.switchedWithLoaded(to: isOn, component: component, completion: { [weak self] success, error in
                    Loader.shared.hide()
                    if let error = error {
                        self?.presentErrorController(title: "Ошибка", message: error)
                    }
                    self?.reloadTableViewEntirely()
                }) {
                    Loader.shared.show()
                }
                self.reloadTableViewEntirely()
            }
            component.uiProperties.forEach { uiProperty in
                switch uiProperty {
                case .isUserInteractionEnabled(let value):
                    cell.isUserInteractionEnabled = value
                default:
                    break
                }
            }
            return cell
        case .options, .employees:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TitledTextFieldCell.reuseIdentifier, for: indexPath) as? TitledTextFieldCell else { return TitledTextFieldCell() }
            cell.titledTextFieldView.titleLabel.text = component.title
            cell.titledTextFieldView.valueTextField.text = component.value ?? component.description
            cell.titledTextFieldView.errorText = component.errorDescription
            cell.titledTextFieldView.canEdit = false
            let image = AppImage.arrowDownLight.uiImage?.withRenderingMode(.alwaysTemplate)
            cell.titledTextFieldView.setImageIcon(image: image)
            cell.titledTextFieldView.descriptionText = component.description
            if let placeHolder = component.placeholder {
                cell.titledTextFieldView.setPlaceholder(placeHolder)
            }
             component.uiProperties.forEach { uiProperty in
                switch uiProperty {
                case .isUserInteractionEnabled(let value):
                    cell.isUserInteractionEnabled = value
                    cell.titledTextFieldView.iconImageView.isHidden = !value
                case .isBlockedAccountFillTextColor(let value):
                    cell.titledTextFieldView.valueTextField.textColor = value
                    cell.titledTextFieldView.setDescriptionLabelTextColor(textColor: value)
                default:
                    break
                }
            }
            return cell
        case .date:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TitledDatePickerCell.reuseIdentifier, for: indexPath) as? TitledDatePickerCell else { return TitledDatePickerCell() }
            cell.titledDatePickerView.titleLabel.text = component.title
            cell.titledDatePickerView.valueTextField.keyboardType = .default
            cell.titledDatePickerView.valueTextField.text = component.value ?? component.description
            cell.titledDatePickerView.validationText = component.errorDescription
            cell.titledDatePickerView.performOnEndEditing = {[unowned self] text in
                if self.viewModel.textfieldValueChangedWithLoaded(text, component: component, completion:{ [weak self] success, error in
                    Loader.shared.hide()
                    if let error = error {
                        self?.presentErrorController(title: "Ошибка", message: error)
                    }
                    self?.reloadTableViewEntirely()
                }) {
                    Loader.shared.show()
                }
                self.reloadTableViewEntirely()
            }
            cell.titledDatePickerView.performOnBeginEditing = { [unowned self, unowned cell] in
                self.keyboardActivatedCell = cell
            }
            let initialText = cell.titledDatePickerView.valueTextField.text
            cell.titledDatePickerView.performOnEdit = { [unowned self] text in
                if initialText != text {
                    self.isBeingEdited = true
                }
            }
            if let placeHolder = component.placeholder {
                cell.titledDatePickerView.setPlaceholder(placeHolder)
            }
            component.uiProperties.forEach { uiProperty in
                switch uiProperty {
                case .useMonthAndYearDateFormat(let value):
                    cell.titledDatePickerView.useMonthAndYearDateFormat = value
                case .isUserInteractionEnabled(let value):
                    cell.isUserInteractionEnabled = value
                default:
                    break
                }
            }
            return cell
        case .imageOptions:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TitledTextFieldCell.reuseIdentifier, for: indexPath) as? TitledTextFieldCell else { return TitledTextFieldCell() }
            cell.titledTextFieldView.titleLabel.text = component.title
            cell.titledTextFieldView.valueTextField.text = component.value ?? component.description
            cell.titledTextFieldView.errorText = component.errorDescription
            cell.titledTextFieldView.canEdit = false
            let image = AppImage.arrowDownLight.uiImage?.withRenderingMode(.alwaysTemplate)
            cell.titledTextFieldView.setImageIcon(image: image)
            cell.titledTextFieldView.descriptionText = component.description
            if let placeHolder = component.placeholder {
                cell.titledTextFieldView.setPlaceholder(placeHolder)
            }
            component.uiProperties.forEach { uiProperty in
                switch uiProperty {
                case .isUserInteractionEnabled(let value):
                    cell.isUserInteractionEnabled = value
                    cell.titledTextFieldView.iconImageView.isHidden = !value
                default:
                    break
                }
            }
            return cell
        case .inputFile:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TitledTextFieldCell.reuseIdentifier, for: indexPath) as? TitledTextFieldCell else { return TitledTextFieldCell() }
            cell.titledTextFieldView.titleLabel.text = component.title
            print(component)
            cell.titledTextFieldView.valueTextField.text = component.description
            cell.titledTextFieldView.errorText = component.errorDescription
            cell.titledTextFieldView.canEdit = false
            if (component.value == nil) {
             } else {
             }
            if let placeHolder = component.placeholder {
                cell.titledTextFieldView.setPlaceholder(placeHolder)
            }
            component.uiProperties.forEach { uiProperty in
                switch uiProperty {
                case .isUserInteractionEnabled(let value):
                    cell.isUserInteractionEnabled = value
                    cell.titledTextFieldView.iconImageView.isHidden = !value
                default:
                    break
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.visibleComponents.count
    }
    
}

extension OperationsTableViewController {
    // MARK: Keyboard related events observation
    
    /// Start observing keyboard events
    fileprivate func addKeyboardEvents() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// Stop observing keyboard events
    fileprivate func removeKeyboardEvents() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// Perform when keyboard will show
    ///
    /// - Parameter notification: notification container
    @objc fileprivate func keyboardWillShow(notification: Notification) {
        guard let keyboardActivatedCell = keyboardActivatedCell,
            let infoNSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                return
        }
        
        let keyboardFrame = infoNSValue.cgRectValue
        let cellGlobalFrame = tableView.convert(keyboardActivatedCell.frame, to: nil)
        let coveredSpace = cellGlobalFrame.maxY - keyboardFrame.origin.y
        if coveredSpace > 0 {
            tableView.contentOffset.y += coveredSpace
        }
    }
    
    /// Perform when keyboard will hide
    ///
    /// - Parameter notification: notification container
    @objc fileprivate func keyboardWillHide(notification: Notification) {
        keyboardActivatedCell = nil
    }
}

extension OperationsTableViewController: OperationsTableViewControllerProtocol {
    
}

protocol OperationsTableViewControllerProtocol: class {
    func presentErrorController(title: String?, message: String?)
    func reloadTableViewByCells()
}
