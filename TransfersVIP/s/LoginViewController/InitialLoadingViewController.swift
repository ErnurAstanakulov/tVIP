//
//  InitialLoadingViewController.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 5/5/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import UIKit
import RxSwift

class InitialLoadingViewController: UIViewController {
    let scheduler = ConcurrentDispatchQueueScheduler(qos: DispatchQoS.background)
    
    private var loginPageViewModel = LoginPageLoader()
    private let disposeBag = DisposeBag()
    
    var logoImageView = UIImageView()
    
    private var verticalStackView = UIStackView()
    private var titleLabel = UILabel()
    private var descriptionLabel = UILabel()
    private var emptyView = UIView()
    private var updateButton = UIButton()
    
    deinit {
        self.debagDealloc()
    }
    
    override func loadView() {
        super.loadView()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadInitialData()
    }
    
    private func loadData() {
 
        loadInitialData()
    }
    
    private func loadInitialData() {
        let observable = loginPageViewModel.loadInitilData()
            .subscribeOn(scheduler)
            .retry(3)
            .observeOn(MainScheduler.asyncInstance)
        
        observable.subscribe(onNext: { [weak self] (data) in
            guard let self = self else { return }
            if (self.isUpdateAvailable(versions: data.versions)) {
                self.showLaterVersionAvailableMessage()
            } else {
                self.onSuccessLoad(loginPageInitialData: data)
            }
            }, onError: { [weak self] (error) in
                guard let self = self else { return }
                self.presentRepeatErrorController(error: error, action: { [weak self] (sender) in
                    self?.loadInitialData()
                })
        }).disposed(by: disposeBag)
    }
    
    private func onSuccessLoad(loginPageInitialData data: LoginPageInitialData) {
        showTabBarController()
    }
    
    private func showLaterVersionAvailableMessage() {
        logoImageView.isHidden = true
        verticalStackView.isHidden = false
        updateButton.isUserInteractionEnabled = true
    }
    
    private func showAppInStore() {
        let urlStr = appInStoreLink ?? appStoreMainPageLink
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(URL(string: urlStr)!)
        }
    }
    
    private func isUpdateAvailable(versions: AppVersions?) -> Bool {
        guard
            let info = Bundle.main.infoDictionary,
            let currentVersion = info["CFBundleShortVersionString"] as? String,
            let availableVersion = versions?.results?.first,
            let version = availableVersion.version else {
                return false
        }
        
        return true
    }
    
    private func showTabBarController() {
        let authMainPageRouter: AuthMainPageRouterInput = AuthMainPageRouter(networkService: NetworkAdapter(sessionManager: sessionManager))
        let viewController = authMainPageRouter.createModule()
        navigationController?.pushViewController(viewController, animated: false)
    }
    
    @objc func onPressUpdate() {
        print("PRESS UPDATE")
        showAppInStore()
    }
    
    override var prefersStatusBarHidden: Bool { return true }
}

extension InitialLoadingViewController: ViewInitalizationProtocol {
    func addSubviews() {
        view.addSubview(logoImageView)
        view.addSubview(verticalStackView)
        
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(descriptionLabel)
        verticalStackView.addArrangedSubview(emptyView)
        verticalStackView.addArrangedSubview(updateButton)
    }
    
