//
//  LoginPageViewController.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/10/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation

protocol LoginPageSkipable {
    func onPressSkip(_ viewController: UIViewController)
}

extension LoginPageSkipable {
    func onPressSkip(_ viewController: UIViewController) {}
}

class LoginPageViewController: BaseViewController {
    var interactor: LoginPageInteractorInput?
    var router: LoginPageRouterInput?
    
    private var formNavigationController = UINavigationController()
    
    override func loadView() {
        super.loadView()
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewLoaded()
    }
    
    private func show(viewController: UIViewController) {
        formNavigationController.setViewControllers([viewController], animated: false)
    }
}

extension LoginPageViewController: LoginViewInput {
    func showPasswordForm() {
        let loginPasswordViewController = LoginPasswordViewController()
        loginPasswordViewController.delegate = self
        loginPasswordViewController.loginHeaderView.tabBar.delegate = self
        show(viewController: loginPasswordViewController)
    }
    
    func showCustomerNamePicker(_ customerNameList: [String]) {
        let loginCompaniesViewController = LoginCompaniesViewController()
        loginCompaniesViewController.delegate = self
        loginCompaniesViewController.customerNameList = customerNameList
        loginCompaniesViewController.loginHeaderView.tabBar.delegate = self
        show(viewController: loginCompaniesViewController)
    }
    
    func showAuthFactorsPicker(_ authFactorsList: [[String]], _ canSkip: Bool) {
        let loginAuthFactorsViewController = LoginAuthFactorsViewController()
        loginAuthFactorsViewController.authFactorsList = authFactorsList
        loginAuthFactorsViewController.delegate = self
        loginAuthFactorsViewController.canSkip = canSkip
        loginAuthFactorsViewController.loginHeaderView.tabBar.delegate = self
        show(viewController: loginAuthFactorsViewController)
    }
    
    func showOTPForm(_ canSkip: Bool) {
        let loginOTPViewController = LoginOTPViewController()
        loginOTPViewController.canSkip = canSkip
        loginOTPViewController.delegate = self
        loginOTPViewController.loginHeaderView.tabBar.delegate = self
        show(viewController: loginOTPViewController)
    }
    
    func showSMSForm(_ canSkip: Bool) {
        let loginSMSViewController = LoginSMSViewController()
        loginSMSViewController.canSkip = canSkip
        loginSMSViewController.delegate = self
        loginSMSViewController.loginHeaderView.tabBar.delegate = self
        show(viewController: loginSMSViewController)
    }
    
    func routeToMainMenuTabBar() {
        router?.routeToMainMenuTabBar()
    }
    
    func showSynchronizeOTPForm() {
        router?.presentSynchronizeOTPForm { [weak self] (previousToken, nextToken) in
            guard let self = self,
                let previousToken = previousToken,
                let nextToken = nextToken
            else {
                return
            }
            
            self.interactor?.onPassSynchronizeOTP(previousToken: previousToken, nextToken: nextToken)
        }
    }
}

extension LoginPageViewController: LoginPasswordPageDelegate {
    func onPressSingIn(_ viewController: LoginPasswordViewController) {
        interactor?.signInWith(username: viewController.username ?? "", password: viewController.password ?? "")
    }
}

extension LoginPageViewController: LoginAuthFactorsDelegate {
    func onChangeAuthFactorsItem(at indexPath: IndexPath, _ viewController: LoginAuthFactorsViewController) {
        interactor?.onChangeAuthFactors(at: indexPath.row)
    }
}

extension LoginPageViewController: LoginCompaniesDelegate {
    func onChangeCompanyItem(at indexPath: IndexPath) {
        interactor?.onChangeCustomer(at: indexPath.row)
    }
}

extension LoginPageViewController: LoginOTPDelegate {
    func onPressSendButton(_ viewController: LoginOTPViewController) {
        interactor?.onPassOTP(viewController.token ?? "")
    }
    
    func onPressSynchronizeButton(_ viewController: LoginOTPViewController) {
        interactor?.synchronizeOTP()
    }
}

extension LoginPageViewController: LoginSMSDelegate {
    func onPressSendButton(_ viewController: LoginSMSViewController) {
        interactor?.onPassSMS(viewController.code ?? "")
    }
}

extension LoginPageViewController: ViewInitalizationProtocol {
    func addSubviews() {
        addChild(viewController: formNavigationController)
    }
    
    func setupConstraints() {
        formNavigationController.view.addConstaintsToFill()
    }
    
    func stylizeViews() {
        formNavigationController.navigationBar.isHidden = true
        formNavigationController.view.backgroundColor = .clear
    }
}

extension LoginPageViewController: LoginTabBarDelegate {
    func onPressLanguageButton(_ view: LoginTabBar) {
        interactor?.onPressChangeLanguage()
    }
    
    func onPressBackButton(_ view: LoginTabBar) {
        interactor?.onPressBackButton()
    }
}

extension LoginPageViewController: LoginPageSkipable {
    func onPressSkip(_ viewController: UIViewController) {
        interactor?.onSkip()
    }
}
