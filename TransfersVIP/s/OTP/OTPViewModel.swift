//
//  OTPViewModel.swift
//  Login
//
//  Created by Zhalgas Baibatyr on 26/04/2018.
//

import UIKit
import Alamofire

class OTPViewModel {
    var otpCode: String?
    var previousToken: String?
    var nextToken: String?
    var documentIds: [String]?
    
    private var request: DataRequest? {
        willSet {
            request?.cancel()
        }
    }
    
    func passOTPAuthFactor(onCompletion perform: @escaping (_ success: Bool, _ errorMessage: String?) -> Void) {
        guard let code = otpCode else {
            perform(false, contentErrorMessage)
            return
        }
    
        passOTPAuthFactor(otpToken: code, onCompletion: perform)
    }
    
    private func passOTPAuthFactor(otpToken: String, onCompletion perform: @escaping (_ success: Bool, _ errorMessage: String?) -> Void) {
        guard let customerPersonId = AuthorizationAdapter.shared.customerPersonId,
              let step = AuthorizationAdapter.shared.authFactorResponse?.step else {
            perform(false, contentErrorMessage)
            return
        }
        
        let apiProcessAuthFactorOtpUrl = baseURL + "/api/process-auth-factor/otp"
        let parameters: [String: Any] = [
            "otpToken": otpToken,
            "companyPersonId": customerPersonId,
            "step": step
        ]
        
        request = sessionManager.request(
            apiProcessAuthFactorOtpUrl,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default
        ).responseJSON { dataResponse in
            log(serverResponse: dataResponse)
            switch dataResponse.result {
            case .success:
                // Check if response contains data
                guard let dictionary = dataResponse.result.value as? [String: Any],
                      let success = dictionary["success"] as? Bool else {
                    perform(false, contentErrorMessage)
                    return
                }
                
                guard success else {
                    if let errorMessage = dictionary["errorMessage"] as? String {
                        perform(false, errorMessage)
                    } else {
                        perform(false, contentErrorMessage)
                    }
                    return
                }
                
                AuthorizationAdapter.shared.authFactorResponse = AuthFactorResponse(JSON: dictionary)
                
                perform(true, nil)
            case .failure(let error):
                if let data = dataResponse.data,
                   let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let errorMessage = dict?["errorMessage"] as? String {
                    perform(false, errorMessage)
                } else if let statusCode = dataResponse.response?.statusCode,
                    let message = statusDescription[String(statusCode)] {
                    perform(false, message)
                } else {
                    perform(false, error.localizedDescription)
                }
            }
        }
    }
    
    func syncAndPassOTPAuthFactor(onCompletion perform: @escaping (_ success: Bool, _ errorMessage: String?) -> Void) {
        guard let previousToken = previousToken,
              let nextToken = nextToken else {
            perform(false, contentErrorMessage)
            return
        }
        
        syncAndPassOTPAuthFactor(previousToken: previousToken, nextToken: nextToken, onCompletion: perform)
    }
    
    private func syncAndPassOTPAuthFactor(previousToken: String, nextToken: String, onCompletion perform: @escaping (_ success: Bool, _ errorMessage: String?) -> Void) {
        guard let companyPersonId = AuthorizationAdapter.shared.customerPersonId else {
            perform(false, contentErrorMessage)
            return
        }
        
        let apiProcessAuthFactorHOtpSyncUrl = baseURL + "/api/process-auth-factor/h-otp-sync"
        let parameters: [String: Any] = [
            "previousToken": previousToken,
            "nextToken": nextToken,
            "companyPersonId": companyPersonId,
        ]
        
        request = sessionManager.request(
            apiProcessAuthFactorHOtpSyncUrl,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default            
        ).responseJSON { dataResponse in
            log(serverResponse: dataResponse)
            switch dataResponse.result {
            case .success:
                // Check if response contains data
                guard let dictionary = dataResponse.result.value as? [String: Any],
                    let success = dictionary["success"] as? Bool else {
                        perform(false, contentErrorMessage)
                        return
                }
                
                guard success else {
                    if let errorMessage = dictionary["errorMessage"] as? String {
                        perform(false, errorMessage)
                    } else {
                        perform(false, contentErrorMessage)
                    }
                    return
                }
                
                perform(true, nil)
            case .failure(let error):
                if let data = dataResponse.data,
                   let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let errorMessage = dict?["errorMessage"] as? String {
                    perform(false, errorMessage)
                } else if let statusCode = dataResponse.response?.statusCode,
                    let message = statusDescription[String(statusCode)] {
                    perform(false, message)
                } else {
                    perform(false, error.localizedDescription)
                }
            }
        }
    }
    
    func sendCode(onCompletion perform: @escaping (_ success: Bool, _ errorMessage: String?) -> Void) {
        if let documentIds = documentIds {
            guard !documentIds.isEmpty else { return }
            signDocument(onCompletion: perform)
        } else {
            passOTPAuthFactor(onCompletion: perform)
        }
    }
    
    func signDocument(onCompletion perform: @escaping (_ success: Bool, _ errorMessage: String?) -> Void) {
        guard let ids = documentIds, let code = otpCode else {
            perform(false, contentErrorMessage)
            return
        }
        var apiSigningCheckOTPUrl = "\(baseURL)api/signing/checkOTP"
        apiSigningCheckOTPUrl += "?code=" + code + "&" + "ids=" + ids.joined(separator: "%2C")
        
        request = sessionManager.request(
            apiSigningCheckOTPUrl,
            method: .post            
            ).responseJSON { response in
                log(serverResponse: response)
                if response.response?.statusCode == 200 {
                    perform(true, nil)
                } else {
                    if let value = response.result.value as? [String: Any] {
                        let message = value["value"] as? String
                        perform(false, message)
                    }
                }
        }
    }
}
