//
//  MedicalPaymentComponent.swift
//  DigitalBank
//
//  Created by Zhalgas Baibatyr on 22.05.2018.
//  Copyright © 2018 InFin-It Solutions. All rights reserved.
//

enum MedicalPaymentComponent: String {
	case template
    case documentNumber
    
    // ChildOrganization
    case childOrganization
    case childOrganizationName
    case binChildOrganization
    case codeChildOrganization
    
	// Sender
	case accountNumber
	case directorFullName
	case accountantFullName

	// Receiver
	case companyName
	case companyTaxCode
	case companyAccount
	case kbeCode
	case companyBankCode
	case companyBankName

	// Payment details
	case urgentPaymentIndicator
	case valueDate
	case amount
	case period
	case medicalInsuranceCategory
	case knpCode
	case knpDescription
	case purpose
	case additionalInfo
    case bankResponse

	case employees
    case director
    case accountant
}
