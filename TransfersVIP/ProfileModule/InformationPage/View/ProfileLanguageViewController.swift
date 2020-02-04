//
//  ProfileLanguageViewController.swift
//  TransfersVIP
//
//  Created by psuser on 10/16/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

class ProfileLanguageViewController: CodeBasedAuthFactorViewController {
    
    weak var delegate: ProfileLanguageChangeDelegate?
    private let languageView: ProfileLanguageView
    
    init(_ languages: [String?]) {
        languageView = ProfileLanguageView(frame: .zero, languages: languages)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setContainerSubview(languageView)
        setupConstraints()
        setDelegate(self)
    }
    
    override func setupConstraints() {
        containerView.addConstaintsToHorizontal()
        containerView.heightAnchor.constraint(equalToConstant: languageView.height)
        
        containerViewCenterYAnchorConstraint = containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: languageView.height)
        containerViewCenterYAnchorConstraint?.isActive = true
    }
}

extension ProfileLanguageViewController: LanguageButtonDelegate {
    
    func onPressCancel() {
        dismissViewController()
    }
    
    func onPressLanguageButton(_ sender: UIButton) {
        dismissViewController()
        delegate?.onPressLanguageButton(self)
    }
    
    func setDelegate(_ delegate: LanguageButtonDelegate) {
        languageView.delegate = delegate
    }
}

extension ProfileLanguageViewController {
    var languages: String? {
        return languageView.languages
    }
}
