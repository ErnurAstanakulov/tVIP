//
//  ProfileNotificationDetailInteractor.swift
//  TransfersVIP
//
//  Created by psuser on 10/19/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation
import Alamofire

protocol ProfileNotificationDetailInteractorInput {
    func loadProperties()
    func loadSettingsComponent(by type: Constants.NotificationSettingsType)
    func updateProperties (
        with items: [NotificationItem],
        by type: Constants.NotificationSettingsType,
        isAllSelected: Bool
    )
    func saveChanges()
}

class ProfileNotificationDetailInteractor {
    
    let networkService: NetworkService
    let presenter: ProfileNotificationDetailPresenterInput
    let selectionId: Int
    private var components = [HeaderComponent<Int, Constants.NotificationSettingsType>]()
    private var property: NotificationProperty!
    private var isChanged:Bool = false

    init(channelId: Int, networkService: NetworkService, presenter: ProfileNotificationDetailPresenterInput) {
        self.selectionId = channelId
        self.networkService = networkService
        self.presenter = presenter
    }
}
extension ProfileNotificationDetailInteractor: ProfileNotificationDetailInteractorInput {
 
    func updateProperties
    (
        with items: [NotificationItem],
        by type: Constants.NotificationSettingsType,
        isAllSelected: Bool
    ) {
        isChanged = true
        switch type {
        case .accounts:
            property.accounts = items
            property.isAllAccounts = isAllSelected
        case .channels:
            property.channels = items
            property.isAllChannels = isAllSelected
        case .statuses:
            property.statuses = items
            property.isAllStatuses = isAllSelected
        case .documentTypes:
            property.documentTypes = items
            property.isAllDocumentTypes = isAllSelected
        default:
            fatalError("fr")
        }
        
        setupComponents(property)
    }
    
    func saveChanges() {
        if !isChanged { presenter.routeBack() } else { save(property: property, with: selectionId) }
    }
    
    private func save(property: NotificationProperty, with id: Int) {
        let networkContext = LoadProfileNotificationPropertyNetworkContext(id: id, property)
        presenter.startLoading()
        networkService.load(context: networkContext) { [weak self] (networkResponse) in
            guard let self = self else {
                return
            }
            self.presenter.stopLoading()
            
            guard networkResponse.isSuccess else {
                self.presenter.showError(error: networkResponse.networkError ?? .unknown)
                return
            }
            self.presenter.showSuccess(message: "Изменения успешно сохранены!", completion: {
                self.presenter.routeBack()
            })
        }
    }
    
    func loadSettingsComponent(by type: Constants.NotificationSettingsType) {
        switch type {
        case .accounts:
            presenter.showController(with: property.accounts!, by: type)
        case .channels:
            presenter.showController(with: property.channels!, by: type)
        case .documentTypes:
            presenter.showController(with: property.documentTypes!, by: type)
        case .statuses:
            presenter.showController(with: property.documentTypes!, by: type)
        default:
            fatalError("fr")
        }
    }
    
    func loadProperties() {
        presenter.startLoading()
        load(with: selectionId) { [weak self] (result) in
            guard let interactor = self else { return }
            interactor.presenter.stopLoading()
            switch result {
            case .success(let value):
                interactor.setupComponents(value)
            case .failure(let error):
                interactor.presenter.showError(error: error as! AppError, completion: nil)
            }
        }
    }
    
    private func setupComponents(_ property: NotificationProperty) {
        self.property = property
        
        components = [
            HeaderComponent(
                id: 0,
                title: "Настройки оповещений",
                description: property.description
            )
        ]
        for field in (property.fields ?? []) {
            if let settingType = Constants.NotificationSettingsType(rawValue: field) {
                let fieldComponent = FiledComponent<Constants.NotificationSettingsType>(
                    id: settingType,
                    fieldType: .button, // : .label,
                    title: settingType.title,
                    description: getDescription(for: property, by: settingType)
                )
                components[0].fieldComponentList.append(fieldComponent)
            }
        }
        presenter.setupComponents(components)
        print("components")
        dump(components)
    }
    
    private func getDescription(for component: NotificationProperty, by type: Constants.NotificationSettingsType) -> String? {
        guard let property = type.description(for: component) else {
            switch type {
            case .certificate:
                return component.notificationPeriod.map{ String($0) }
            case .amount:
                return component.amount.map({ String(format: "%.2f", $0) })
            case .days:
                return component.notificationPeriod.map { String($0) }
            default: return nil
            }
        }
        return property.map{ $0.label ?? "" }.joined(separator: ", ")
    }
    
    private func load(with id: Int, onCompletion pass: @escaping (_ result: Result<NotificationProperty>) -> Void) {
        let networkContext = LoadProfileNotificationPropertyNetworkContext(id: id)
        presenter.startLoading()
        networkService.load(context: networkContext) { (networkResponse) in
            guard let properties: NotificationProperty = networkResponse.decode() else { return }
            guard networkResponse.isSuccess else {
                pass(.failure(NetworkError.dataLoad))
                return
            }
            pass(.success(properties))
        }
    }
}
