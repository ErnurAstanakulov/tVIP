//
//  OptionsViewController.swift
//  DigitalBank
//
//  Created by Алем Утемисов on 06.05.2018.
//  Copyright © 2018 iosDeveloper. All rights reserved.
//

import UIKit
import RxSwift

class OptionsViewController: UIViewController {
    
    typealias DataSourceCallback = ([OptionDataSource]) -> Void
    private let tableView: UITableView = UITableView()
    private let topShadowView = UIView()
    private let bottomShadowView = UIView()
    private let navBar = UIView()
    private let disposeBag = DisposeBag()
    let titledTextFieldView: TitledTextFieldWithButton = TitledTextFieldWithButton()
    
    fileprivate var text: String = "" {
        didSet {
            tableView.reloadData()
        }
    }
    var dataSource: [OptionDataSource] = [] {
        didSet {
            if isViewLoaded {
                tableView.reloadData()
            }
        }
    }
    fileprivate var filteredDataSource: [OptionDataSource] {
        guard !text.isEmpty else { return dataSource }
        return dataSource.filter { $0.title.uppercased().contains(text.uppercased()) || ($0.description ?? "").uppercased().contains(text.uppercased()) }
    }
    
    fileprivate(set) var onOptionSelectCallback: ((OptionDataSource?) -> Void)? = nil
    fileprivate(set) var onTextEnterCallback: ((String?) -> Void)? = nil
    
    var onSearchCallback: ((String?, DataSourceCallback?) -> Void)? = nil
    var textFieldValidation: ((_ text: String) -> Bool)?
    
    var selectedOption: OptionDataSource?
    fileprivate(set) var enteredText: String?
    
    init(dataSource: [OptionDataSource] = [], textFieldTitle: String?, textFieldDescription: String?, textFieldValue: String? = nil, editable: Bool = true, onOptionSelectCallback: ((OptionDataSource?) -> Void)? = nil, onTextEnterCallback: ((String?) -> Void)? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.dataSource = dataSource
        self.onOptionSelectCallback = onOptionSelectCallback
        self.onTextEnterCallback = onTextEnterCallback
        self.titledTextFieldView.canEdit = editable
        self.titledTextFieldView.titleLabel.text = textFieldTitle
        self.titledTextFieldView.value = textFieldValue
        self.enteredText = textFieldValue
        if let placeholder = textFieldDescription {
            self.titledTextFieldView.setPlaceholder(placeholder)
        }
        self.titledTextFieldView.rightButton.setTitle("Далее", for: .normal)
        self.titledTextFieldView.performOnButtonTap = {[unowned self] in
            self.onTextEnterCallback?(self.enteredText)
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(titledTextFieldView)
        view.addSubview(tableView)
        view.addSubview(topShadowView)
        view.addSubview(bottomShadowView)
        setupNavigationBar(title: "Выбор")
        setupTableView()
        setupConstraints()
        setupTextField()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.titledTextFieldView.canEdit {
            if self.titledTextFieldView.isMultiLineEnabled {
                self.titledTextFieldView.valueTextView.becomeFirstResponder()
            } else {
                self.titledTextFieldView.valueTextField.becomeFirstResponder()
            }
        }
        observerOnUserInputDidChange()
    }
    
    func setupTextField() {
        
    }
    
    func setupNavigationBar(title: String?) {
        view.addSubview(navBar)
//        navBar.backButtonAction = {[unowned self] _ in
//            self.onTextEnterCallback?(self.enteredText)
//            self.navigationController?.popViewController(animated: false)
//        }
     }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
        tableView.separatorColor = AppColor.lineColor.uiColor
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 58.0
        tableView.keyboardDismissMode = .onDrag
        tableView.register(StaticContentCell.self, forCellReuseIdentifier: StaticContentCell.reuseIdentifier)
        
        topShadowView.isUserInteractionEnabled = false
 
        bottomShadowView.isUserInteractionEnabled = false
     }
    
    private func setupConstraints() {
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        navBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        navBar.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor).isActive = true
        navBar.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        titledTextFieldView.translatesAutoresizingMaskIntoConstraints = false
        titledTextFieldView.topAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
        titledTextFieldView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        titledTextFieldView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        topShadowView.translatesAutoresizingMaskIntoConstraints = false
        topShadowView.topAnchor.constraint(equalTo: titledTextFieldView.bottomAnchor).isActive = true
        topShadowView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        topShadowView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        topShadowView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: topShadowView.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        
        bottomShadowView.translatesAutoresizingMaskIntoConstraints = false
        bottomShadowView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bottomShadowView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bottomShadowView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        bottomShadowView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
    }
    
    private func observerOnUserInputDidChange() {
        let textView = self.titledTextFieldView.valueTextView
        let minHeight = self.titledTextFieldView.minTextViewHeight
        let maxHeight = self.titledTextFieldView.maxTextViewHeight
        
        textView.rx.text.asDriver()
            .drive(onNext: { [weak self] (string) in
                guard let strongSelf = self else { return }
                let originalWidth = textView.frame.width
                let originalHeight = textView.frame.height
                let fitsHeight = textView.sizeThatFits(CGSize(width: originalWidth, height: CGFloat.greatestFiniteMagnitude)).height
                let firstNewHeight = max(fitsHeight, minHeight)
                let newHeight = min(firstNewHeight, maxHeight)
                
                if newHeight != originalHeight {
                    strongSelf.titledTextFieldView.textViewHeightConstraint?.constant = newHeight
                    strongSelf.view.setNeedsLayout()
                    strongSelf.view.layoutIfNeeded()
                }
                
                textView.isScrollEnabled = newHeight < maxHeight ? false : true
            })
            .disposed(by: disposeBag)
    }
    
}

extension OptionsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = filteredDataSource[indexPath.row]
        titledTextFieldView.valueTextField.text = selectedOption?.title
        self.onOptionSelectCallback?(option)
        navigationController?.popViewController(animated: false)
    }
    
}

extension OptionsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StaticContentCell.reuseIdentifier, for: indexPath) as? StaticContentCell ?? StaticContentCell()
        let option = filteredDataSource[indexPath.row]
        cell.staticContentView.title = option.title
        cell.staticContentView.value = option.description
        cell.staticContentView.titleLabel.textColor = option.color
        cell.staticContentView.valueLabel.textColor = option.color
        if option == selectedOption {
            cell.staticContentView.iconImageView.image = #imageLiteral(resourceName: "checkedTransparent")
        }
        cell.staticContentView.titleLabel.numberOfLines = titledTextFieldView.isMultiLineEnabled ? 0 : 1
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredDataSource.count
    }
}

class OptionDataSource: Equatable {
    
    let id: String
    let title: String
    let description: String?
    let color: UIColor?
    
    init(id: String, title: String, description: String? = nil, color: UIColor? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.color = color
    }
    
    init?(id: String?, title: String?, description: String? = nil, color: UIColor? = nil) {
        guard let id = id, let title = title else { return nil }
        self.id = id
        self.title = title
        self.description = description
        self.color = color
    }
    
    static func == (lhs: OptionDataSource, rhs: OptionDataSource) -> Bool {
        return lhs.id == rhs.id && lhs.title == rhs.title && rhs.description == lhs.description
    }
    
}
