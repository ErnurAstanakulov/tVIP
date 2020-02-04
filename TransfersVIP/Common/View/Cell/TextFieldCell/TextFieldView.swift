//
//  TextFieldView.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/3/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

/// View designed for TextFieldCell as a subview
class TextFieldView: UIView {
    
    /// UI elements
    let stackView = UIStackView()
    let titleLabel = UILabel()
    let descriptionTextView = MTextView()
    let placeholderLabel = UILabel()
    let optionalLabel = UILabel()
    
    /// Object intended for delegate methods to identify the cell
    var indexPath: IndexPath?
    
    /// Optional text components for picker input
    var pickerComponents: [String]?
    var pickerIndexPath: IndexPath?
    
    /// Optional constraint for characters of the description
    var maximumCharactersCount: Int?
    var dateFormat: DateFormat = .ddMMyyyy(separator: ".")
    var datePickerMode: UIDatePicker.Mode = .date
    var minimumDate: Date?
    var maximumDate: Date?
    var minuteInterval = 1
    
    var textValidator: TextValidator?
    
    /// Object inteded to perform updates
    weak var delegate: TextFieldViewCellDelegate? {
        didSet { descriptionTextView.delegate = self }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setViewConstraints()
        stylizeViews()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(startEditing))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionTextView)
        addSubview(placeholderLabel)
    }
    
    private func setViewConstraints() {
        // stackView
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        
        // titleLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 18).isActive = true
        
        // placeholderLabel
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.topAnchor.constraint(equalTo: descriptionTextView.topAnchor, constant: 4).isActive = true
        placeholderLabel.leftAnchor.constraint(equalTo: descriptionTextView.leftAnchor).isActive = true
        placeholderLabel.rightAnchor.constraint(equalTo: descriptionTextView.rightAnchor).isActive = true
    }
    
    private func stylizeViews() {
        // stackView
        stackView.axis = .vertical
        stackView.distribution = .fill
        
        // titleLabel
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = .gray
        titleLabel.isUserInteractionEnabled = false
        titleLabel.numberOfLines = 0
        
        // descriptionTextField
        descriptionTextView.isUserInteractionEnabled = true
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.font = .systemFont(ofSize: 16)
        descriptionTextView.tintColor = AppColor.gray.uiColor
        descriptionTextView.textContainer.lineBreakMode = .byTruncatingHead
        descriptionTextView.textColor = .black
        descriptionTextView.keyboardType = .default
        descriptionTextView.backgroundColor = .clear
        descriptionTextView.autocorrectionType = .no
        descriptionTextView.returnKeyType = .default
        descriptionTextView.autocapitalizationType = .none
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 4, left: -5, bottom: 0, right: 0)
        descriptionTextView.inputAccessoryView = UIToolbar.inputAccessoryView(
            hideKeyboardTarget: descriptionTextView,
            hideKeyboardAction: #selector(endEditing),
            optionalActionTarget: self,
            optionalActionAction: #selector(performOnOptionalActionButtonPress)
        )
        
        // placeholderLabel
        placeholderLabel.backgroundColor = .clear
        placeholderLabel.isUserInteractionEnabled = false
        placeholderLabel.numberOfLines = 0
        placeholderLabel.font = .systemFont(ofSize: 16)
        placeholderLabel.textColor = UIColor.lightGray
        
        // optionalLabel
        optionalLabel.isUserInteractionEnabled = false
        optionalLabel.numberOfLines = 0
        optionalLabel.font = .systemFont(ofSize: 14, weight: .light)
    }
    
    /// Method to be called before cell reuse
    func prepareForReuse() {
        delegate = nil
        indexPath = nil
        titleLabel.text = nil
        titleLabel.font = .systemFont(ofSize: 14)
        descriptionTextView.text = nil
        descriptionTextView.keyboardType = .default
        descriptionTextView.inputView = nil
        descriptionTextView.font = .systemFont(ofSize: 16)
        placeholderLabel.text = nil
        placeholderLabel.font = .systemFont(ofSize: 16)
        maximumCharactersCount = nil
        dateFormat = .ddMMyyyy(separator: ".")
        datePickerMode = .date
        minimumDate = nil
        maximumDate = nil
        minuteInterval = 1
        textValidator = nil
        isUserInteractionEnabled = true
        optionalLabel.text = nil
        optionalLabel.font = .systemFont(ofSize: 14, weight: .light)
        pickerComponents = nil
    }
    
    /// Set input type for cell
    ///
    /// - Parameter inputType: cell input type
    func set(inputType: TextFieldCellInputType) {
        switch inputType {
        case .keyboard(let type):
            descriptionTextView.keyboardType = type
            descriptionTextView.inputView = nil
        case .picker(let components, let row):
            let pickerView = UIPickerView()
            pickerView.tintColor = AppColor.green.uiColor
            pickerView.delegate = self
            pickerView.dataSource = self
            descriptionTextView.inputView = pickerView
            pickerComponents = components
            pickerView.selectRow(row, inComponent: 0, animated: true)
//        case .pickerDetailed(let details, let row):
//            let pickerView = UIPickerView()
//            pickerView.tintColor = AppColor.green.uiColor
//            pickerView.delegate = self
//            pickerView.dataSource = self
//            descriptionTextView.inputView = pickerView
////            pickerDetailComponents = details
//            pickerView.selectRow(row, inComponent: 0, animated: true)
        case .datePicker:
            let datePicker = UIDatePicker()
            if let date = descriptionTextView.text?.date(withFormat: dateFormat) {
                datePicker.date = date
            }
            datePicker.minimumDate = minimumDate
            datePicker.maximumDate = maximumDate
            datePicker.datePickerMode = datePickerMode
            datePicker.minuteInterval = minuteInterval
            datePicker.tintColor = AppColor.green.uiColor
            datePicker.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
            datePicker.addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
            datePicker.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
            descriptionTextView.inputView = datePicker
        }
    }
    
    @objc func startEditing() {
        descriptionTextView.becomeFirstResponder()
    }
    
    @objc private func valueChanged(_ datePicker: UIDatePicker) {
        if datePicker.datePickerMode == .date {
            descriptionTextView.text = datePicker.date.string(withFormat: dateFormat)
        } else if datePicker.datePickerMode == .time {
            descriptionTextView.text = datePicker.date.stringOfTime()
        }
        textViewDidChange(descriptionTextView)
    }
    
    @objc private func editingDidBegin(_ datePicker: UIDatePicker) {
        textViewDidBeginEditing(descriptionTextView)
    }
    
    @objc private func editingDidEnd(_ datePicker: UIDatePicker) {
        textViewDidEndEditing(descriptionTextView)
    }
    
    @objc private func performOnOptionalActionButtonPress() {
        if let delegate = delegate,
            let indexPath = indexPath {
            descriptionTextView.resignFirstResponder()
            delegate.didPressOptionalActionKeyboardButton(description: descriptionTextView.text, forCellAt: indexPath)
        }
    }
    
    private func calculateHeight(for text: String, withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = text
        label.font = font
        label.sizeToFit()
        return label.frame.height
    }
}

