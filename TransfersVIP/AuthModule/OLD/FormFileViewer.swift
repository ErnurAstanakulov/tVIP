//
//  FormFileViewer.swift
//  DigitalBank
//
//  Created by Vlad on 02.08.17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import UIKit
import Alamofire

class FormFileViewer: NSObject {
    typealias SuccessfulLoaded = (_ result: Any) ->()
    typealias LoadingError = (_ error: Error?) -> ()

    fileprivate var file: ServerFormFile
    fileprivate var apiUrl: String
    fileprivate var presenter: UIViewController
    fileprivate var docInteractionController: UIDocumentInteractionController?

    init(file: ServerFormFile, apiUrl: String, presenter: UIViewController) {
        self.file = file
        self.apiUrl = apiUrl
        self.presenter = presenter
    }
    
    func downloadFile(isSuccsess: @escaping SuccessfulLoaded, ifFailed: LoadingError? = nil) {
        let fileId = file.id!
        let fileName = file.name
        
        let URLString = baseURL + apiUrl + String(format: "%d", fileId)
        
        sessionManager
            .download(URLString, method: .post) { (_, _) in
                var documentsURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
                documentsURL.appendPathComponent(fileName)
                return (documentsURL, [.removePreviousFile, .createIntermediateDirectories])
            }.responseData { [weak self] (downloadResponse) in
                guard let result = downloadResponse.result.value else {
                    ifFailed.map { $0(downloadResponse.result.error) }
                    return
                }
                isSuccsess(result)
                guard let destinationURL = downloadResponse.destinationURL else { return }
                self?.presentPreview(url: destinationURL)
        }
    }
    
    func presentPreview(url: URL) {
        let docInteractionController = UIDocumentInteractionController(url: url)
        docInteractionController.delegate = self
        if !docInteractionController.presentPreview(animated: true) {
            let alert = UIAlertController.presentSimpleError(title: "Ошибка",
                                                             message: "Не удалось открыть файл: \(url.lastPathComponent)\nФайл не поддерживается системой")
            presenter.present(alert, animated: true)
        }
        self.docInteractionController = docInteractionController
    }
}

extension FormFileViewer: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return presenter
    }
}
