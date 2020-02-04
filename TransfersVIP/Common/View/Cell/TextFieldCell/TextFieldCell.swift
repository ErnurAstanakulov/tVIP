//
//  TextFieldCell.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/3/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

/// Table view cell class that contains title with mandatory and optional descriptions;
class TextFieldCell: UITableViewCell, ReusableView {
    
    private let view = TextFieldView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(view)
        setViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setViewConstraints() {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        view.prepareForReuse()
        accessoryType = .none
    }
}

extension TextFieldCell {
    
    var delegate: TextFieldViewCellDelegate? {
        get { return view.delegate }
        set { view.delegate = newValue }
    }
    
    var indexPath: IndexPath? {
        get { return view.indexPath }
        set { view.indexPath = newValue }
    }
    
    var title: String? {
        get { return view.titleLabel.text }
        set { view.titleLabel.text = newValue }
    }
    
    @available(*, unavailable, message:"Variable is unavailable")
    override var description: String { return super.description }
    
    func set(description: String?) {
        view.placeholderLabel.isHidden = description?.isEmpty == false
        view.descriptionTextView.text = description
    }
    
    var placeholder: String? {
        get { return view.placeholderLabel.text }
        set { view.placeholderLabel.text = newValue }
    }
    
    var maximumCharactersCount: Int? {
        get { return view.maximumCharactersCount }
        set { view.maximumCharactersCount = newValue }
    }
    
    var isEditable: Bool {
        get { return view.isUserInteractionEnabled }
        set { view.isUserInteractionEnabled = newValue }
    }
    
    var canPaste: Bool {
        get { return view.descriptionTextView.canPaste }
        set { view.descriptionTextView.canPaste = newValue }
    }
    
    var dateFormat: DateFormat {
        get { return view.dateFormat }
        set { view.dateFormat = newValue }
    }
    
    var datePickerMode: UIDatePicker.Mode {
        get { return view.datePickerMode }
        set { view.datePickerMode = newValue }
    }
    
    var minimumDate: Date? {
        get { return view.minimumDate }
        set { view.minimumDate = newValue }
    }
    
    var maximumDate: Date? {
        get { return view.maximumDate }
        set { view.maximumDate = newValue }
    }
    
    var minuteInterval: Int {
        get { return view.minuteInterval }
        set { view.minuteInterval = newValue }
    }
    
    func setOptional(description: String?, asWarning: Bool = false) {
        view.optionalLabel.text = description
//        view.optionalLabel.textColor = (asWarning ? AppColor.errorColor : .technolygedBlackGray).uiColor
        
        if let description = description, !description.isEmpty {
            if !view.stackView.arrangedSubviews.contains(view.optionalLabel) {
                view.stackView.addArrangedSubview(view.optionalLabel)
            }
        } else {
            view.stackView.removeArrangedSubview(view.optionalLabel)
        }
    }
    
    func set(inputType: TextFieldCellInputType) {
        view.set(inputType: inputType)
    }
    
    func set(textValidator: TextValidator) {
        view.textValidator = textValidator
    }
    
    func resize(by factor: CGFloat) {
        
        let initialTitleLabelFontSize = view.titleLabel.font.pointSize
        view.titleLabel.font = view.titleLabel.font.withSize(factor * initialTitleLabelFontSize)
        
        if let initialDescriptionTextViewFontSize = view.descriptionTextView.font?.pointSize {
            view.descriptionTextView.font = view.descriptionTextView.font?.withSize(
                factor * initialDescriptionTextViewFontSize
            )
        }
        
        let initialPlaceholderLabelFontSize = view.placeholderLabel.font.pointSize
        view.placeholderLabel.font = view.placeholderLabel.font.withSize(factor * initialPlaceholderLabelFontSize)
        
        let initialOptionalLabelFontSize = view.optionalLabel.font.pointSize
        view.optionalLabel.font = view.optionalLabel.font.withSize(factor * initialOptionalLabelFontSize)
    }
    
    func set(autocapitalizationType: UITextAutocapitalizationType) {
        view.descriptionTextView.autocapitalizationType = autocapitalizationType
    }
    
    func set(optionalActionButtonTitle: String?) {
        if let toolbar = view.descriptionTextView.inputAccessoryView as? UIToolbar {
            toolbar.set(optionalActionButtonTitle: optionalActionButtonTitle)
        }
    }
    
    func startEditing() {
        view.startEditing()
    }
}
