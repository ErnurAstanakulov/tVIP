//
//  Constants.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 2/18/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

let IntSubject: (Int) -> ReplaySubject<Int> = ReplaySubject.create
let StringSubject: (Int) -> ReplaySubject<String> = ReplaySubject.create
let BoolSubject: (Int) -> ReplaySubject<Bool> = ReplaySubject.create
let DoubleSubject: (Int) -> ReplaySubject<Double> = ReplaySubject.create
let userDefaults = UserDefaults.standard

typealias AnyDict =  [String: Any]
typealias StringDict = [String: String]

typealias Sum = Double

typealias Block = (() -> Swift.Void)

let host = "panter.infin-it.kz"
public let baseURL = "https://" + host + "/"
public let chatURL = "wss://" + host + "/"

 

public let appInStoreLink: String? = nil
public let appStoreMainPageLink = "itms://itunes.apple.com/app/apple-store"

public var statusDescription = [ "400": "Юзер с данным логином уже в сети",
                                 "401": "Неверный логин или пароль",
                                 "403": "Ваш профиль удален",
                                 "404": "404",
                                 "419": "Сессия прервана администратором",
                                 "500": "Сервер не отвечает. Зайдите позже",
                                 "204": "Проверьте интернет соединение"]

public let contentErrorMessage = "Возникла проблема при загрузке данных"

//MARK: Global parametres

let HistoryBatchSize: Int = 10
let FilterSectionHeight: CGFloat = 60.0
let SessionSecondTime: Int = 15 * 60

struct Constants {
    
    public enum PassValidationError: Error {
        case oldNotValid
        case empty
        case toShort
        case failConfirmation
    }
    
    public struct DomesticTransferPages {
        static let payerRequisites = "ОТПРАВИТЕЛЬ"
        // NSLocalizedString("payerRequisites", comment: "Title for nav item")
        static let recipientRequisites = "ПОЛУЧАТЕЛЬ"
        //NSLocalizedString("recipientRequisites", comment: "Title for nav item")
        static let paymentDetails = "ДЕТАЛИ ПЛАТЕЖА"
        //NSLocalizedString("paymentDetails", comment: "Title for nav item")
        static let additionalInfo = "Дополнительно"
        static let employesTitle = "СОТРУДНИКИ"
    }
    
    // MARK: Validation constants
    static let maxKBECount = 2
    static let maxINNCount = 12
    static let maxIBANCount = 20
    
    //DESC: fields for displaing in NotificationDetailsViewController
    
    enum NotificationSettingsType: String {
        case accounts = "accounts"
        case channels = "channels"
        case amount = "amount"
        case documentTypes = "documentTypes"
        case statuses = "statuses"
        case certificate = "certificate"
        case days = "days"
        
        var title: String {
            switch self {
            case .accounts:
                return "Счета"
            case .channels:
                return "Каналы отправки"
            case .documentTypes:
                return "Типы документа"
            case .statuses:
                return "Статусы"
            case .amount:
                return "Сумма"
            case .certificate:
                return "Сертификат"
            case .days:
                return "Дней до события:"
            }
        }
        
        func description(for property: NotificationProperty) -> [NotificationItem]? {
            switch self {
            case .accounts:
                return property.accounts
            case .channels:
                return property.channels
            case .documentTypes:
                return property.documentTypes
            case .statuses:
                return property.statuses
            default:  return nil
            }
        }
    }
    
    struct PaymentTypes: Codable {
        static let paymentOrder = "PaymentOrder"
        static let payroll = "Payroll"
        static let pensionContribution = "PensionContribution"
        static let socialContribution = "SocialContribution"
        static let domesticTransfer = "DomesticTransfer"
        static let medicalContribution = "MedicalContribution"
        static let demand = "Demand"
        static let conversion = "Conversion"
        static let internalTransfer = "OwnAccountTransfer"
    }

    struct DocumentState {
        static let draft = "Draft"
        static let awaitsSignature = "AwaitsSignature"
        static let signed = "Signed"
        static let deleted = "Deleted"
        static let sentToRBS = "SentToRBS"
        static let acceptedInRBS = "AcceptedInRBS"
        static let notAcceptedInABS = "NotAcceptedInABS"
        static let notAccepted = "NotAccepted"
        static let revoked = "Revoked"
        static let executed = "Executed"
        static let paid = "Paid"
        static let refused = "Refused"
        static let accepted = "Accepted"
        static let pay = "Pay"
    }
    
    struct DocumentActions {
        static let revoke = "revoke" //отозвать
        static let bad = "bad" //отправить в непринятые
        static let remove = "remove"  //удалить
        static let sentToRBS = "sentToRBS" //отправить в банк
        static let toDraft = "toDraft" //вернуть на редактирование
        static let sign = "sign" //подписать
        static let submit = "submit" //отправить на подписание +
        static let pay = "pay" //оплатить +
        static let reject = "reject" //отказать +
        static let edit = "edit"
    }
    
