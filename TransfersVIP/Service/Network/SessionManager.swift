//
//  SessionManager.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 6/27/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Alamofire

let sessionManager: AppSessionMananger = {
    func getServerTrustPolicyManager() -> ServerTrustPolicyManager? {
        let serverTrustPolicy = ServerTrustPolicy.pinPublicKeys(publicKeys: ServerTrustPolicy.publicKeys(), validateCertificateChain: false, validateHost: true)
//        #if TEST || BANKPROD
        let policies = [host: serverTrustPolicy]
//        #else
//        let policies = [host: ServerTrustPolicy.disableEvaluation]
//        #endif
        let serverTrustPolicyManager = ServerTrustPolicyManager(policies: policies)
        return serverTrustPolicyManager
    }
    var lastResponseDateCount = 0.0
    
    let configuration = URLSessionConfiguration.default
    let serverTrustPolicyManager = getServerTrustPolicyManager()
    let sessionManager = AppSessionMananger(configuration: configuration,
                                 serverTrustPolicyManager: serverTrustPolicyManager)
    
    return sessionManager
}()
