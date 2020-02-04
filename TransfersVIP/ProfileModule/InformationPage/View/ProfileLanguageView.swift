//
//  ProfileLanguageView.swift
//  TransfersVIP
//
//  Created by psuser on 10/16/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import UIKit

class ProfileLanguageView: UIView {
    
    private var stackView = UIStackView()
    private var containerView = UIView()
    private var titleLabel = UILabel()
    var cancelButton = UIButton(type: .system)
    var buttons = [UIButton]()
    var delegate: LanguageButtonDelegate?
    var index:Int = 0
    
    convenience init(frame: CGRect, languages: [String?]) {
        self.init(frame: frame)
        buttons = languages.map({ (title) -> UIButton in
            let button = UIButton(type: .custom)
            button.setTitle(title, for: .normal)
            return button
        })
        setupViews()
    }
    
    var languages: String? {
        return buttons[index].currentTitle
    }
    
    var height: CGFloat {
        dump(containerView.frame.height)
        let stackViewHeight:CGFloat = CGFloat(40 * stackView.arrangedSubviews.count)
        let h: CGFloat = 30 + 25 + 16 + stackViewHeight + 40
        dump(h)
        print("oisdvovvf")
        return h
    }
    
    @objc func onPressLanguageButton(_ sender: UIButton) {
        index = sender.tag
        delegate?.onPressLanguageButton(sender)
    }
    
    @objc func onPressCancel() {
        delegate?.onPressCancel()
    }
}

extension ProfileLanguageView: ViewInitalizationProtocol {
    func addSubviews() {
        addSubview(containerView)
        containerView.addSubview(stackView)
        buttons.forEach { stackView.addArrangedSubview($0) }
        containerView.addSubview(titleLabel)
        containerView.addSubview(cancelButton)
    }
    
    func setupConstraints() {
        containerView.addConstaintsToFill()
        titleLabel.addConstaintsToHorizontal(padding: 18)
        
        var layoutConstraints: [NSLayoutConstraint] = []
        
        layoutConstraints += [
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 28),
            titleLabel.heightAnchor.constraint(equalToConstant: 25)
        ]
        
        stackView.addConstaintsToHorizontal()
        layoutConstraints += [
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16)
        ]
        
        print("---")
        dump(buttons.count)
        buttons.forEach { (element) in
            element.addConstaintsToHorizontal()
        }
        
        cancelButton.addConstaintsToHorizontal()
        layoutConstraints += [
            cancelButton.heightAnchor.constraint(equalToConstant: 40),
            cancelButton.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30)
        ]
        
        
        translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            heightAnchor.constraint(equalToConstant: height)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    func stylizeViews() {
        buttons.forEach { (element) in
            element.titleLabel?.font = AppFont.light.with(size: 16)
            element.setTitleColor(AppColor.green.uiColor, for: .normal)
            element.setTitleColor(AppColor.white.uiColor, for: .selected)
            element.backgroundColor = !element.isSelected ? AppColor.white.uiColor : AppColor.green.uiColor
        }
        
        backgroundColor = .white
        
        titleLabel.text = "Хотите сменить язык?"
        titleLabel.font = AppFont.semibold.with(size: 18)
        titleLabel.textColor = AppColor.gray.uiColor
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        
        cancelButton.setTitle("Отмена", for: .normal)
        cancelButton.setTitleColor(AppColor.gray.uiColor, for: .normal)
        cancelButton.backgroundColor = .white
    }
    
    func extraTasks() {
        buttons.enumerated().forEach { (button) in
            button.element.tag = button.offset
            button.element.addTarget(self, action: #selector(onPressLanguageButton), for: .touchUpInside)
        }
        cancelButton.addTarget(self, action: #selector(onPressCancel), for: .touchUpInside)
    }
}
