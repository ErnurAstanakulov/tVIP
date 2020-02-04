//
//  RSAManager.swift
//  ForteBankMain
//
//  Created by Zhalgas Baibatyr on 20/04/2018.
//

import Foundation
import Alamofire
import SwiftyRSA

/// Manager that encrypts plain text using RSA algorithm
class RSAManager {
    
    /// Request (pem encoded) public key string from server
    /// then pass object mapped to **PublicKey**
    ///
    /// - Parameter pass: completion handler to pass obtained **PublicKey** object
    static func requestPublicKey(onCompletion pass: @escaping (PublicKey?) -> Void) {
        // Request (pem encoded) public key string to encrypt data
        
        let urlString = baseURL + "api/customer/key"
        sessionManager.request(urlString).responseJSON { response in
            guard let dict = response.result.value as? [String: Any] else {
                NSLog("Problem with " + urlString)
                pass(nil)
                return
            }
            
            /// Get (pem encoded) public key string
            if let publicKeyString = dict["key"] as? String {
                pass(PublicKey.publicKeys(pemEncoded: publicKeyString).first)
            } else {
                NSLog("Dictionary doesn't contain \"key\" key or its value format is not String")
                pass(nil)
                return
            }
            
        }
    }
    
    /// Encrypt plain text using public key
    ///
    /// - Parameters:
    ///   - string: base64 encoded plain text
    ///   - publicKey: **PublicKey** object
    /// - Returns: base64 encoded text or **nil**
    static func encrypt(string: String, using publicKey: PublicKey) -> String? {
        let message = try? ClearMessage(string: string, using: .utf8)
        if let encryptedMessage = try? message?.encrypted(with: publicKey, padding: .PKCS1) {
            return encryptedMessage?.base64String
        }
        
        NSLog("Problem with encryption")
        return nil
    }
}
