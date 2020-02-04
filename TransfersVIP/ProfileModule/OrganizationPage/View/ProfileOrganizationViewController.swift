//
//  ProfileOrganizationViewController.swift
//  TransfersVIP
//
//  Created by psuser on 10/11/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

protocol ProfileOrganizationViewInput: BaseViewInputProtocol {
    func setOrganizations(_ organizations: Observable<[Organization]>)
}

class ProfileOrganizationViewController: BaseViewController, ProfilePagesProtocol {
    
    private let disposeBag = DisposeBag()
    
    var page: ProfilePages = .organization
    
    private var tableView = UITableView()
    private var headerView = SearchBarHeaderView()
    private lazy var refreshControl = UIRefreshControl()

    
    var router: ProfileOrganizationRouterInput?
    var interactor: ProfileOrganizationInteractorInput?
    
    public var sourceOrganizations = BehaviorRelay(value: [Organization]())

    override func loadView() {
        super.loadView()
        setupViews()
        activeTapGestureOnView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.getOrganizations(searchText: headerView.searchBar.rx.text.orEmpty)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        headerView.setSearchBar()
    }
}

extension ProfileOrganizationViewController: UISearchBarDelegate { }

extension ProfileOrganizationViewController: ProfileOrganizationViewInput {
    
    func setOrganizations(_ organizations: Observable<[Organization]>) {
        organizations.do (
            onError: { error in
                self.refreshControl.endRefreshing()
        },onCompleted: {
                self.refreshControl.beginRefreshing()
        }).bind(to: sourceOrganizations)
        .disposed(by: disposeBag)
        
        
        sourceOrganizations.asObservable().bind(to:
            self.tableView.rx.items(cellIdentifier: ProfileOrganizationCell.reuseIdentifier, cellType: ProfileOrganizationCell.self)) { (index, organization, cell) in
                cell.fill(organization)
        }.disposed(by: disposeBag)
    }
}

extension ProfileOrganizationViewController: ViewInitalizationProtocol {
    
    func addSubviews() {
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView.addConstaintsToFill()
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 64)
    }
    
    func stylizeViews() {

        headerView.searchBar.delegate = self
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.rowAutoHeight(estimatedRowHeight: 58)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 58
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView()
    }
    
    func extraTasks() {
        tableView.register(ProfileOrganizationCell.self, forCellReuseIdentifier: ProfileOrganizationCell.reuseIdentifier)
        tableView.registerHeader(withClass: SearchBarHeaderView.self)
    }
    
}

extension ProfileOrganizationViewController: UITableViewDelegate {
}

extension ProfileOrganizationViewController {
    fileprivate func activeTapGestureOnView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(_ :)))
        self.view.addGestureRecognizer(gesture)
    }
    
    @objc func tapGestureAction(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}
