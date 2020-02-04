//
//  FileWebViewController.swift
//  DigitalBank
//
//  Created by Vlad on 02.08.17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import UIKit

class FileWebViewController: UIViewController {
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var dismissBarButton: UIBarButtonItem!
    
    var file: ServerFormFile?
    var decodeData: Data?
    
    private var preview: UIDocumentInteractionController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.scalesPageToFit = true
        
        if file != nil {
//            navigationBar.topItem?.title = file!.name <-prev
            navigationBar.topItem?.title = file!.name
//            loadFile()
            testLoad()
        }
        if let decodeData = decodeData {
            webView.load(decodeData, mimeType: "application/pdf", textEncodingName: "utf-8", baseURL: URL(fileURLWithPath: ""))
        }
    }

    func loadFile() {
        let URLString = baseURL + "api/payment/international-transfer/download/" + String(format: "%d", file!.id ?? -1)
        
        let url = URL(string: URLString)
        var urlRequest = URLRequest(url: url!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10)
        
        guard let adapter = sessionManager.adapter as? AppRequestAdapter else {
            return
        }
        
        urlRequest = try! adapter.adapt(urlRequest)
        urlRequest.httpMethod = "POST"
        webView.loadRequest(urlRequest)
    }
    
    
    func testLoad() {
        guard let fileId = file?.id, let fileName = file?.name else { return }
        
        let URLString = baseURL + "api/payment/international-transfer/download/" + String(format: "%d", fileId)

//        sessionManager.download(URLString, method: .post).responseData { [weak self] (downloadResponse) in
//            guard let temporaryURL = downloadResponse.temporaryURL else { return }
//            self?.openFile(url: temporaryURL)
//        }
        
        sessionManager.download(URLString, method: .post) { (_, _) in
            var documentsURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            documentsURL.appendPathComponent(fileName)
            return (documentsURL, [.removePreviousFile, .createIntermediateDirectories])
            }.responseData { [weak self] (downloadResponse) in
                guard let temporaryURL = downloadResponse.destinationURL else { return }
                self?.openFile(url: temporaryURL)
        }
    }
    
    func openFile(url: URL) {
        preview = UIDocumentInteractionController(url: url)
        preview?.delegate = self
        preview?.presentPreview(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func dismissAnimated() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension FileWebViewController: UIWebViewDelegate {
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        guard let urlResponse = URLCache.shared.cachedResponse(for: webView.request!) else { return }
        guard let mimeType = urlResponse.response.mimeType else { return }
        print(mimeType)
    }
}

extension FileWebViewController: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}



//        let downloadRequest = sessionManager.download(URLString) { (_, _) in
//            var documentsURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
//            documentsURL.appendPathComponent(file.name!)
//            return (documentsURL, [.removePreviousFile, .createIntermediateDirectories])
//        }
//        downloadRequest.responseData { [weak self] (response) in
//            print("\(response.destinationURL)")
//            guard let temporaryURL = response.destinationURL else { return }
//
//            UIApplication.shared.openURL(temporaryURL)
////            self?.preview = UIDocumentInteractionController(url: temporaryURL)
////            self?.preview?.delegate = self
////            self?.preview?.presentPreview(animated: true)
//        }
