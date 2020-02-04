//
//  PaymentsRevokeDetailContext.swift
//  DigitalBank
//
//  Created by Alex Vovkotrub on 14.08.17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class PaymentsRevokeDetailContext: Context {
    
    var id: Int!
    
    override func urlString() -> String {
        return baseURL + "api/customer/documents/document-withdraw/" + String(id)
    }
}

class PaymentsRevokesDocToWithdrawContext: Context{
    
    var id: Int!
    
    override func urlString() -> String {
        return baseURL + "/api/customer/documents/document-withdraw/doc-to-withdraw/" + String(id)
    }
    
}

class PaymentsRevokeDetailContextByType: Context{
    
    var code: String!
    
    override func parametres() -> [String : Any]? {
        return ["docType": code ?? ""]
    }
    override func urlString() -> String {
        return baseURL + "/api/customer/documents/by-doctype?"
    }
}

class PaymentsRevokesDetailPersonsContext: Context{
    override func urlString() -> String {
        return baseURL + "/api/customer/documents/get-sorted-persons"
    }
}

class PaymentsRevokePostContext: Context { // FIXME: Doesn`t work properly, should put data into httpBody
    var id: Int!
    var data: PaymentsRevokeDetailToSend!
    
    override func urlString() -> String {
        return baseURL + "api/customer/documents/document-withdraw/" + String(id)
    }
    
    override func HTTPHeaders() -> [String : String]? {
        return ["content-type":"application/json"]
    }
    
    override func load(isSuccsess: @escaping Context.SuccessfulLoaded, ifFailed: Context.LoadingError?) {
        var request = URLRequest(url: URL(string: urlString())!)
        request.allHTTPHeaderFields = HTTPHeaders()
        request.httpBody = try? JSONSerialization.data(withJSONObject: data.toJSON())
        request.httpMethod = "POST"
        let validateRequest = sessionManager.request(request).validate()
        validateRequest.responseJSON { (serverResponse) in
            guard let result = serverResponse.result.value else {
                ifFailed.map { $0(serverResponse.result.error) }
                return
            }
            
            isSuccsess(result)
        }
    }
    
}

class PaymentsRevokePostNewContext: Context{
    var data: PaymentsRevokeDetailToSend!
    
    override func HTTPMethod() -> HTTPMethod {
        return .post
    }
    
    override func urlString() -> String {
        return baseURL + "api/customer/documents/document-withdraw/new"
    }
    
    override func HTTPHeaders() -> [String : String]? {
        return ["content-type":"application/json"]
    }
    
    override func load(isSuccsess: @escaping Context.SuccessfulLoaded, ifFailed: Context.LoadingError?) {
        var request = URLRequest(url: URL(string: urlString())!)
        request.allHTTPHeaderFields = HTTPHeaders()
        request.httpBody = try? JSONSerialization.data(withJSONObject: data.toJSON())
        request.httpMethod = "POST"
        let validateRequest = sessionManager.request(request).validate()
        validateRequest.responseJSON { (serverResponse) in
            guard let result = serverResponse.result.value else {
                ifFailed.map { $0(serverResponse.result.error) }
                return
            }
            
            isSuccsess(result)
        }
    }
    
}

class CodeByDocumentTypeContext: Context {
    override func urlString() -> String {
        return baseURL + "/api/codes/doc-withdraw/by/DocumentType"
    }
}

class CodeByDocumentType: BaseModel {
    var deleted: Bool?
    var category: String?
    var code: String?
    var label: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        deleted <- map["deleted"]
        category <- map["category"]
        code <- map["code"]
        label <- map["label"]
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
}




