//
//  AbsractContext.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 2/14/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import Alamofire

class Context {
    typealias SuccessfulLoaded = (_ result: Any) ->()
    typealias LoadingError = (_ error: Error?) -> ()
    
    public var controller: UIViewController? = nil
    public var model: AnyObject? = nil
    
    public var request: DataRequest? {
        willSet(newRequest) {
            request?.cancel()
            newRequest?.resume()
        }
    }
    
    public init(controller: UIViewController? = nil, model: AnyObject? = nil) {
        self.controller = controller
        self.model = model
    }
    
    deinit {
        self.request = nil
    }
    
    public func execute(isSuccsess: @escaping SuccessfulLoaded, ifFailed: LoadingError? = nil) {
        self.load(isSuccsess: isSuccsess, ifFailed: ifFailed)
    }
    
    public func cancel() {
        self.request = nil
    }
    
    // !Necessarily for reloaing (by default "")
    public func urlString() -> String {
        return ""
    }
    
    // This function can be reloaded
    public func parametres() -> [String: Any]? {
        return nil
    }
    
    // By default .get, this function can be reloaded
    public func HTTPMethod() -> HTTPMethod {
        return .get
    }
    
    // By default .URLEncoding.default, this function can be reloaded
    public func encoding() -> ParameterEncoding {
       return URLEncoding.default
    }
    
    public func HTTPHeaders() -> [String: String]? {
        return nil
    }
    
    func load(isSuccsess: @escaping SuccessfulLoaded, ifFailed: LoadingError? = nil) {
       let request = sessionManager.request(urlString(), method: HTTPMethod(), parameters: parametres(), encoding: encoding(), headers: HTTPHeaders())
        let validateRequest = request.validate()
        self.request = validateRequest
        validateRequest.responseJSON { (serverResponse) in
            log(serverResponse: serverResponse)
            guard let result = serverResponse.result.value, let statusCode = serverResponse.response?.statusCode, 200..<300 ~= statusCode else {
                ifFailed.map({
                    if let statusCode = serverResponse.response?.statusCode {
                        $0(ContextError.httpRequestAnyFailed(response: serverResponse, statusCode: statusCode))
                    } else {
                        $0(ContextError.unknown)
                    }
                })
                return
            }
            
            isSuccsess(result)
        }
    }
}

public enum ContextError: Error {
    case sessionExpired
    case unknown
    case httpRequestAnyFailed(response: DataResponse<Any>, statusCode: Int)
    case httpRequestStringFailed(response: DataResponse<String>, statusCode: Int)
}

extension ContextError: LocalizedError {
    public var errorDescription: String? {
        func descriptionFor(code: Int, serverError: ServerError? = nil) -> String {
            switch (code, serverError) {
            case (400, let error) where error != nil: return error!.messageForShow()
            case (401, _): return "Неверный логин или пароль"
            case (403, _): return "Ваш профиль удален"
            case (419, _): return "Сессия прервана администратором"
            case (500, _): return "Сервер не отвечает. Попробуйте позже"
            default: return "Ошибка HTTP запроса с кодом `\(code)`."
            }
        }
        
        switch self {
        case .unknown:
            return "Неизвестная ошибка, повторите позднее"
        case .httpRequestAnyFailed(let response, let statusCode):
            return descriptionFor(code: statusCode, serverError: response.getServerError())
        case .httpRequestStringFailed(let response, let statusCode):
            return descriptionFor(code: statusCode, serverError: response.getServerError())
        default:
            return nil
        }
    }
}
