//
//  ProfileInformationInteractor.swift
//  TransfersVIP
//
//  Created by psuser on 10/14/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

protocol ProfileInformationInteractorInput {
    func fillProfile()
    func updateProfile(with language: String?)
    func onPressChangeEmail(
        email: String,
        with password: String,
        viewController: UIViewController
    )
    func onPressChangeLanguage()
}

class ProfileInformationInteractor {
    
    private var presenter: ProfileInformationPresenterInput
    private var networkService: NetworkService
    private var personalDataFields = [FiledComponent<PersonalFields>]()
    private var selectedLanguage: String?
    
    init(presenter: ProfileInformationPresenterInput, networkService: NetworkService) {
        self.presenter = presenter
        self.networkService = networkService
    }
    
}
extension ProfileInformationInteractor: ProfileInformationInteractorInput {
  
    func fillProfile() {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        loadLanguages { [weak self] (locales) in
            dispatchGroup.leave()
            guard let interactor = self else { return }
            interactor.selectedLanguage = locales.ru
            interactor.presenter.fillLocales(locales)
        }
        
        dispatchGroup.enter()
        load { [weak self] (personal) in
            dispatchGroup.leave()
            guard let interactor = self,
                  let personal = personal
            else { return }
            interactor.setupComponents(personal)
        }
        
        
        dispatchGroup.notify(queue: .main) {
            self.presenter.setComponents(fields: self.personalDataFields)
        }
    }
    
    func updateProfile(with language: String?) {
        selectedLanguage = language
        self.presenter.setComponents(fields: self.personalDataFields)
    }
    
    private func setupComponents(_ personal: PersonalCodable) {
        let loginFieldComponent = FiledComponent<PersonalFields>(
            id: .login,
            fieldType: .label,
            title: "Логин",
            description: personal.login
        )
        personalDataFields.append(loginFieldComponent)
        
        let fullNameComponent = FiledComponent<PersonalFields>(
            id: .fullName,
            fieldType: .label,
            title: "ФИО",
            description: personal.fullName
        )
        personalDataFields.append(fullNameComponent)
        
        let positionComponent = FiledComponent<PersonalFields>(
            id: .position,
            fieldType: .label,
            title: "Должность",
            description: personal.position
        )
        personalDataFields.append(positionComponent)
        
        let phoneComponent = FiledComponent<PersonalFields>(
            id: .phone,
            fieldType: .label,
            title: "Телефон",
            description: personal.phone
        )
        personalDataFields.append(phoneComponent)
        
        let emailComponent = FiledComponent<PersonalFields>(
            id: .email,
            fieldType: .button,
            title: "Email",
            description: personal.email
        )
        personalDataFields.append(emailComponent)
        
        let languageComponent = FiledComponent<PersonalFields>(
            id: .language,
            fieldType: .alert,
            title: "Язык приложения",
            description: selectedLanguage
        )
        personalDataFields.append(languageComponent)
    }
    
    func onPressChangeEmail(
        email: String,
        with password: String,
        viewController: UIViewController
    ) {
        let networkContext = LoadPersonalUpdateNetworkContext(email: email, password: password)
        networkService.load(context: networkContext) { [weak self] (networkResponse) in
            guard let interactor = self else { return }
            guard networkResponse.isSuccess else {
                interactor.presenter.showError(error: networkResponse.networkError ?? .unknown)
                return
            }
            interactor.presenter.uploadProfile(viewController)
        }
    }
    
    func onPressChangeLanguage() {
        
    }
}

extension ProfileInformationInteractor {
    
    private func load(completion: @escaping (PersonalCodable?) -> ()) {
        let networkContext = LoadProfileNetworkContext()
        presenter.startLoading()
        networkService.load(context: networkContext) { [weak self] response in
            guard let interactor = self else { return }
            interactor.presenter.stopLoading()
            guard response.isSuccess else {
                interactor.presenter.showError(error: response.networkError ?? .unknown)
                return
            }
            
            guard let personal: PersonalCodable = response.decode()
                else {
                    interactor.presenter.showError(error: NetworkError.dataLoad)
                    return
            }
            completion(personal)
        }
    }
    
    private func loadLanguages(completion: @escaping (Locales) -> ()) {
        let networkContext = LoadProfileTranslateLocales()
        presenter.startLoading()
        networkService.load(context: networkContext) { [weak self] (response) in
            guard let interactor = self else { return }
            interactor.presenter.stopLoading()
            guard response.isSuccess else {
                interactor.presenter.showError(error: response.networkError ?? .unknown)
                return
            }
            
            guard let languages: Locales = response.decode()
                else {
                    interactor.presenter.showError(error: NetworkError.dataLoad)
                    return
            }
            completion(languages)
        }
    }
}
