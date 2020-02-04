//
//  TransferNewIteractor.swift
//  TransfersVIP
//
//  Created by psuser on 30/08/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

class TransferNewIteractor: BaseInteractorInputProtocol {
    
    private(set) var presenter: TransferNewPresenterInput
    private var newTransfers: [TransferNew] = []
    private var accountItems: AccountItems!

    init(presenter: TransferNewPresenterInput) {
        self.presenter = presenter
        self.setupNewTransfer()
    }
    
    private func setupNewTransfer() {
        if let decoded  = userDefaults.data(forKey: "accountItems") {
            accountItems = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! AccountItems
        } else {
            accountItems = AccountItems(currentAccountIsVisible: true, depositIsVisible: true, creditIsVisible: true, cardIsVisible: true, guaranteeIsVisible: true, currencyContractIsVisible: true, domesticTransferIsVisible: true, internationalTransferIsVisible: true, conversionIsVisible: true, transferBetweenOwnAccountsIsVisible: true, invoiceIsVisible: true, feedbackIsVisible: true, applicationIsVisible: true, salaryIsVisible: true, socialPaymentIsVisible: true, pensionPaymentIsVisible: true, medicalPaymentIsVisible: true)
        }
        
        if accountItems.domesticTransferIsVisible {
            newTransfers.append(TransferNew(title: TransferTypeRus.paymentTenge.description, icon: AppImage.tengeTransfer.uiImage))
        }
        
        if accountItems.salaryIsVisible {
            newTransfers.append(TransferNew(title: TransferTypeRus.payroll.description, icon: AppImage.payrollTransfer.uiImage))
        }
        
        if accountItems.medicalPaymentIsVisible {
            newTransfers.append(TransferNew(title: TransferTypeRus.medical.description, icon: AppImage.medicalTransfer.uiImage))
        }
        
        if accountItems.pensionPaymentIsVisible {
            newTransfers.append(TransferNew(title: TransferTypeRus.pension.description, icon: AppImage.pensionTransfer.uiImage))
        }
        
        if accountItems.socialPaymentIsVisible {
            newTransfers.append(TransferNew(title: TransferTypeRus.social.description, icon: AppImage.socialTransfer.uiImage))
        }
        
        if accountItems.transferBetweenOwnAccountsIsVisible {
            newTransfers.append(TransferNew(title: TransferTypeRus.internal.description, icon: AppImage.internalTransfer.uiImage))
        }
        
        if accountItems.internationalTransferIsVisible {
            newTransfers.append(TransferNew(title: TransferTypeRus.international.description, icon: AppImage.internationalTransfer.uiImage))
        }
        
        if accountItems.conversionIsVisible {
            newTransfers.append(TransferNew(title: TransferTypeRus.conversion.description, icon: AppImage.conversionTransfer.uiImage))
        }
    }
}

extension TransferNewIteractor: TransferNewIteractorInput {
   
    func createPaymentTransfer(index: Int) {
        guard let title = newTransfers[index].title else { fatalError("The transfer haven't title")}
        
        let viewModel: (OperationViewModelDataLoadable & OperationViewModel)
        switch title {
        case TransferTypeRus.paymentTenge.description:
            viewModel = DomesticTransferViewModel()
        case TransferTypeRus.payroll.description:
            viewModel = PayrollPaymentViewModel()
        case TransferTypeRus.pension.description:
            viewModel = PensionPaymentViewModel()
        case TransferTypeRus.social.description:
            viewModel = SocialPaymentViewModel()
        case TransferTypeRus.medical.description:
            viewModel = MedicalPaymentViewModel()
        case TransferTypeRus.conversion.description:
            viewModel = ConversionViewModel()
        case TransferTypeRus.internal.description:
            viewModel = InternalTransferViewModel()
        case TransferTypeRus.international.description:
            viewModel = InternalTransferViewModel()
        default:
            fatalError("viewModel not initilized")
        }
        
        presenter.startLoading()
        viewModel.loadInitialData { [weak self] success, errorMessage in
            guard let interactor = self else { return }
            interactor.presenter.stopLoading()
            guard success else {
                
                interactor.presenter.showError(message: errorMessage ?? NetworkError.unknown.description)
                return
            }
            interactor.presenter.setPaymentTransfer(viewModel: viewModel, with: title)
        }
    }
    
