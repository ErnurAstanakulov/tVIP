//
//  TitledTextField.swift
//  DigitalBank
//
//  Created by Алем Утемисов on 06.05.2018.
//  Copyright © 2018 iosDeveloper. All rights reserved.
//

import UIKit

class TitledTextFieldView: UIView {
    
    let stackView = UIStackView()
    /// Fire this function on `valueTextField` edit
    var performOnEdit: ((_ text: String) -> Void)?
    /// Fire this function on `valueTextField` for each character update
    var performTextValidation: ((_ text: String) -> Bool)?
    
    var performOnBeginEditing: (() -> Void)?
    var performOnEndEditing: ((String) -> Void)?
    
    /// Description title label
    let titleLabel = UILabel()
    /// Field for value input
    let valueTextField = UITextField()
    /// Icon image view
    let iconImageView = UIImageView()
    
    /// Validation text label
    private let validationTextLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    var descriptionText: String? {
        set {
            descriptionLabel.text = newValue
            if let value = newValue, !value.isEmpty {
                if let index = stackView.arrangedSubviews.index(of: valueTextField),
                    !stackView.arrangedSubviews.contains(descriptionLabel) {
                    stackView.insertArrangedSubview(descriptionLabel, at: index + 1)
                }
            } else {
                stackView.removeArrangedSubview(descriptionLabel)
            }
        }
        get {
            return descriptionLabel.text
        }
    }
    
    var errorText: String? {
        set {
            validationTextLabel.text = newValue
            if let value = newValue, !value.isEmpty {
                if !stackView.arrangedSubviews.contains(validationTextLabel) {
                    stackView.addArrangedSubview(validationTextLabel)
                }
            } else {
                stackView.removeArrangedSubview(validationTextLabel)
            }
        }
        get {
            return validationTextLabel.text
        }
    }
    
    var canEdit: Bool {
        set {
            valueTextField.isUserInteractionEnabled = newValue
        }
        get {
            return valueTextField.isUserInteractionEnabled
        }
    }
    
    func setDescriptionLabelTextColor(textColor: UIColor) {
        descriptionLabel.textColor = textColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        setupStackView()
        addSubviews()
        setupConstraints()
        stylizeViews()
        extraTasks()
    }
    
    func setImageIcon(image: UIImage?) {
        iconImageView.image = image
        iconImageView.tintColor = UIColor.darkGray
    }
    