    func setupConstraints() {
        logoImageView.addConstaintsToHorizontal(padding: 65)
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        verticalStackView.addConstaintsToHorizontal(padding: 25)
        verticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        updateButton.translatesAutoresizingMaskIntoConstraints = false
        updateButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func stylizeViews() {
        view.backgroundColor = .white
        
        navigationController?.isNavigationBarHidden = true
        
        logoImageView.image = AppImage.logoNew.uiImage
        logoImageView.contentMode = .scaleAspectFit
        
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .fill
        verticalStackView.spacing = 8
        
        titleLabel.font = AppFont.semibold.with(size: 16)
        titleLabel.textColor = AppColor.dark.uiColor
        titleLabel.numberOfLines = 0
        titleLabel.text = "Версия приложения не актуальна"
        titleLabel.textAlignment = .center
        
        descriptionLabel.font = AppFont.light.with(size: 14)
        descriptionLabel.textColor = AppColor.gray.uiColor
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = "Пожалуйста обновите приложения что бы продолжить"
        descriptionLabel.textAlignment = .center
        
        updateButton.backgroundColor = AppColor.green.uiColor
        updateButton.setTitleColor(.white, for: .normal)
        updateButton.titleLabel?.font = AppFont.semibold.with(size: 16)
        updateButton.setTitle("Обновить", for: .normal)
        updateButton.decorator.apply(Style.round(), Style.shadow())
        
        verticalStackView.isHidden = true
    }
    
    func extraTasks() {
        updateButton.addTarget(self, action: #selector(onPressUpdate), for: .touchUpInside)
    }
}
//
//  LoginPageLoader.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 5/8/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import RxSwift

struct LoginPageInitialData {
    var initialLocalization: LoginPageLocalization?
    var config: AppConfig?
    var versions: AppVersions?
    
    init(localization: LoginPageLocalization?, config: AppConfig?, versions: AppVersions?) {
        self.initialLocalization = localization
        self.config = config
        self.versions = versions
    }
}

class LoginPageLoader: BaseViewModel {
    func initialLocalization() -> Observable<LoginPageLocalization?> {
        return self.loadJSON(url: baseURL + "api/translate/preload")
            .map { (json) -> LoginPageLocalization? in
                return LoginPageLocalization(JSON: json)
        }
    }
    
    func loadConfig() -> Observable<AppConfig?> {
        let url = baseURL + "/site/config.json"
        return self.loadJSON(url: url).map { (json) -> AppConfig? in
            return AppConfig(JSON: json)
        }
    }
    
    func loadVersions() -> Observable<AppVersions?> {
        let identifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
        print("CFBundleIdentifier -> \(identifier ?? "NULL")")
        let url = "http://itunes.apple.com/lookup?bundleId=\(identifier ?? "")"
        return self.loadJSON(url: url).map { (json) -> AppVersions? in
            return AppVersions(JSON: json)
        }
    }
    
    func loadInitilData() -> Observable<LoginPageInitialData> {
        let localizationObservable = self.initialLocalization()
        let configObservable = self.loadConfig()
        let loadVersions = self.loadVersions()
        return Observable<LoginPageInitialData>.zip(localizationObservable, configObservable, loadVersions) { (localization, config, versions) -> LoginPageInitialData in
            return LoginPageInitialData(localization: localization, config: config, versions: versions)
        }
    }
}
//
//  AppVersion.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 8/15/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import ObjectMapper

class AppVersions: Mappable {
    var resultCount: Int?
    var results: [AppVersion]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        resultCount <- map["resultCount"]
        results <- map["results"]
    }
}

class AppVersion: Mappable {
    var version: String?
    var trackViewUrl: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        version <- map["version"]
        trackViewUrl <- map["trackViewUrl"]
    }
}
class LoginPageLocalization: Mappable {
    var kzt: BaseLocalizationModel?
    var rus: BaseLocalizationModel?
    var eng: BaseLocalizationModel?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        kzt <- map["kk"]
        rus <- map["ru"]
        eng <- map["en"]
    }
    
    public func languageFrom(state :SelectedLanguage) -> BaseLocalizationModel?  {
        switch state {
        case .RUS: return self.rus
        case .KZT: return self.kzt
        case .ENG: return self.eng
        }
    }
}
class AppConfig: Mappable {
    var documents: DocumentsConfig?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        documents <- map["documents"]
    }
}
//
//  BaseViewModel.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 4/1/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

func log<T>(serverResponse: DataResponse<T>) {
    #if !BANKPROD
    serverRequest(request: serverResponse.request)
    serverResponseBody(data: serverResponse.data)
    serverResponseError(error: serverResponse.error)
    #else
    return
    #endif
}

func defaultLog(defaultResponse: DefaultDataResponse) {
    #if !BANKPROD
    serverRequest(request: defaultResponse.request)
    serverResponseBody(data: defaultResponse.data)
    serverResponseError(error: defaultResponse.error)
    #else
    return
    #endif
}

fileprivate func serverRequest(request: URLRequest?) {
    print("=======REQUEST========")
    if let url = request?.url {
        print("URL:")
        print(url)
    }
    if let data = request?.httpBody,
        let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
        print("REQUEST BODY:")
        print(string)
    }
    if let header = request?.allHTTPHeaderFields {
        print("HEADER:")
        print(header)
    }
}

fileprivate func serverResponseBody(data: Data?) {
    if let data = data,
        let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
        print("RESPONSE BODY:")
        print(string)
    }
}

