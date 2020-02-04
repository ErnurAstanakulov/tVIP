//
//  DomesticTransferAbstract.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 2/24/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import UIKit
import DropDown

@objc protocol DomesticTransferProtocol {
    @objc var sourсeData: DomesticTransferSourсeData? { get set }
    // Fill UI sourсeData (sourсe information from server)
    @objc func fillFrom(sourсeData: DomesticTransferSourсeData)
    
    // Fill UI from model
    @objc func fillFrom(template: DomesticTransfer)
    
    //Fill model from UI for post sending
    @objc func fillDocument(_ document: DomesticTransferToSend)
}

class DomesticTransferAbstractTableViewController: UITableViewController, DomesticTransferProtocol {
    
    //ALERT: Be aware of reloading this property in child classes 
    public var sourсeData: DomesticTransferSourсeData? {
        didSet { sourсeData.map {
                if self.isViewLoaded {
                    self.fillFrom(sourсeData: $0)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cellAutoHeight()
        
        tableView.contentInset.bottom = 76
    }
    
    //HAVE to be reloaded in childClasses
    //Desc: sourсe information loaded from server.
    public func fillFrom(sourсeData: DomesticTransferSourсeData) {
    }
    
    //MARK: Public methods
    
    public func fillFrom(template: DomesticTransfer) {
    }
    
    func fillDocument(_ document: DomesticTransferToSend) {
    }
    
    // MARK: Public Validations
    
    @discardableResult
    public func validate(textField: UITextField, errorLabel: UILabel, constraint: BaseConstraint?) -> Bool {
        let isValid = Validator.validate(textField: textField, errorLabel: errorLabel, constraint: constraint)
        self.tableView.update {}
        return isValid
    }
    
    public func emptyValidation(field: UITextField,bindTo labal: UILabel) {
        let value = field.text
        let isValid = value != "" && value != nil
        self.processValidationResult(isValid: isValid, allertLabel: labal, alletMessage: "Обязательное поле")
    }
    
    public func processValidationResult(isValid: Bool, allertLabel: UILabel, alletMessage message: String) {
        allertLabel.isHidden = isValid
        allertLabel.text = isValid ? nil : message
        self.tableView.update {}
    }
    
    // MARK: Public UIComponents binding
    
    public func bind(datePicker: UIDatePicker, toTextField textField: UITextField, withSelector selector: Selector) {
        datePicker.date = Date()
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.datePickerMode = .date
        textField.inputView = datePicker
        datePicker.addTarget(self, action: selector, for: .valueChanged)
    }
    
    public typealias DropDownAction = (Index, String) -> ()
    public func dropDownWith(textField: UITextField, sourсeData: [String], action: @escaping DropDownAction) -> DropDown {
        let dropDown = DropDown(anchorView: textField,
            selectionAction: action,
            dataSource: sourсeData,
            topOffset: CGPoint(x: 0, y: -textField.bounds.height),
            bottomOffset: CGPoint(x: 0, y: textField.bounds.height),
            cellConfiguration: nil,
            cancelAction: {
                textField.endEditing(true)
            })
        
        if let superview = textField.superview {
            dropDown.anchorView = superview
            dropDown.topOffset = CGPoint(x: 0, y: -superview.bounds.height)
            dropDown.bottomOffset = CGPoint(x: 0, y: superview.bounds.height)
        }
        
        dropDown.backgroundColor = UIColor.white
        
        return dropDown
    }
    
    public func validateAllertLabel(_ label: UILabel) -> Bool {
        return label.isHidden
    }
    
    public func periodDateString(date: Date) -> String {
        return date.stringWith(format: "MM.yyyy")
    }
    
    public func birthDateString(date: Date) -> String {
        return date.stringWith(format: "dd.MM.yyyy")
    }
    
    // MARK: Private 
    
    public func cellAutoHeight() {
        let tebleView = self.tableView
        tebleView?.rowHeight = UITableView.automaticDimension
        tebleView?.estimatedRowHeight = 70
    }
    
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