    /// Set placeholder text
    ///
    /// - Parameter text: placeholder text
    func setPlaceholder(_ text: String) {
        valueTextField.attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )
    }
    
    @objc func editingChanged(_ sender: UITextField) {
        if sender.keyboardType == .decimalPad {
            sender.text = sender.text?.replacingOccurrences(of: ",", with: ".")
        }
        sender.text = sender.text?.trim().splitedAmount()
        performOnEdit?(sender.text ?? "")
        if let selectedRange = sender.selectedTextRange {
            if let newPosition = sender.position(from: sender.endOfDocument, offset: -3) {
                let textRange:  UITextRange?
                if (sender.text ?? "").count > 4 && selectedRange.end != newPosition && selectedRange.end != sender.endOfDocument {
                    textRange = sender.textRange(from: selectedRange.start, to: selectedRange.start)
                } else {
                    textRange = sender.textRange(from: newPosition, to: newPosition)
                }
                sender.selectedTextRange = textRange
            }
        }
    }
    
    @objc func doneButtonPressed() {
        endEditing(true)
    }
    
    func setupStackView() {
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(valueTextField)
    }
    
    func addSubviews() {
        addSubview(stackView)
        addSubview(iconImageView)
    }
    
    func setupConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            iconImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -26),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 12),
            iconImageView.heightAnchor.constraint(equalToConstant: 12)
        ]
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 26),
            stackView.rightAnchor.constraint(equalTo: iconImageView.leftAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    func stylizeViews() {
        stackView.alignment = .fill
        stackView.spacing = 8
        
        iconImageView.contentMode = .scaleAspectFit
        
        titleLabel.textColor = AppColor.dark.uiColor
        titleLabel.font = AppFont.light.with(size: 14)
        titleLabel.numberOfLines = 0
        
        valueTextField.textColor = AppColor.green.uiColor
        valueTextField.font = AppFont.regular.with(size: 16)
        valueTextField.backgroundColor = .clear
        valueTextField.tintColor = AppColor.green.uiColor
        valueTextField.autocorrectionType = .no
        valueTextField.returnKeyType = .next
        valueTextField.autocapitalizationType = .none
        valueTextField.inputAccessoryView = UIToolbar.toolbarPiker(target: textField, action: #selector(doneButtonPressed))
        
        descriptionLabel.textColor = UIColor.darkGray
        descriptionLabel.font = AppFont.regular.with(size: 14)
        
        validationTextLabel.isUserInteractionEnabled = false
        validationTextLabel.textColor = UIColor.red
        validationTextLabel.font = AppFont.regular.with(size: 14)
        validationTextLabel.numberOfLines = 0
    }
    
    func extraTasks() {
        valueTextField.addTarget(nil, action: #selector(editingChanged(_:)), for: .editingChanged)
        valueTextField.delegate = self
    }
}

extension TitledTextFieldView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        performOnBeginEditing?()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let performTextValidation = performTextValidation,
            !performTextValidation(string) {
            return false
        }
        if textField.isFirstResponder {
            if textField.textInputMode?.primaryLanguage == nil || textField.textInputMode?.primaryLanguage == "emoji" {
                return false
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        performOnEndEditing?(textField.text ?? "")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

class TitledTextFieldWithButton: TitledTextFieldView {
    
    let valueTextView = UITextView()
    let rightButton: UIButton = UIButton(type: .system)
    var performOnButtonTap: (() -> Void)?
    
    var textViewHeightConstraint: NSLayoutConstraint?
    let minTextViewHeight: CGFloat = 24
    let maxTextViewHeight: CGFloat = 72
    
    var value: String? {
        didSet {
            setupTextFields()
        }
    }
    
    var isMultiLineEnabled: Bool = false {
        didSet {
            setupTextFields()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        rightButton.addTarget(nil, action: #selector(buttonTapped), for: .touchUpInside)
        setupTextFields()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func addSubviews() {
        super.addSubviews()
        addSubview(rightButton)
    }
    
    override func setupConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            rightButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -26),
            rightButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightButton.widthAnchor.constraint(equalToConstant: 65),
            rightButton.heightAnchor.constraint(equalToConstant: 24)
        ]
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 26),
            stackView.rightAnchor.constraint(equalTo: rightButton.leftAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    @objc private func buttonTapped() {
        performOnButtonTap?()
    }
    
    override func stylizeViews() {
        super.stylizeViews()
        
        
        rightButton.titleLabel?.font = AppFont.regular.with(size: 14)
        rightButton.tintColor = AppColor.green.uiColor
        rightButton.layer.cornerRadius = 12
        rightButton.layer.masksToBounds = true
        rightButton.layer.borderWidth = 1
        rightButton.layer.borderColor = AppColor.green.uiColor.cgColor
    }
    
    override func extraTasks() {
        super.extraTasks()
        valueTextView.delegate = self
    }
    
    override func setPlaceholder(_ text: String) {
        super.setPlaceholder(text)
        valueTextView.text = text
    }
    
    func setupTextFields() {
        if isMultiLineEnabled {
            stackView.removeArrangedSubview(valueTextField)
            stackView.addArrangedSubview(valueTextView)
        } else {
            stackView.removeArrangedSubview(valueTextView)
            stackView.addArrangedSubview(valueTextField)
        }
        valueTextView.text = isMultiLineEnabled ? value : nil
        valueTextField.text = !isMultiLineEnabled ? value : nil
    }
}

extension TitledTextFieldWithButton: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let performTextValidation = performTextValidation,
            !performTextValidation(text) {
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        performOnEdit?(textView.text ?? "")
    }
}