    func setTitles() {
        presenter.setTitles(titles: newTransfers)
    }
}

enum TransferTypeRus: String, CustomStringConvertible {
    case paymentTenge = "Переводы в тенге"
    case medical = "Медицинское отчисление"
    case pension = "Пенсионное отчисление"
    case social = "Социальное отчисление"
    case payroll = "Зарплатное отчисление"
    case international = "Переводы в валюте"
    case `internal` = "Перевод между счетами"
    case conversion = "Конвертация"
    
    var description: String {
        return self.rawValue
    }
}
//
//  AccountItems.swift
//  DigitalBank
//
//  Created by Saltanat Aimakhanova on 3/11/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

class AccountItems: NSObject, NSCoding {
    
    var currentAccountIsVisible = true
    var depositIsVisible = true
    var creditIsVisible = true
    var cardIsVisible = true
    var guaranteeIsVisible = true
    var currencyContractIsVisible = true
    var domesticTransferIsVisible = true
    var internationalTransferIsVisible = true
    var conversionIsVisible = true
    var transferBetweenOwnAccountsIsVisible = true
    var invoiceIsVisible = true
    var feedbackIsVisible = true
    var applicationIsVisible = true
    var salaryIsVisible = true
    var socialPaymentIsVisible = true
    var pensionPaymentIsVisible = true
    var medicalPaymentIsVisible = true
    
    init(currentAccountIsVisible: Bool, depositIsVisible: Bool, creditIsVisible: Bool, cardIsVisible: Bool, guaranteeIsVisible: Bool, currencyContractIsVisible: Bool, domesticTransferIsVisible: Bool, internationalTransferIsVisible: Bool, conversionIsVisible: Bool, transferBetweenOwnAccountsIsVisible: Bool, invoiceIsVisible: Bool, feedbackIsVisible: Bool, applicationIsVisible: Bool, salaryIsVisible: Bool, socialPaymentIsVisible: Bool, pensionPaymentIsVisible: Bool, medicalPaymentIsVisible: Bool) {
        self.currentAccountIsVisible = currentAccountIsVisible
        self.depositIsVisible = depositIsVisible
        self.creditIsVisible = creditIsVisible
        self.cardIsVisible = cardIsVisible
        self.guaranteeIsVisible = guaranteeIsVisible
        self.currencyContractIsVisible = currencyContractIsVisible
        self.domesticTransferIsVisible = domesticTransferIsVisible
        self.internationalTransferIsVisible = internationalTransferIsVisible
        self.conversionIsVisible = conversionIsVisible
        self.transferBetweenOwnAccountsIsVisible = transferBetweenOwnAccountsIsVisible
        self.invoiceIsVisible = invoiceIsVisible
        self.feedbackIsVisible = feedbackIsVisible
        self.applicationIsVisible = applicationIsVisible
        self.salaryIsVisible = salaryIsVisible
        self.socialPaymentIsVisible = socialPaymentIsVisible
        self.pensionPaymentIsVisible = pensionPaymentIsVisible
        self.medicalPaymentIsVisible = medicalPaymentIsVisible
    }
    
