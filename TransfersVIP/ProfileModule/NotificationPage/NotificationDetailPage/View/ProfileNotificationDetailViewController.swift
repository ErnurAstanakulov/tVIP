//
//  ProfileNotificationDetailViewController.swift
//  TransfersVIP
//
//  Created by psuser on 10/19/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import UIKit

protocol ProfileNotificationDetailViewInput: BaseViewInputProtocol {
    func setupComponents(_ components: [HeaderComponent<Int, Constants.NotificationSettingsType>])
    func showController(with items: [NotificationItem], by items: Constants.NotificationSettingsType)
    func routeBack()
}


class ProfileNotificationDetailViewController: BaseViewController {
    
    var tableView = UITableView()
    var topBar = ProfileNotificationsTableTopBar()
    
    var interactor: ProfileNotificationDetailInteractorInput?
    var router: ProfileNotificationDetailRouterInput?
    private var components: [HeaderComponent<Int, Constants.NotificationSettingsType>] = []
    private lazy var selectionController: SelectionModalController? = {
        let controller = UINib.controller(controller: SelectionModalController.self)
        controller?.modalPresentationStyle = .overCurrentContext
        controller?.modalTransitionStyle = .crossDissolve
        controller?.allHeaderVisible = true
        return controller
    }()
    
    override func loadView() {
        super.loadView()
        setupNavigationBar()
        setupViews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.title, "vmdklfvmdf")
        interactor?.loadProperties()
    }
    
    func setupNavigationBar() {
        view.addSubview(topBar)
        topBar.backButtonAction = { [unowned self] in
            self.interactor?.saveChanges()
        }
    }
}
extension ProfileNotificationDetailViewController: ProfileNotificationDetailViewInput {
    func setupComponents(_ components: [HeaderComponent<Int, Constants.NotificationSettingsType>]) {
        self.components = components
        topBar.headerTitleLabel.text = components[0].title
        topBar.titleLabel.text = components[0].description
        tableView.reloadData()
    }
    
    func showController(with items: [NotificationItem], by type: Constants.NotificationSettingsType) {
        selectionController?.models = items
        selectionController?.didFinishPresentationBlock = { [unowned self] (button, channels) in
            guard let changed = channels as? [NotificationItem] else { return }
            self.interactor?.updateProperties(with: changed, by: type, isAllSelected: self.isAllSelected(models: changed))
        }
        present(selectionController!, animated: true, completion: nil)
    }
    
    public func isAllSelected(models: [NotificationItem]?) -> Bool {
        guard let models = models, !models.isEmpty else { return false }
        let states: [Bool] = models.compactMap ({ $0.isChecked })
        let allSelected = states.reduce(true, {$0 && $1})
        return allSelected
    }
    
    func routeBack() {
        router?.popModule()
    }
}

extension ProfileNotificationDetailViewController: ViewInitalizationProtocol {
    func addSubviews() {
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        topBar.addConstaintsToHorizontal()
        topBar.topAnchor.constraint(equalTo: view.topAnchor, constant: statusBarHeight).isActive = true
        topBar.heightAnchor.constraint(equalToConstant: 100).isActive = true

        tableView.addConstaintsToHorizontal()
        tableView.topAnchor.constraint(equalTo: topBar.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func stylizeViews() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
    }
    
    func extraTasks() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ButtonFieldCell.self)
        tableView.register(TextFieldCell.self)
    }
}
extension ProfileNotificationDetailViewController: EditButtonDelegate {
    func onPressButton(_ sender: UIButton) {
        dump(sender.imageView?.image)
        let typeId = components[0].fieldComponentList[sender.tag].id
        interactor?.loadSettingsComponent(by: typeId)
    }
}

extension ProfileNotificationDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return components.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return components[section].fieldComponentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let component = components[indexPath.section].fieldComponentList[indexPath.row]
        switch component.fieldType {
        case .button:
            let cell: ButtonFieldCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.title = component.title
            cell.set(description: component.description)
            cell.setDelegate(self)
            cell.setButtonTag(indexPath.row)
            return cell
        case .label:
            let cell: TextFieldCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.title = component.title
            cell.set(description: component.description)
            cell.isEditable = false
            return cell
        default:
            fatalError("fieldType not set")
        }
    }
}
