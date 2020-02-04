//
//  AuthenticationFactors.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 4/27/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import RxSwift

class PrivilegesConstants {
    
    //Menu visibility
    public static  let ROOT_VIEW = "root_view";
    public static  let ONLINE_CHAT = "online_chat";
    
    //PRODUCT VIEW
    public static let ASSETS_VIEW = "assets_view";
    
    public static let ACCOUNT_VIEW = "account_view";
    public static let ACCOUNT_NEW = "account_new";
    public static let ACCOUNT_BALANCES = "account_balances";
    public static let ACCOUNT_EXCEL = "account_excel";
    public static let ACCOUNT_HISTORY = "account_history";
    public static let ACCOUNT_STATEMENT = "account_statement";
    public static let ACCOUNT_TO_CLOSE = "account_toClose";
    public static let ACCOUNT_PAYMENT = "account_payment";
    public static let ACCOUNT_TRANSFER = "account_transfer";
    public static let ACCOUNT_INTERNATIONAL_TRANSFER = "account_international_transfer"
    public static let ACCOUNT_PAYMENT_LIST = "account_payment_list"
    public static let ACCOUNT_EDIT = "account_edit"
    
    public static let DEPOSITS_VIEW = "deposits_view";
    public static let DEPOSITS_NEW = "deposits_new";
    //SHOW CLOSED
    public static let DEPOSITS_CLOSED = "deposits_closed";
    public static let DEPOSITS_BALANCES = "deposits_balances";
    public static let DEPOSITS_STATEMENT = "deposits_statement";
    public static let DEPOSITS_CREDIT = "deposits_credit";
    public static let DEPOSITS_EDIT = "deposits_edit";
    public static let DEPOSITS_HISTORY = "deposits_history";
    public static let DEPOSITS_CLOSE = "deposits_close";
    public static let DEPOSITS_HIDE = "deposits_hide";
    public static let DEPOSITS_PAYMENT = "deposits_payment";
    public static let DEPOSITS_TRANSFER = "deposits_transfer";
    public static let DEPOSITS_EARLY_TERMINATION = "deposits_early_termination"
    public static let DEPOSITS_PARTIAL_WITHDRAW = "deposits_partial_withdraw"
    
    // CREDITS
    public static let CREDITS_VIEW = "credits_view";
    public static let CREDITS_CLOSED = "credits_closed";
    public static let CREDITS_BALANCES = "credits_balances";
    public static let CREDITS_NEW = "credits_new";
    public static let CREDITS_HISTORY = "credits_history";
    public static let CREDITS_STATEMENT = "credits_statement";
    public static let CREDITS_CLOSE = "credits_close";
    public static let CREDITS_PAYMENT = "credits_payment";
    public static let CREDITS_HIDE = "credits_hide";
    public static let CREDITS_EDIT = "credits_edit";
    public static let LOAN_STATEMENT_VIEW = "loan_statement_view";
    
    // GUARANTEES
    public static let GUARANTEES_NEW = "guarantees_new" // Новый договор
    public static let GUARANTEES_VIEW = "guarantees_view" // Просмотр
    public static let GUARANTEES_CLOSED = "guarantees_closed" // Показать закрытые
    public static let GUARANTEES_SCHEDULE = "guarantees_schedule" // График
    public static let GUARANTEES_BALANCES = "guarantees_balances"
    public static let GUARANTEES_EDIT = "guarantees_edit"
    public static let GUARANTEES_HIDE = "guarantees_hide"
    
    // CURRENCY CONTRACTS
    public static let CURRENCY_CONTRACTS_NEW = "currency_contracts_new"
    public static let CURRENCY_CONTRACTS_VIEW = "currency_contracts_view"
    public static let CURRENCY_CONTRACTS_CLOSED = "currency_contracts_closed"
    public static let CURRENCY_CONTRACTS_BALANCES = "currency_contracts_balances"
    public static let CURRENCY_CONTRACTS_EDIT = "currency_contracts_edit"
    public static let CURRENCY_CONTRACTS_HIDE = "currency_contracts_hide"
    public static let CURRENCY_CONTRACTS_INT_TRANSFER = "currency_contracts_int_transfers" // Переводы в валюте
    public static let CURRENCY_CONTRACTS_INT_CONVERSION = "currency_contracts_convertion" // Конвертация
    public static let CURRENCY_CONTRACTS_INT_SEND_REQUISITES = "curr_contrcts_send_requisites" // Отправить реквизиты
    public static let CURRENCY_CONTRACTS_INT_OPERATIONS = "curr_contrcts_view_operations" // Просмотр операции
    