    struct DocumentTypes {
        static let standingOrder = "StandingOrder"
        static let accountTransfer = "AccountTransfer"
        static let documentWithdraw = "DocumentWithdraw"
    }
    
    enum Subcode : String, Decodable {
        case accountTransfer = "AccountTransfer"
        case conversion = "Conversion"
        case p2p = "P2P"
    }
    
    //Type for WorkDocumentsViewController
    enum DocumentType: String, Decodable {
        case accountTransfer = "AccountTransfer"
        case domesticTransfer = "DomesticTransfer"
        case internationTransfer = "InternationalTransfer"
        case standingOrder = "StandingOrder"
        case paymentOrder = "PaymentOrder"
        case exposedOrder = "ExposedOrder"
        case paymentsRevokes = "DocumentWithdraw"
        case invoice = "Invoice"
        case demand = "Demand"
        case fortex = "FortexTransfer"
    }
    
    enum AuthentificationType: String {
        case unknown = ""
        case password = "Password"
        case sms = "SMS"
        case signature = "Signature"
        case otp = "OTP"
        case generator = "Generator"
        case refreshToken = "refresh_token"
    }
    
    enum AuthFactorType: String {
        case SMS
        case Signature
        case Generator
        case Skip
        
        var localized: String {
            switch self {
            case .Signature: return "ЭЦП"
            case .Generator: return "OTP токен"
            case .Skip: return "Пропустить"
            default: return rawValue
            }
        }
    }
    
    enum Roles: String, Decodable {
        case ANONYMOUS
        case dir
        case acc
        
        var localized: String {
            switch self {
            case .dir: return "ДИРЕКТОР"
            default: return rawValue
            }
        }
    }
    
    enum FactorsType: String, Decodable {
        case Password
        case SMS
        case Signature
        case Generator
        case Refresh_token
        
        var localized: String {
            switch self {
            case .Signature: return "ЭЦП"
            case .Generator: return "OTP токен"
            case .SMS: return "SMS"
            default: return rawValue
            }
        }
    }
    
    struct CardType {
        static let visa = "VISA"
        static let masterCard = "MC"
    }
    
    enum CreditType: String {
        case overdraft = "01"
        case line = "02"
        case tranche = "03"
        case credit = "04"
        case guarantee = "05"
        case creditLetter = "06" // Акредитив
    }
    
    struct Сurrency {
        static let KZT = "KZT"
        static let USD = "USD"
        static let EUR = "EUR"
        static let RUB = "RUB"
        static let GBP = "GBP"
        static let CNY = "CNY"
    }
    
    struct NotificationIdentifier {
        //POST notifucation with user info (["index": Int, "account": DetailedAccount])
        static let userDidSelectAccount = "userDidSelectAccount"
        static let userDidSelectCard = "userDidSelectCard"
        static let userDidSelectCredit = "userDidSelectCredit"
        static let userDidSelectDeposit = "userDidSelectDeposit"
        static let userDidSelectGuarantee = "userDidSelectGuarantee"
        static let userDidSelectForeignExchangeContract = "userDidSelectForeignExchangeContract"
        
        static let shoudReturnToMainPage = "shoudReturnToMainPage"
        static let organizationDidChange = "organizationDidChange"
    }
    
    struct DateFormats {
        static let shortDot = "dd.MM.yyyy"  //01.12.2016
        static let shortВash = "dd-MM-yyyy" //01-12-2016
        static let shortQuery = "yyyy-MM-dd" //2016-01-23
        static let shortQueryWithTime = "yyyy-MM-dd'T'HH:mm:ss" //2018-01-01T19:30:55
    }
    
    enum Terminals: String {
        case atm = "ATM"
        case department = "DEPARTMENT"
        case terminal = "TERMINAL"
    }
    
    struct Notifications {
        
        enum DocumentTypeNotification: String {
            case work = "work_checkbox"
            case template = "template_checkbox"
            case regular = "regular_checkbox"
        }
        
        enum DocumentsFilterNotification: String {
            case work = "filter_work"
            case regular = "filter_regular"
        }
        
        static let cityNotification = "cityChanged"
        static let radioButtonNotification = "defaultNotification"
        static let updateDeclarations = NSNotification.Name("updateDeclarationHistory")
    }
    
    static let paymentsTypes = ["PaymentOrder", "Payroll", "PensionContribution", "SocialContribution", "MedicalContribution", "DomesticTransfer", "Demand"]
    
    static let objectsToLoad = 10
    
    enum RefundType: String {
        case Payroll
        case PensionContribution
        case SocialContribution
        case MedicalContribution
    }

    enum UserNotificationType: String {
        case Birthday
    }
    
    enum ServerError: String {
        case validation = "error.validation"
        case internalError = "error.internalServerError"
    }
}
