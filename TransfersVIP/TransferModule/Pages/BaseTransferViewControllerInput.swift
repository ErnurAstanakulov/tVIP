//
//  BaseTransferViewControllerInput.swift
//  TransfersVIP
//
//  Created by psuser on 10/1/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

protocol BaseTransferViewControllerInput: class {
    var interactor: BaseSetTransferInteractorInput? { get }
    var router: TransferRouterInput? { get }
    func setAlertTableViewByCells(isDraft: Bool, message: String)
    func setErrorMessage(message: String?)
    func performActionWithClose(shouldUpdateAccounts: Bool)
    func setTemplateAlert(existTemplateName: String?)
}
extension BaseTransferViewControllerInput where Self: OperationsTableViewController {
    
    func performActionWithClose(shouldUpdateAccounts: Bool) {
        self.navigationController?.popViewController(animated: true)
        if shouldUpdateAccounts {
            AppState.sharedInstance.shouldUpdateAccounts = true
        }
    }
    
    func setAlertTableViewByCells(isDraft: Bool, message: String) {
        self.reloadTableViewByCells()
        let alertControl = UIAlertController(
            title: "Внимание",
            message: message,
            preferredStyle: .alert
        )
        
        let saveAlertAction = UIAlertAction(title: "Сохранить", style: .default) { [weak self] _ in
            isDraft ? self?.interactor?.saveDocument() : self?.interactor?.saveDocumentAsRoughCopy()
        }
        alertControl.addAction(UIAlertAction.init(title: "Закрыть", style: .cancel))
        alertControl.addAction(saveAlertAction)
        self.present(alertControl, animated: true, completion: nil)
    }
    
    func setErrorMessage(message: String?) {
        self.reloadTableViewByCells()
        self.presentErrorController(title: "Ошибка", message: message)
    }
    
    func setTemplateAlert(existTemplateName: String?) {
        let alertController = UIAlertController(title: "Наименование шаблона", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Введите текст"
            textField.text = existTemplateName
        }
        
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { [unowned self] action in
            let templateName = alertController.textFields?.first?.text
            self.interactor?.setTemplateName(name: templateName)
        }
        alertController.addAction(saveAction)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}
