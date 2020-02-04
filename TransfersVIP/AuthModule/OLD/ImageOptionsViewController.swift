//
//  ImageOptionsViewController.swift
//  DigitalBank
//
//  Created by Toremurat on 18.10.2018.
//  Copyright © 2018 iosDeveloper. All rights reserved.
//

import UIKit
import RxSwift

class ImageOptionsViewController: UIViewController {
    
    typealias DataSourceCallback = ([OptionDataSource]) -> Void
    private let tableView: UITableView = UITableView()
    private let topShadowView = UIView()
    private let bottomShadowView = UIView()
    private let navBar = UIView()
    private let disposeBag = DisposeBag()
    
    var dataSource: [OptionDataSource] = [] {
        didSet {
            if isViewLoaded {
                tableView.reloadData()
            }
        }
    }
    
    fileprivate(set) var onOptionSelectCallback: ((OptionDataSource?) -> Void)? = nil
    
    var selectedOption: OptionDataSource?
    
    init(dataSource: [OptionDataSource] = [], onOptionSelectCallback: ((OptionDataSource?) -> Void)? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.dataSource = dataSource
        self.onOptionSelectCallback = onOptionSelectCallback
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
      
        view.addSubview(tableView)
        setupNavigationBar(title: "Выберите")
        setupTableView()
        setupConstraints()
    }
    
    func setupNavigationBar(title: String?) {
        view.addSubview(navBar)
//        navBar.backButtonAction = {[unowned self] _ in
//            self.navigationController?.popViewController(animated: false)
//        }
//        navBar.title = title
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.darkGray
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.separatorInset.left = 0
        tableView.keyboardDismissMode = .onDrag
        tableView.register(OptionsImageCell.self, forCellReuseIdentifier: OptionsImageCell.reuseIdentifier)
        
        topShadowView.isUserInteractionEnabled = false
        topShadowView.backgroundColor = UIColor.darkGray
        
        bottomShadowView.isUserInteractionEnabled = false
        bottomShadowView.backgroundColor = .black
    }
    
    private func setupConstraints() {
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        navBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        navBar.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor).isActive = true
        navBar.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
    }
    
}

extension ImageOptionsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = dataSource[indexPath.row]
        self.onOptionSelectCallback?(option)
        navigationController?.popViewController(animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height * 0.35
    }
}

extension ImageOptionsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OptionsImageCell.reuseIdentifier, for: indexPath) as? OptionsImageCell ?? OptionsImageCell()
        let option = dataSource[indexPath.row]
        cell.setupData(option)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
}
//
//  OptionsImageCell.swift
//  DigitalBank
//
//  Created by Toremurat on 18.10.2018.
//  Copyright © 2018 iosDeveloper. All rights reserved.
//

import UIKit

class OptionsImageCell: UITableViewCell {
    
    lazy var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.clipsToBounds = true
        return imgView
    }()
    
    lazy var titleText: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = UIColor.white
        addSubview(imgView)
        addSubview(titleText)
        
        titleText.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        titleText.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        titleText.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        
        imgView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        imgView.bottomAnchor.constraint(equalTo: titleText.topAnchor, constant: -8).isActive = true
        imgView.leftAnchor.constraint(equalTo: titleText.leftAnchor).isActive = true
        imgView.rightAnchor.constraint(equalTo: titleText.rightAnchor).isActive = true
    }
    
    func setupData(_ model: OptionDataSource) {
        titleText.text = model.title
        guard let imagePath = model.description, let imageUrl = URL(string: baseURL + imagePath) else { return }
        sessionManager.request(imageUrl).responseData { response in
            guard let data = response.data else { return }
            DispatchQueue.main.async {
                self.imgView.image = UIImage(data: data)
            }
        }
    }
}

