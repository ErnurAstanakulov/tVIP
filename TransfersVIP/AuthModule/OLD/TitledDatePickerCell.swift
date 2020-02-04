//
//  TitledDatePickerCell.swift
//  DigitalBank
//
//  Created by Zhalgas Baibatyr on 21.05.2018.
//  Copyright © 2018 Infin-It Solutions. All rights reserved.
//

class TitledDatePickerCell: UITableViewCell {
    
    let titledDatePickerView = TitledDatePickerView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubview(titledDatePickerView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        titledDatePickerView.addConstaintsToFill()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titledDatePickerView.canEdit = true
        titledDatePickerView.iconImageView.image = nil
        titledDatePickerView.titleLabel.text = nil
        titledDatePickerView.valueTextField.text = nil
        titledDatePickerView.validationTextLabel.text = nil
        titledDatePickerView.performOnEdit = nil
        titledDatePickerView.performOnEndEditing = nil
        titledDatePickerView.performOnBeginEditing = nil
        titledDatePickerView.performTextValidation = nil
        titledDatePickerView.useMonthAndYearDateFormat = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
//
//  TitledDatePickerView.swift
//  DigitalBank
//
//  Created by Zhalgas Baibatyr on 21.05.2018.
//  Copyright © 2018 Infin-It Solutions. All rights reserved.
//

class TitledDatePickerView: UIView {
    var performOnEdit: ((_ text: String) -> Void)?
    var performTextValidation: ((_ text: String) -> Bool)?
    var performOnBeginEditing: (() -> Void)?
    var performOnEndEditing: ((String) -> Void)?
    
    var stackView = UIStackView()
    var titleLabel = UILabel()
    var valueTextField = UITextField()
    var iconImageView = UIImageView()
    var validationTextLabel = UILabel()
    var datePicker = UIDatePicker()
    
    var validationText: String? {
        get {
            return validationTextLabel.text
        }
        
        set {
            validationTextLabel.text = newValue
            if let text = newValue, text.isEmpty {
                stackView.addArrangedSubview(validationTextLabel)
            } else {
                stackView.removeArrangedSubview(validationTextLabel)
            }
        }
    }
    
    var useMonthAndYearDateFormat = false
    
    var canEdit: Bool {
        set {
            valueTextField.isUserInteractionEnabled = newValue
        }
        get {
            return valueTextField.isUserInteractionEnabled
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        stylize()
        setupConstraints()
        toolbarActivate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        addSubview(stackView)
        addSubview(iconImageView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(valueTextField)
        
        //        addSubview(titleLabel)
        //        addSubview(valueTextField)
        //        addSubview(iconImageView)
    }
    
    /// Customized update of constraints for the view
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
    
    /// Set custom style
    func stylize() {
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        
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
        valueTextField.inputAccessoryView = nil
        
        validationTextLabel.isUserInteractionEnabled = false
        validationTextLabel.textColor = UIColor.red
        validationTextLabel.font = AppFont.regular.with(size: 14)
        
        datePicker.date = Date()
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.datePickerMode = .date
        datePicker.tintColor = AppColor.dark.uiColor
        valueTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(datePickerValueDidChange(_:)), for: .valueChanged)
    }
    
    func setImageIcon(image: UIImage?) {
        iconImageView.image = image?.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = AppColor.dark.uiColor
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
    
    func toolbarActivate() {
        let toolbar = UIToolbar.toolbarPiker(target: valueTextField, action: #selector(resignFirstResponder))
        let cancelButton = UIBarButtonItem(title: "Отменить", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelAction))
        cancelButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.untTextStyle5Font()!], for: .normal)
        cancelButton.tintColor = UIColor.untGreyishBrownTwo
        
        toolbar.setItems([cancelButton] + (toolbar.items ?? []), animated: true)
        
        valueTextField.delegate = self
        valueTextField.inputAccessoryView = toolbar
    }
    
    
    @objc fileprivate func datePickerValueDidChange(_ sender: UIDatePicker) {
        let dateString = sender.date.stringWith(format: Constants.DateFormats.shortDot)
        valueTextField.text = useMonthAndYearDateFormat ? String(dateString.dropFirst(3)) : dateString
    }
    
    @objc func cancelAction() {
        valueTextField.text = nil
        valueTextField.resignFirstResponder()
    }
    
}

extension TitledDatePickerView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        datePickerValueDidChange(datePicker)
        performOnBeginEditing?()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            
            if let performTextValidation = performTextValidation,
                !performTextValidation(updatedText) {
                return false
            }
            
            performOnEdit?(updatedText)
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