extension TextFieldView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if let delegate = delegate,
            let indexPath = indexPath {
            placeholderLabel.isHidden = !textView.text.isEmpty
            delegate.update(description: textView.text, forCellAt: indexPath)
//            if let pickerDetailComponents = pickerDetailComponents,
//                let pickerIndexPath = pickerIndexPath,
//                pickerDetailComponents.count > pickerIndexPath.row {
//                optionalLabel.text = pickerDetailComponents[pickerIndexPath.row].description
//                delegate.update(
//                    optionalDescription: pickerDetailComponents[pickerIndexPath.row].description,
//                    forCellAt: indexPath
//                )
//            }
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if let delegate = delegate,
            let indexPath = indexPath {
            delegate.shouldBeginEditing(description: textView.text, forCellAt: indexPath)
        }
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if let delegate = delegate,
            let indexPath = indexPath {
            delegate.didBeginEditing(description: textView.text, forCellAt: indexPath)
        }
        
        // Set initial value if needed
        if descriptionTextView.text == nil || descriptionTextView.text.isEmpty {
            if let datePicker = descriptionTextView.inputView as? UIDatePicker {
                let date = Date()
                datePicker.date = date
                if datePicker.datePickerMode == .date {
                    descriptionTextView.text = date.string(withFormat: dateFormat)
                } else if datePicker.datePickerMode == .time {
                    var dateComponents = Calendar.current.dateComponents(
                        [.day, .month, .year, .hour, .minute],
                        from: date
                    )
                    
                    if var hour = dateComponents.hour, var minute = dateComponents.minute {
                        let intervalRemainder = minute % datePicker.minuteInterval
                        if intervalRemainder > 0 {
                            minute += datePicker.minuteInterval - intervalRemainder
                            if minute >= 60 {
                                hour += 1
                                minute -= 60
                            }
                            // update date components
                            dateComponents.hour = hour
                            dateComponents.minute = minute
                            
                            if let roundedDate = Calendar.current.date(from: dateComponents) {
                                datePicker.date = roundedDate
                            }
                        }
                    }
                    
                    descriptionTextView.text = datePicker.date.stringOfTime()
                }
                textViewDidChange(descriptionTextView)
            } else if let pickerView = descriptionTextView.inputView as? UIPickerView {
//                if let pickerDetailComponents = pickerDetailComponents, !pickerDetailComponents.isEmpty {
//                    let index = pickerView.selectedRow(inComponent: 0)
//                    descriptionTextView.text = pickerDetailComponents[index].title
//                    textViewDidChange(descriptionTextView)
//                    if let indexPath = indexPath {
//                        optionalLabel.text = pickerDetailComponents[index].description
//                        delegate?.update(
//                            optionalDescription: pickerDetailComponents[index].description,
//                            forCellAt: indexPath
//                        )
//                    }
//                }
                guard pickerComponents?.isEmpty == false else {
                    return
                }
                let index = pickerView.selectedRow(inComponent: 0)
                descriptionTextView.text = pickerComponents?[index]
                textViewDidChange(descriptionTextView)
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let delegate = delegate,
            let indexPath = indexPath {
            delegate.didEndEditing(description: textView.text, forCellAt: indexPath)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Force editing to end on `Return` key press
        if text == "\n" {
            defer { endEditing(true) }
            return false
        }
        
        let updatedDescription = (textView.text as NSString).replacingCharacters(in: range, with: text)
        
        // Check on characters limit
        if let maximumCharactersCount = maximumCharactersCount,
            updatedDescription.count > maximumCharactersCount {
            return false
        }
        
        // Validate description if needed
        if let textValidator = textValidator {
            return textValidator.isValidCharacters(in: updatedDescription)
        }
        
        return true
    }
}

extension TextFieldView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if let count = pickerDetailComponents?.count { return count }
        return pickerComponents?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        if let pickerDetailComponents = pickerDetailComponents {
//            return pickerDetailComponents[row].title
//        }
        return pickerComponents?[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        guard pickerComponents?.isEmpty == false || pickerDetailComponents?.isEmpty == false else { return }
//        if let pickerDetailComponents = pickerDetailComponents {
//            descriptionTextView.text = pickerDetailComponents[row].title
//            pickerIndexPath = IndexPath(row: row, section: component)
//        } else {
//            descriptionTextView.text = pickerComponents?[row]
//        }
        textViewDidChange(descriptionTextView)
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
//        if let pickerDetailComponents = pickerDetailComponents, !pickerDetailComponents.isEmpty {
//            let description = pickerDetailComponents[component].description
//            let heightForText = calculateHeight(
//                for: description,
//                withConstrainedWidth: UIScreen.main.bounds.width - 32,
//                font: UIFont.systemFont(ofSize: 14)
//            )
//            return 16 + 2 + heightForText + 16 + 4
//        }
        return 40
    }
    
    func pickerView
        (
        _ pickerView: UIPickerView,
        viewForRow row: Int,
        forComponent component: Int,
        reusing view: UIView?
        ) -> UIView {
//        if let pickerDetailComponents = pickerDetailComponents {
//            let detailPickerView = DetailPickerView()
//            detailPickerView.detail = pickerDetailComponents[row]
//            return detailPickerView
//        } else if let pickerComponents = pickerComponents {
//            let defaultView = DefaultPickerView()
//            defaultView.title = pickerComponents[row]
//            return defaultView
//        }
        return UIView()
    }
}

