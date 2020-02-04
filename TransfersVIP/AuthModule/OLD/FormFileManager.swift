import UIKit
import Alamofire
import RxSwift
import RxCocoa
import ObjectMapper
import MobileCoreServices

protocol FormFile {
    var id: Int? { get set }
    var name: String { get set }
    var size: Double? { get set }
}

struct ServerFormFile: FormFile, Mappable {

    var id: Int?
    var name: String = ""
    var size: Double?
    
    init?(map: Map) {
        if map.JSON["fileId"] == nil || map.JSON["fileName"] == nil {
            return nil
        }
    }
    
    mutating func mapping(map: Map) {
        id <- map["fileId"]
        name <- map["fileName"]
        size <- map["fileSize"]
    }
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

struct LocalFormFile: FormFile {
    var id: Int? = nil
    var name: String
    var size: Double?
    var data: Data
    var mimeType: String
    
    init(name: String, size: Double?, data: Data, mimeType: String) {
        self.name = name
        self.size = size
        self.data = data
        self.mimeType = mimeType
    }
}

class FormFileManager: NSObject {
    typealias SuccessfulLoaded = (_ result: Any) ->()
    typealias LoadingError = (_ error: Error?) -> ()

    var formFiles  = Variable<[FormFile]>([])
    var documentID: String?
    var mimeTypes: [String]?
    var maxFilesSize: Double = 0.0
    
    private var imagePicker: UIImagePickerController!
    fileprivate var fromViewController: UIViewController?
    
    required override init() {
        super.init()
        setupImagePicker()
    }
    
    func setupImagePicker() {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.navigationBar.isTranslucent = false
    }
    
    func showImageDialog(_ fromViewController: UIViewController) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(UIAlertAction(title: "Камера", style: .default, handler: { [unowned self] (action) in
                self.imagePicker.sourceType = .camera
                fromViewController.present(self.imagePicker, animated: true, completion: nil)
            }))
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alertController.addAction(UIAlertAction(title: "Фото галерея", style: .default, handler: {[unowned self] (action) in
                self.imagePicker.sourceType = .photoLibrary
                fromViewController.present(self.imagePicker, animated: true, completion: nil)
            }))
        }
        
        fromViewController.present(alertController, animated: true, completion: nil)
    }
    
    func showDocumentDialog(_ fromViewController: UIViewController) {
        self.fromViewController = fromViewController
        let importMenu = UIDocumentMenuViewController(documentTypes: ["public.data", "public.text", "public.content"], in: .import)
        importMenu.addOption(withTitle: "Фото", image: nil, order: .first) { [weak self] in
            self?.showImageDialog(fromViewController)
        }
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        fromViewController.present(importMenu, animated: true, completion: nil)
    }
    
    func setupMultipartFormData() -> ((MultipartFormData) -> Void) {
        return { [weak self] multipartFormData in
            guard let vc = self, let documentIDData = vc.documentID?.data(using: .utf8) else { return }
            multipartFormData.append(documentIDData, withName: "id")
            
            for file in vc.formFiles.value {
                if let localFile = file as? LocalFormFile {
                    multipartFormData.append( localFile.data,
                                              withName: "files",
                                              fileName: localFile.name,
                                              mimeType: localFile.mimeType)
                    
                } else if let serverFile = file as? ServerFormFile {
                    guard let id = serverFile.id else { continue }
                    let JSONString = String(format: "{\"fileId\":%d}", id)
                    guard let data = JSONString.data(using: .utf8) else { continue }
                    multipartFormData.append(data, withName: "fileAttributes")
                }
            }
        }
    }
    
    func sendFileToServer(url: URL, isSuccsess: @escaping SuccessfulLoaded, ifFailed: LoadingError? = nil) {
        
        let URL = try! URLRequest(url: url, method: .post)
        
        sessionManager.upload(multipartFormData: setupMultipartFormData(),
                              with: URL, encodingCompletion: {
                                encodingResult in
                                switch encodingResult {
                                case .success(let upload, _, _):
                                    upload.responseJSON { serverResponse in
                                        guard let result = serverResponse.result.value else {
                                            ifFailed.map { $0(serverResponse.result.error) }
                                            return
                                        }
                                        isSuccsess(result)
                                    }
                                case .failure(let encodingError):
                                    ifFailed.map { $0(encodingError) }
                                }
        })
    }
    
    public func validateFilesSize() -> Bool {
        let formFiles = self.formFiles.value
        guard formFiles.count > 0 else { return true }
        var totalSize = 0.0
        for file in formFiles {
            totalSize += file.size ?? 0.0
        }
        return totalSize <= maxFilesSize
    }
    
    public func validateFileTypes() -> Bool {
        let formFiles = self.formFiles.value
        guard formFiles.count > 0 else { return true }
        guard let mimeTypes = self.mimeTypes, mimeTypes.count > 0 else { return false }
        var isValide = true
        for file in formFiles {
            guard let localFile = file as? LocalFormFile else { continue }
            if !mimeTypes.contains(localFile.mimeType) {
                isValide = false
            }
        }
        
        return isValide
    }
}

extension FormFileManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        picker.dismiss(animated: true, completion: nil)
        let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage
        
        guard let imgData = image.jpegData(compressionQuality: 0.8) else { return }
        let imageSize = Double(imgData.count) / 1024.0 / 1024.0
        
        let imageName = String(format: "Image_%.0f.jpg", Date.timeIntervalSinceReferenceDate)
        let file = LocalFormFile(name: imageName, size: imageSize, data: imgData, mimeType: "image/jpeg")
        formFiles.value.append(file)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension FormFileManager: UIDocumentMenuDelegate {
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        self.fromViewController!.present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension FormFileManager: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        do {
            let fileData = try Data(contentsOf: url)
            let fileSize = Double(fileData.count) / 1024.0 / 1024.0

            let fileName = url.lastPathComponent
            let pathExtension = url.pathExtension
            
            if !fileName.isEmpty && !pathExtension.isEmpty {
                let mimeType = getMimeType(forPathExtension: pathExtension)
                let file = LocalFormFile(name: fileName, size: fileSize, data: fileData, mimeType: mimeType)
                formFiles.value.append(file)
            }
        } catch {
            print(error)
        }
    }
    
    private func getMimeType(forPathExtension pathExtension: String) -> String {
        if
            let id = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as CFString, nil)?.takeRetainedValue(),
            let contentType = UTTypeCopyPreferredTagWithClass(id, kUTTagClassMIMEType)?.takeRetainedValue()
        {
            return contentType as String
        }
        
        return "application/octet-stream"
    }
}

extension FormFileManager: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self.fromViewController!
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