    public static  let DOCUMENTS_VIEW = "finOperations_view";
    public static  let DOCUMENTS_WORKFLOW_ACTIONS = "workflow_actions";
    
    public static  let  OTHER_OPERATION_VIEW = "otherOperations_view";
    
    public static  let  EXPOSE_ORDER_VIEW = "exposedorders_view";
    public static  let  EXPOSE_ORDER_ADD = "exposedorders_add";
    public static  let  EXPOSE_ORDER_EDIT = "exposedorders_edit";
    
    public static  let  DOC_SIGN_VIEW = "docsSign_view";
    
    public static  let  REFUNDS_ADD = "refunds_add";
    public static  let  REFUNDS_VIEW = "refunds_view";
    
    public static  let  RETURNS_VIEW = "reversals_view";
    
    public static  let  INFO_AND_SUGGESTIONS_VIEW = "infoAndSuggestions_view";
    
    public static  let  PERSONAL_VIEW = "personal";
    
    public static  let  EXCHANGER_RATE_VIEW = "exchangeRate_view";
    
    public static  let  STATEMENT_VIEW = "statement_view";
    
    public static  let  MESSAGE_VIEW = "message_view";
    public static  let  MESSAGE_ADD = "message_add";
    public static  let  MESSAGE_SENT = "message_sent";
    public static  let  MESSAGE_REPLY = "message_reply";
    
    public static  let  DEMAND_VIEW = "demand_applications_view";
    public static  let  DEMAND_ADD = "demand_add";
    public static  let  DEMAND_EDIT = "demand_edit";
    
    public static  let  PERSONAL_HISTORY_VIEW = "history_view";
    public static  let  PERSONAL_HISTORY_EXCEL = "history_excel";
    
    // HANDBOOKS (справочники)
    public static  let  HANDBOOKS_VIEW = "handbooks_view";
    public static  let  COMMON_HANDBOOK_VIEW = "commonHandbooks_view";
    public static  let  USER_HANDBOOK = "userHandbooks_view";
    
    // Contribution transfer
    public static let DOMPAYMENTS_LIST_PRINT = "dompayments_list_print"
    public static let DOMPAYMENTS_LIST_HISTORY = "dompayments_list_history"
    public static let DOMPAYMENTS_LIST_CREATE_COPY = "dompayments_list_create_copy"
    public static let DOMPAYMENTS_RETURN_REVISION = "dompayments_return_revision"
    public static let DOMPAYMENTS_LIST_DELETE = "dompayments_list_delete"
    
    // Domestic transfer
    public static let DOMESTIC_HISTORY = "payments_history"
    public static let DOMESTIC_PRINT = "payments_print"
    public static let DOMESTIC_CREATE_COPY = "payments_create_copy"
    public static let DOMESTIC_VIEW = "payments_view"
    public static let DOMESTIC_ADD = "payments_add"
    public static let DOMESTIC_EDIT = "payments_edit"
    public static let DOMESTIC_RETURN_REVISION = "payments_return_revision"
    public static let DOMESTIC_DELETE = "payments_delete"
    
    // Conversion
    public static let ACCOUNT_CONVERSION = "account_conversion" //Общая доступность конвертации
    public static let CONVERSION_PRINT =  "conversion_print"
    public static let CONVERSION_HISTORY = "conversion_history"
    public static let CONVERSION_VIEW = "conversion_view"
    public static let CONVERSION_DELETE = "conversion_delete"
    public static let CONVERSION_EDIT = "conversion_edit"
    public static let CONVERSION_RETURN_REVISION = "conversion_return_revision" //Вернуть на доработку
    public static let CONVERSION_CREATE_COPY = "conversion_create_copy"
    public static let CONVERSION_ADD = "conversion_add"
    
