//
//  NetworkService.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 6/27/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation
import Alamofire
import RxCocoa
import RxSwift

protocol NetworkService {
    @discardableResult
    func load(context: NetworkContext, completion: @escaping (NetworkResponse) -> Void) -> CancelableRequest?
    func load<T: Decodable>(context: NetworkContext, completion: @escaping (_ result: Result<T>) -> Void)
    func download(context: NetworkContext, nameOfFile: String, completion: @escaping (NetworkResponse) -> Void)
    func load(quene: DispatchQueue, context: NetworkContext, completion: @escaping (NetworkResponse) -> Void) -> CancelableRequest?

//    func load<T: Decodable>(context: NetworkContext, _ completion: @escaping (NetworkResponse) -> Void) -> Observable<T>
}
