//
//  InputFileOptionComponent.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 8/13/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation
import MobileCoreServices

class InputFileOptionComponent: NSObject {
    
    private weak var viewController: UIViewController?
    private var onChangeData: ((URL) -> ())? = nil
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    public func showDocumentMenu(_ onChangeData: ((URL) -> ())?) {
        self.onChangeData = onChangeData
        
        let importMenu =
            UIDocumentPickerViewController(
                documentTypes: [String(kUTTypePDF),
                                String(kUTTypePNG),
                                String(kUTTypeJPEG)],
                in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        
        self.viewController?.present(importMenu, animated: true, completion: nil)
    }
}


extension InputFileOptionComponent: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let firstUrl = urls.first else {
            return
        }
        onChangeData?(firstUrl)
    }
}