fileprivate func serverResponseError(error: Error?) {
    if let error = error {
        print("ERROR:")
        print(error.localizedDescription)
    }
    print("=======REQUEST END========")
}
public enum RxRequstError: LocalizedError {
    case unknown
    /// Response is not successful. (not in `200 ..< 300` range)
    case httpRequestFailed(response: HTTPURLResponse, statusCode: Int)
    /// Deserialization error.
    case deserializationError(responceValue: Any?)
    case failed(message: String)
    
    public var errorDescription: String? {
        switch self {
        case .unknown:
            return "Ошибка интернет соединения."
        case let .httpRequestFailed(_, statusCode):
            switch statusCode {
            case 400: return "Юзер с данным логином уже в сети"
            case 401: return "Неверный логин или пароль"
            case 403: return "Ваш профиль удален"
            case 419: return "Сессия прервана администратором"
            case 500: return "Сервер не отвечает. Зайдите позже"
            default: return "Ошибка HTTP запроса с кодом `\(statusCode)`."
            }
        case let .deserializationError(responceValue):
            return "Ошибка во время сериализации: \(String(describing: responceValue))"
        case let .failed(message):
            return message
        }
    }
}

class BaseViewModel {
    init() {}
    
    public func loadJSON(url: URLConvertible, method: HTTPMethod = .get, parametres: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: [String: String]? = nil) -> Observable<[String: Any]> {
        return self.loadAny(url: url, method: method, parametres: parametres, encoding: encoding, headers: headers)
            .map({ any -> AnyDict in
                guard let dict = any as? AnyDict else {
                    throw RxRequstError.deserializationError(responceValue: any)
                }
                
                return dict
            })
    }
    
    public func loadAny(url: URLConvertible, method: HTTPMethod = .get, parametres: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: [String: String]? = nil) -> Observable<Any> {
        return Observable<Any>.create { (observer) -> Disposable in
            let task = sessionManager.request(url, method: method, parameters: parametres, encoding: encoding, headers: headers).validate()
            task.responseJSON(queue: DispatchQueue.main, completionHandler: { serverResponce in
                log(serverResponse: serverResponce)
                guard let value = serverResponce.result.value else {
                    guard let responce = serverResponce.response else {
                        observer.onError(RxRequstError.unknown)
                        return
                    }
                    
                    let error = RxRequstError.httpRequestFailed(response: responce, statusCode: responce.statusCode)
                    observer.onError(error)
                    return
                }
                
                observer.onNext(value)
                observer.onCompleted()
            })
            
            task.resume()
            return Disposables.create(with: task.cancel)
        }
    }
}
class BaseLocalizationModel: Mappable {
    var commonCity: String?
    var sale: String?
    var navigationNews: String?
    var usersExcelCreatorLogin: String?
    var exchangeRatesExchangeRates: String?
    var navigationSettings: String?
    var mobileLogin: String?
    var exchangeRatesPurchase: String?
    var mobileMenu: String?
    var mobileList: String?
    
    var loginPassword: String?
    var mobileAbout: String?
    var mobileDepartments: String?
    var mobileRemindme: String?
    var mobileCapabilities: String?
    var loginToEnter: String?
    var mobileBanking: String?
    var mobileLoading: String?
    
    var loginRecovery: String?
    var mobileCallUsAndWeWillHelp: String?
    var mobileFreeFromKazakhstan: String?
    var mobileForInternationalCalls: String?
    var mobileCancel: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        commonCity <- map["common_city", nested: false]
        sale <- map["SALE", nested: false]
        navigationNews <- map["navigation_news", nested: false]
        usersExcelCreatorLogin <- map["UsersExcelCreator.Login", nested: false]
        exchangeRatesExchangeRates <- map["exchangeRates_exchangeRates", nested: false]
        navigationSettings <- map["navigation_settings", nested: false]
        mobileLogin <- map["mobile.login", nested: false]
        exchangeRatesPurchase <- map["exchangeRates_purchase", nested: false]
        mobileMenu <- map["mobile.menu", nested: false]
        mobileList <- map["mobile.list", nested: false]
        
        loginPassword <- map["login_password", nested: false]
        mobileAbout <- map["mobile.about", nested: false]
        mobileDepartments <- map["mobile.departments", nested: false]
        mobileRemindme <- map["mobile.remindme", nested: false]
        mobileCapabilities <- map["mobile.capabilities", nested: false]
        loginToEnter <- map["login_to_enter", nested: false]
        mobileBanking <- map["mobile.banking", nested: false]
        mobileLoading <- map["mobile.loading", nested: false]
        
