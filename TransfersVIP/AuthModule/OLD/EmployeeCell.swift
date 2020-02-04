//
//  BankCustomerCell.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 3/10/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EmployeeCell: ShadedTableViewCell {
    
    public var isSelecteBlock: ((_ :CheckBox) -> ())?
    public var changeEmployeeBlock: ((_ :UIButton) -> ())?
    public var deleteEmployeeBlock: ((_ :UIButton) -> ())?
    public var didChangeAmount: ((String) -> ())?
    public var disposables: [Disposable] = []
    public var documentType: String? = nil

    @IBOutlet var isSelectedButton: CheckBox!
    @IBOutlet var changeEmployeeButton: UIButton!
//    @IBOutlet var deleteEmployeeButton: UIButton!
    
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var fullNameLabel: UILabel!
    
    @IBOutlet var taxCodeLabel: UILabel!
    @IBOutlet var amountTextField: UITextField!
    @IBOutlet weak var separatorView: UIView!
    
    public var index: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        roundedCorners = .all
        isSelectedButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    override func prepareForReuse() {
        self.isSelectedButton.isChecked = false
        self.isSelecteBlock = nil
        self.changeEmployeeBlock = nil
        self.deleteEmployeeBlock = nil
        self.didChangeAmount = nil
        self.numberLabel.text = nil
        self.fullNameLabel.text = nil
        self.taxCodeLabel.text = nil
        self.amountTextField.text = nil
        dispose()
    }
    
    deinit {
        dispose()
    }
    
    func dispose() {
        for disposable in disposables {
            disposable.dispose()
        }
        disposables = []
    }
    
    public func fillWithCoWorker(_ worker: Employee) {
        self.numberLabel.text = index
        
        fullNameLabel.text = nil
        taxCodeLabel.text = nil
        amountTextField.text = nil
        numberLabel.text = nil
        
        let fullNameObserveble = Observable<String>.combineLatest(worker._lastName, worker._firstName, worker._middleName) { lastname, firsname, middleName in
            return String(format: "\(lastname) \(firsname) \(middleName)")
        }
        
        let nameDisposable = fullNameObserveble.asObservable()
            .asDriver(onErrorJustReturn: "")
            .drive(fullNameLabel.rx.text)
        disposables.append(nameDisposable)
        
        
        let selectedDisposable = worker._isSelected.subscribe(onNext: { [unowned self] boolValue in
            self.isSelectedButton.isChecked = boolValue
        })
        disposables.append(selectedDisposable)
        let amountObservable: Observable<Double>
        guard let documentType = self.documentType else { return }
        switch documentType {
        case Constants.paymentsTypes[1]:
            amountObservable = worker._payroll
        case Constants.paymentsTypes[2]:
            amountObservable = worker._pension
        case Constants.paymentsTypes[3]:
            amountObservable = worker._social
        case Constants.paymentsTypes[4]:
            amountObservable = worker._medical
        default:
            amountObservable = DoubleSubject(1)
            break
        }
        let amountDisposable = amountObservable.asDriver(onErrorJustReturn: 0.0)
            .do(onNext: { [unowned self] summ in
                self.amountTextField.textColor = summ == 0.0 ? UIColor.red : UIColor.colorFromHex(hex: "#635957")
            })
            .filter {[weak self] _ in
                self?.amountTextField.isFirstResponder == false
            }
            .map{ String(format: "%.02f", $0) }
            .drive(amountTextField.rx.text)
        disposables.append(amountDisposable)
        
        let amountChangeDisposable = amountTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .map { Double($0) }
            .bind { (number) in
                switch documentType {
                case Constants.paymentsTypes[1]:
                    worker.payroll = number
                case Constants.paymentsTypes[2]:
                    worker.pension = number
                case Constants.paymentsTypes[3]:
                    worker.social = number
                case Constants.paymentsTypes[4]:
                    worker.medical = number
                default: break
                }
        }
        disposables.append(amountChangeDisposable)
        let taxCodeDisposable = worker._taxCode.asDriver(onErrorJustReturn: "")
            .drive(taxCodeLabel.rx.text)
        disposables.append(taxCodeDisposable)
    }
    
    //MARK: Actions
    
    @IBAction func isSelectedButtonAction(_ sender: CheckBox) {
        self.isSelecteBlock.map { $0(sender) }
    }
    
    @IBAction func changeEmployeeButtonAction(_ sender: UIButton) {
        self.changeEmployeeBlock.map { $0(sender) }
    }
    
    @IBAction func deleteEmployeeButtonAction(_ sender: UIButton) {
        self.deleteEmployeeBlock.map { $0(sender) }
    }
}
