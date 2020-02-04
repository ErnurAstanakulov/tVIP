//
//  TransferWorkViewController.swift
//  TransfersVIP
//
//  Created by psuser on 31/08/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import UIKit

class TransferWorkViewController: BaseViewController, TransferPagesProtocol {
    var page: Pages {
        return .work
    }
    var iteractor: TransferWorkIteractorInput!
    var router: TransferWorkRouterInput!
    private let tableView = UITableView()
    private var refreshControl = UIRefreshControl()

    private var workDocuments: [TransferProtocol] = []
    var isDataSourceLoaded = false

    override func loadView() {
        super.loadView()
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iteractor.setPage(page: page)
        iteractor.getWorkDocuments()
    }
    
    @objc private func onRefresh() {
        iteractor.pageToLoad = 0
        iteractor.onRefresh()
    }
    
    @objc private func performSelectedDocument(_ sender: UIButton) {
        let id = sender.tag
        let selectedDocument = workDocuments.filter({ $0.id == id })[0]
        iteractor.showAlert(id: id, selectedDocument as! WorkDocumentsModel)
    }
    
    private func show(viewController: UIViewController) {
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: true)
    }
}

extension TransferWorkViewController: TransferWorkViewControllerInput {
   
    func showHistoryViewController(id: Int) {
        router.pushHistoryViewController(id: id)
    }
    
    func setPaymentTransfer(viewModel: OperationViewModel, with title: String) {
        router.pushNewTransfer(viewModel: viewModel, with: title)
    }
    
    func showAlertController(action: [UIAlertAction]) {
        let alertController = UIAlertController()
        alertController.title = "Выберите операцию"
        action.forEach { alertController.addAction($0) }
        let alertAction = UIAlertAction(title: "Отмена", style: .cancel)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func setWorkDocuments(documents: [TransferProtocol]) {
        workDocuments = documents
        finishLoading()
    }
    
    func reloadWorkDocuments() {
        guard isViewLoaded else { return }
        self.isDataSourceLoaded = false
        iteractor.pageToLoad = 0
        iteractor.getWorkDocuments()
    }
    
    private func beginRefreshing() {
        tableView.tableFooterView = getLoadingIndicator(forTableView: tableView)
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
    }
    
    private func finishLoading() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.tableFooterView = nil
        }
    }
    
    private func scrollToFirstRow() {
        guard tableView.numberOfRows(inSection: 0) > 0 else { return }
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }
    
    func showOTPForm(_ canSkip: Bool) {
        let loginOTPViewController = LoginOTPViewController()
        loginOTPViewController.canSkip = canSkip
        loginOTPViewController.delegate = self
        show(viewController: loginOTPViewController)
    }
    
    func showSMSForm(_ canSkip: Bool) {
        let loginSMSViewController = LoginSMSViewController()
        loginSMSViewController.canSkip = canSkip
        loginSMSViewController.delegate = self
        loginSMSViewController.backgroundColor = .white
        show(viewController: loginSMSViewController)
    }
    
}
extension TransferWorkViewController: LoginSMSDelegate {
    func onPressSendButton(_ viewController: LoginSMSViewController) {
        guard let code = viewController.code else { return }
        iteractor.onPassSMS(code)
    }
}

extension TransferWorkViewController: LoginOTPDelegate {
    func onPressSendButton(_ viewController: LoginOTPViewController) {
        iteractor.onPassOTP(viewController.token ?? "")
    }
    
    func onPressSynchronizeButton(_ viewController: LoginOTPViewController) {
        iteractor.synchronizeOTP()
    }
}

extension TransferWorkViewController: ViewInitalizationProtocol {
    func addSubviews() {
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView.addConstaintsToFill()
    }
    
    func stylizeViews() {
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset.left = 25
        tableView.separatorInset.right = 25
    }
    
    func extraTasks() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        tableView.register(TransferWorkCell.self, forCellReuseIdentifier: "TransferWorkCell")
        refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
    }
    
}
extension TransferWorkViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workDocuments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransferWorkCell") as! TransferWorkCell
        let model = workDocuments[indexPath.row]
        cell.fill(model: model as! WorkDocumentsModel)
        cell.pointsButton.addTarget(self, action: #selector(self.performSelectedDocument(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        beginRefreshing()
        iteractor.performPagination(index: indexPath.row)
    }
}