        loginRecovery <- map["login_recovery", nested: false]
        mobileCallUsAndWeWillHelp <- map["mobile.call_us_and_we_will_help", nested: false]
        mobileFreeFromKazakhstan <- map["mobile.free_from_kazakhstan", nested: false]
        mobileForInternationalCalls <- map["mobile.for_international_calls", nested: false]
        mobileCancel <- map["mobile.cancel", nested: false]
    }
}

class DocumentsConfig: Mappable {
    var domesticTransfer: DomesticTransferConfigs?
    var accountTransfer: AccountTransferConfig?
    var internatTransfer: InternationalTransferConfig?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        domesticTransfer <- map["domesticTransfer"]
        accountTransfer <- map["accountTransfer"]
        internatTransfer <- map["intTransfer"]
    }
}

class DomesticTransferConfigs: Mappable {
    var paymentOrder: DomesticTransferConfig?
    var payroll: DomesticTransferConfig?
    var pensionContribution: DomesticTransferConfig?
    var socialContribution: DomesticTransferConfig?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        paymentOrder <- map["paymentOrder"]
        payroll <- map["payroll"]
        pensionContribution <- map["pensionContribution"]
        socialContribution <- map["socialContribution"]
    }
}

class DomesticTransferConfig: Mappable {
    var constraints: DomesticTransferConstraints?
    var employeeConstraints: DomesticTransferEmployeeConstraints?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        constraints <- map["constraints"]
        employeeConstraints <- map["employeeConstraints"]
    }
}

class DomesticTransferConstraints: Mappable {
    var account: BaseConstraint?
    var director: BaseConstraint?
    var valueDate: BaseConstraint?
    var purpose: BaseConstraint?
    var purposeCode: BaseConstraint?
    var benefTaxCode: BaseConstraint?
    var benefName: BaseConstraint?
    var benefBankCode: BaseConstraint?
    var benefResidencyCode: BaseConstraint?
    var benefAccount: BaseConstraint?
    var budgetCode: BaseConstraint?
    var number: BaseConstraint?
    var info: BaseConstraint?
    var vinCode: BaseConstraint?
    var amount: BaseConstraint?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        account <- map["account"]
        director <- map["director"]
        valueDate <- map["valueDate"]
        purpose <- map["purpose"]
        purposeCode <- map["purposeCode"]
        benefTaxCode <- map["benefTaxCode"]
        benefName <- map["benefName"]
        benefBankCode <- map["benefBankCode"]
        benefResidencyCode <- map["benefResidencyCode"]
        benefAccount <- map["benefAccount"]
        budgetCode <- map["budgetCode"]
        number <- map["number"]
        info <- map["info"]
        vinCode <- map["vinCode"]
        amount <- map["amount"]
    }
}

class DomesticTransferEmployeeConstraints: Mappable {
    var amount: BaseConstraint?
    var firstName: BaseConstraint?
    var lastName: BaseConstraint?
    var middleName: BaseConstraint?
    var taxCode: BaseConstraint?
    var account: BaseConstraint?
    var birthDate: BaseConstraint?
    var period: BaseConstraint?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        amount <- map["amount"]
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        middleName <- map["middleName"]
        taxCode <- map["taxCode"]
        account <- map["account"]
        birthDate <- map["birthDate"]
        period <- map["period"]
    }
}

import Foundation
import ObjectMapper

class AccountTransferConfig: Mappable {
    var constraints: AccountTransferConstraints?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        constraints <- map["constraints"]
    }
}

class AccountTransferConstraints: Mappable {
    var account: BaseConstraint?
    var creditSum: BaseConstraint?
    var debitSum: BaseConstraint?
    var debitCurrency: BaseConstraint?
    var creditAccount: BaseConstraint?
    var creditCurrency: BaseConstraint?
    var valueDate: BaseConstraint?
    var purpose: BaseConstraint?
    var purposeCode: BaseConstraint?
    var number: BaseConstraint?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        account <- map["account"]
        creditSum <- map["creditSum"]
        debitSum <- map["debitSum"]
        debitCurrency <- map["debitCurrency"]
        creditAccount <- map["creditAccount"]
        creditCurrency <- map["creditCurrency"]
        valueDate <- map["valueDate"]
        purpose <- map["purpose"]
        purposeCode <- map["purposeCode"]
        number <- map["number"]
    }
}
