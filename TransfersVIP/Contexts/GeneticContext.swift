//
//  GeneticContext.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 7/13/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

class GenericContext<T> {
    public enum LoadingType {
        case void
        case any
        case anyDict
        case singleModel
        //case modelsList
    }
    
    typealias LoadingSuccessful = (_ result: T?) ->()
    typealias LoadingFailed = (_ error: RxRequstError?) -> ()
    
    public var controller: UIViewController? = nil
    public var model: AnyObject? = nil
    
    deinit {
        self.request = nil
    }
    
    private var loadingType: LoadingType
    
    //If new requst -> kill old requst,
    private var request: DataRequest? {
        willSet(newRequest) {
            request?.cancel()
            newRequest?.resume()
        }
    }
    
    public init(type: LoadingType) {
        self.loadingType = type
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
    
    public func cancel() {
        self.request = nil
    }
    
    //MARK: Public
    public func execute(ifSuccsess: @escaping LoadingSuccessful, ifFailed: LoadingFailed? = nil) {
        self.load(isSuccsess: ifSuccsess, ifFailed: ifFailed)
    }
    
    //MARK: Serializations will be on main thread
    func load(isSuccsess: @escaping LoadingSuccessful, ifFailed: LoadingFailed? = nil) {
        let request = sessionManager.request(urlString(),
                                             method: HTTPMethod(),
                                             parameters: parametres(),
                                             encoding: encoding(),
                                             headers: HTTPHeaders())
        
        //result value can be nil
        let validateRequest = request.validate()
        self.request = validateRequest
        
        validateRequest.responseJSON { [weak self] (serverInfo) in
            //DESC: if no responce -> interner conection error
            guard let strongSelf = self, let responceInfo = serverInfo.response else {
                ifFailed.map({ $0(RxRequstError.unknown) })
                return
            }
            
            //DESC: case for bad status code or if no result
            let statusCode = responceInfo.statusCode
            let resultValue = serverInfo.result.value // map be nil 
            guard 200..<300 ~= statusCode else {
                let error = RxRequstError.httpRequestFailed(response: responceInfo, statusCode: statusCode)
                ifFailed.map({ $0(error) })
                return
            }
            
            //handling responce
            switch strongSelf.loadingType {
            case .void:
                isSuccsess(nil)
            case .any:
                guard let result = resultValue as? T else {
                    ifFailed.map({ $0(RxRequstError.deserializationError(responceValue: resultValue)) })
                    return
                }
            
                isSuccsess(result)
                
            case .anyDict:
                guard let json = resultValue as? AnyDict, let result = json as? T else {
                    ifFailed.map({ $0(RxRequstError.deserializationError(responceValue: resultValue)) })
                    return
                }
                
                isSuccsess(result)
                
            case .singleModel:
                //if json valid, if generic type conform object mapping protocol, if model can be generated
                guard let json = resultValue as? AnyDict,
                      let TMappable = T.self as? Mappable.Type
                    else {
                        ifFailed.map({ $0(RxRequstError.deserializationError(responceValue: resultValue)) })
                        return
                }

                guard let model = TMappable.init(JSON: json, context: nil) as? T else { return }
                isSuccsess(model)
                
//            case .modelsList:
//                break
//                print(T.self) // Array<NotificationModel>
//                print(Array.Element.Type)
//                
//                let TArrat = T.self as! Array<Mappable.Type>
                
//                guard let resultJson = resultValue as? AnyDict,
//                    let rows = resultJson["rows"] as? [AnyDict],
//                    let TArray = T.self as? Array<Mappable.Type>.Type
//                    else {я
//                        ifFailed.map({ $0(RxRequstError.deserializationError(responceValue: resultValue)) })
//                        return
//                }
//                TArray.Element
//                print(TMappable)
//                let TMappable = T.self as? Mappable.Type
                
//                let modelList = rows.flatMap({ (json) -> T in
//                    let map = Map(mappingType: .fromJSON, JSON: json)
//                    return TArray.self.init(map: map) as! T
//                })
//           
//                print(modelList)
//                rows.forEach({
//                    let map = Map(mappingType: .fromJSON, JSON: $0)
//                    TArray.append(&<#T##Array<Mappable>#>)
//                })
            }
        }
    }
}