    convenience init(with fill: Bool) {
        self.init(currentAccountIsVisible: fill, depositIsVisible: fill, creditIsVisible: fill, cardIsVisible: fill, guaranteeIsVisible: fill, currencyContractIsVisible: fill, domesticTransferIsVisible: fill, internationalTransferIsVisible: fill, conversionIsVisible: fill, transferBetweenOwnAccountsIsVisible: fill, invoiceIsVisible: fill, feedbackIsVisible: fill, applicationIsVisible: fill, salaryIsVisible: fill, socialPaymentIsVisible: fill, pensionPaymentIsVisible: fill, medicalPaymentIsVisible: fill)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(currentAccountIsVisible, forKey: "currentAccountIsVisible")
        aCoder.encode(depositIsVisible, forKey: "depositIsVisible")
        aCoder.encode(creditIsVisible, forKey: "creditIsVisible")
        aCoder.encode(cardIsVisible, forKey: "cardIsVisible")
        aCoder.encode(guaranteeIsVisible, forKey: "guaranteeIsVisible")
        aCoder.encode(currencyContractIsVisible, forKey: "currencyContractIsVisible")
        aCoder.encode(domesticTransferIsVisible, forKey: "domesticTransferIsVisible")
        aCoder.encode(internationalTransferIsVisible, forKey: "internationalTransferIsVisible")
        aCoder.encode(conversionIsVisible, forKey: "conversionIsVisible")
        aCoder.encode(transferBetweenOwnAccountsIsVisible, forKey: "transferBetweenOwnAccountsIsVisible")
        aCoder.encode(invoiceIsVisible, forKey: "invoiceIsVisible")
        aCoder.encode(feedbackIsVisible, forKey: "feedbackIsVisible")
        aCoder.encode(applicationIsVisible, forKey: "applicationIsVisible")
        aCoder.encode(salaryIsVisible, forKey: "salaryIsVisible")
        aCoder.encode(socialPaymentIsVisible, forKey: "socialPaymentIsVisible")
        aCoder.encode(pensionPaymentIsVisible, forKey: "pensionPaymentIsVisible")
        aCoder.encode(medicalPaymentIsVisible, forKey: "medicalPaymentIsVisible")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let currentAccountIsVisible = aDecoder.decodeBool(forKey: "currentAccountIsVisible")
        let depositIsVisible = aDecoder.decodeBool(forKey: "depositIsVisible")
        let creditIsVisible = aDecoder.decodeBool(forKey: "creditIsVisible")
        let cardIsVisible = aDecoder.decodeBool(forKey: "cardIsVisible")
        let guaranteeIsVisible = aDecoder.decodeBool(forKey: "guaranteeIsVisible")
        let currencyContractIsVisible = aDecoder.decodeBool(forKey: "currencyContractIsVisible")
        let domesticTransferIsVisible = aDecoder.decodeBool(forKey: "domesticTransferIsVisible")
        let internationalTransferIsVisible = aDecoder.decodeBool(forKey: "internationalTransferIsVisible")
        let conversionIsVisible = aDecoder.decodeBool(forKey: "conversionIsVisible")
        let transferBetweenOwnAccountsIsVisible = aDecoder.decodeBool(forKey: "transferBetweenOwnAccountsIsVisible")
        let invoiceIsVisible = aDecoder.decodeBool(forKey: "invoiceIsVisible")
        let feedbackIsVisible = aDecoder.decodeBool(forKey: "feedbackIsVisible")
        let applicationIsVisible = aDecoder.decodeBool(forKey: "applicationIsVisible")
        let salaryIsVisible = aDecoder.decodeBool(forKey: "salaryIsVisible")
        let socialPaymentIsVisible = aDecoder.decodeBool(forKey: "socialPaymentIsVisible")
        let pensionPaymentIsVisible = aDecoder.decodeBool(forKey: "pensionPaymentIsVisible")
        let medicalPaymentIsVisible = aDecoder.decodeBool(forKey: "medicalPaymentIsVisible")
        
        self.init(currentAccountIsVisible: currentAccountIsVisible, depositIsVisible: depositIsVisible, creditIsVisible: creditIsVisible, cardIsVisible: cardIsVisible, guaranteeIsVisible: guaranteeIsVisible, currencyContractIsVisible: currencyContractIsVisible, domesticTransferIsVisible: domesticTransferIsVisible, internationalTransferIsVisible: internationalTransferIsVisible, conversionIsVisible: conversionIsVisible, transferBetweenOwnAccountsIsVisible: transferBetweenOwnAccountsIsVisible, invoiceIsVisible: invoiceIsVisible, feedbackIsVisible: feedbackIsVisible, applicationIsVisible: applicationIsVisible, salaryIsVisible: salaryIsVisible, socialPaymentIsVisible: socialPaymentIsVisible, pensionPaymentIsVisible: pensionPaymentIsVisible, medicalPaymentIsVisible: medicalPaymentIsVisible)
    }
}
