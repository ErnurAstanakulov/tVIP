//
//  ProfileOrganizationInteractor.swift
//  TransfersVIP
//
//  Created by psuser on 10/17/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol ProfileOrganizationInteractorInput {
    func getOrganizations(searchText: ControlProperty<String>)
}

class ProfileOrganizationInteractor: ProfileOrganizationInteractorInput {
    
    private let disposeBag = DisposeBag()
    private let presenter: ProfileOrganizationPresenterInput
    private let networkService: NetworkService
    public var sourceOrganizations = BehaviorRelay(value: [Organization]())

    lazy var dispatchQueue: ConcurrentDispatchQueueScheduler = {
        let queue = DispatchQueue.global(qos: .default)
        return ConcurrentDispatchQueueScheduler.init(queue: queue)
    }()

    init(networkService: NetworkService, presenter: ProfileOrganizationPresenterInput) {
        self.networkService = networkService
        self.presenter = presenter
    }
    
    private func filter(organazitons: [Organization], serchText: String) -> [Organization] {
        return organazitons.filter { organization in
            guard !serchText.isEmpty else { return true }
            let filter = serchText.lowercased()
            guard let name = organization.name?.lowercased() else { return false }
            guard let bin = organization.bin?.lowercased() else { return false }
            
            return name.contains(filter) || bin.contains(filter)
        }
    }
    
    
    func getOrganizations(searchText: ControlProperty<String>) {
        
        let textObservable = searchText.asDriver()
            .throttle(.milliseconds(300))
            .asObservable()
        
        Observable.combineLatest(textObservable, loadOrganizations()) { (serchText, organizations) -> [Organization] in
                return self.filter(organazitons: organizations, serchText: serchText)
            }
            .subscribeOn(MainScheduler.asyncInstance)
            .observeOn(self.dispatchQueue)
            .asDriver(onErrorJustReturn: [])
            .drive(sourceOrganizations)
            .disposed(by: disposeBag)
        
        presenter.setOrganizations(sourceOrganizations.asObservable())
    }
}

extension ProfileOrganizationInteractor {
    
    private func loadOrganizations() -> Observable<[Organization]> {
        
        return Observable<[Organization]>.create { (observer) -> Disposable in
            let networkContext = LoadPersonalAuthNetworkContext()
            let task = self.networkService.load(quene: DispatchQueue.main, context: networkContext, completion: { [] (networkResponse) in
                guard let response: PageableResponse<Organization> = networkResponse.decode(), networkResponse.isSuccess else {
                    observer.onError(RxRequstError.unknown)
                    return
                }
                observer.onNext(response.rows)
                observer.onCompleted()
            })
            
            task?.resume()
            return Disposables.create {
                task?.cancel()
            }
        }
    }
}