    // International transfer
    public static let INT_TRANSFERS_DELETE = "int_transfers_delete"
    public static let INT_TRANSFERS_PRINT = "int_transfers_print"
    public static let INT_TRANSFERS_EDIT = "int_transfers_edit"
    public static let INT_TRANSFERS_ADD = "int_transfers_add"
    public static let INT_TRANSFERS_RETURN_REVISION = "int_transfers_return_revision"
    public static let INT_TRANSFERS_HISTORY = "int_transfers_history"
    public static let INT_TRANSFERS_COPY = "int_transfers_create_copy"
    public static let INT_TRANSFERS_VIEW = "int_transfers_view"
    
    // Internal transfer
    public static let INTERNAL_TRANSFER_RETURN_REVISION = "transfers_return_revision"
    public static let INTERNAL_TRANSFER_VIEW = "transfers_view"
    public static let INTERNAL_TRANSFER_HISTORY = "transfers_history"
    public static let INTERNAL_TRANSFER_DELETE = "transfers_delete"
    public static let INTERNAL_TRANSFER_EDIT = "transfers_edit"
    public static let INTERNAL_TRANSFER_COPY = "transfers_create_copy"
    public static let INTERNAL_TRANSFER_PRINT = "transfers_print"
    public static let INTERNAL_TRANSFER_ADD = "transfers_add"
    
    
    // Standing orders
    public static let STANDING_ORDERS_EDIT = "standing_orders_edit"
    public static let STANDING_ORDERS_DELETE = "standing_orders_delete"
    public static let STANDING_ORDERS_RESUME = "standing_orders_resume" //Активировать
    public static let STANDING_ORDERS_VIEW_DETAIL = "standing_orders_view_detail"
    public static let STANDING_ORDERS_SUSPEND = "standing_orders_suspend" //Приостановить
    public static let STANDING_ORDERS_HISTORY = "standing_orders_history"
    public static let STANDING_ORDERS_VIEW = "standing_orders_view"
    
    // CORPARATIVE CARDS
    public static let CORPCARDS_STATEMENT = "corpCards_statement"
    public static let CORPCARDS_CREDIT = "corpCards_credit"
    public static let CORPCARDS_EDIT = "corpCards_edit"
    public static let CORPCARDS_TRANSFER = "corpCards_transfer"
    public static let CORPCARDS_HISTORY = "corpCards_history"
    public static let CORPCARDS_CLOSED = "corpCards_closed"
    public static let CORPCARDS_VIEW = "corpCards_view"
    public static let CORPCARDS_BALANCE = "corpCards_balance"
    public static let CORPCARDS_REISS = "corpCards_reiss"
    public static let CORPCARDS_NEW = "corpCards_new"
    public static let CORPCARDS_BLOCKED_DETAILS = "corpCards_blocked_details"
    public static let CORPCARDS_BLOCK = "corpCards_block"
    public static let COORPCARDS_CHANGE_LIMITS = "corpCards_change_limits"
    public static let COORPCARDS_RESTRICTIONS = "corpCards_restrictions"
    
    // Payment service
    public static let PAYMENT_SERVICE_ADD = "payment_service_add"
    public static let PAYMENT_SERVICE_VIEW = "payment_service_view"
    public static let PAYMENT_SERVICE_EDIT = "payment_service_edit"
    
    // Invoices
    public static let INVOICES_ADD = "invoices_add"
    public static let INVOICES_EDIT = "invoices_edit"
    public static let INVOICES_PRINT = "invoices_print"
    public static let INVOICES_VIEW = "invoices_view"
    public static let INVOICES_HISTORY = "invoices_history"
    public static let INVOICES_DELETE = "invoices_delete"
    public static let INVOICES_CREATE_COPY = "invoices_create_copy"
    
    // Invoice
    public static let INVOICE_VIEW = "invoice_view";
    public static let INVOICE_PAY = "invoice_pay";
    
    public static let TASKS_VIEW = "tasks_view"
    public static let CUSTOMER = "customer"
    
    // Tranches
    public static let CREDITS_ISSUANCE_TRANCHE = "credits_issuance_tranche"
    
    // FX
    public static let FX_VIEW = "fx_view"
    public static let FX_NEW = "fx_new"
    public static let FX_EDIT = "fx_edit"
}
