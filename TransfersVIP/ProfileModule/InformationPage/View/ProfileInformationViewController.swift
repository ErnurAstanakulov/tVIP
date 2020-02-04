//
//  ProfileInformationViewController.swift
//  TransfersVIP
//
//  Created by psuser on 10/11/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import UIKit

protocol ProfileInformationViewInput: BaseViewControllerProtocol {
    func setComponents(fields: [FiledComponent<PersonalFields>])
    func uploadProfile(_ viewController: UIViewController)
    func fillLocales(_ locales: Locales)
}

class ProfileInformationViewController: UIViewController, ProfilePagesProtocol {
    
    var page: ProfilePages
    var interactor: ProfileInformationInteractorInput!
    var router: ProfileInformationRouterInput!
    
    private var personalDataFields = [FiledComponent<PersonalFields>]()
    private var languages: [String?] = []
    private var tableView = UITableView()
    
    override func loadView() {
        super.loadView()
        setupViews()
    }
    
    init(page: ProfilePages) {
        self.page = page
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.fillProfile()
    }
    
    private func showChangeEmailViewController() {
        let viewController = ProfileChangeEmailViewController()
        viewController.delegate = self
        let field = personalDataFields.first(where: { $0.id == .email })
        viewController.currentEmail = field?.description
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .custom
        present(viewController, animated: true)
    }
    
    private func showLanguageChangeViewController() {
        let viewController = ProfileLanguageViewController(languages)
        viewController.delegate = self
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .custom
        present(viewController, animated: true)
    }

}
extension ProfileInformationViewController: ProfileChangeEmailDelegate {
    func onPressSaveButton(_ viewController: ProfileChangeEmailViewController) {
        guard let email = viewController.newEmail,
              let password = viewController.password else {
            showError(message: "Введите данные", completion: nil)
            return
        }
        interactor.onPressChangeEmail(email: email, with: password, viewController: viewController)
    }
}
extension ProfileInformationViewController: ProfileLanguageChangeDelegate {
    func onPressLanguageButton(_ viewController: ProfileLanguageViewController) {
        interactor.updateProfile(with: viewController.languages)
    }
}

extension ProfileInformationViewController: EditButtonDelegate {
    func onPressButton(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            showChangeEmailViewController()
        case 1:
            showLanguageChangeViewController()
        default:
            fatalError("componentNotInitialized")
        }
    }
}

extension ProfileInformationViewController: ProfileInformationViewInput {
    var activityIndicator: UIActivityIndicatorView {
        return .init(style: .gray)
    }
    
    func setComponents(fields: [FiledComponent<PersonalFields>]) {
        personalDataFields = fields
        tableView.reloadData()
    }
    
    func uploadProfile(_ viewController: UIViewController) {
        personalDataFields.removeAll()
        interactor.fillProfile()
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func fillLocales(_ locales: Locales) {
        let properties = Mirror(reflecting: locales)
        let array = Array(properties.children)
        self.languages = array.compactMap({ locale -> String? in
            return locale.value is String ? locale.value as? String : nil
        })
    }
}
extension ProfileInformationViewController: ViewInitalizationProtocol {
    func addSubviews() {
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView.addConstaintsToFill()
    }
    
    func stylizeViews() {

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 58
    }
    
    
    func extraTasks() {
        tableView.register(TextFieldCell.self)
        tableView.register(ButtonFieldCell.self)
    }
    
}
extension ProfileInformationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personalDataFields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let component = personalDataFields[indexPath.row]
        switch component.fieldType {
        case .label:
            let cell: TextFieldCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.title = component.title
            cell.set(description: component.description)
            cell.isEditable = false
            return cell
        case .button:
            let cell: ButtonFieldCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.title = component.title
            cell.set(description: component.description)
            cell.setDelegate(self)
            cell.setButtonTag(0)
            return cell
        case .alert:
            let cell: ButtonFieldCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.title = component.title
            cell.setDelegate(self)
            cell.setButtonTag(1)
            cell.set(description: component.description)
            return cell
        default:
            fatalError("fieldType not set")
        }
    }
    
    
}
