//
//  SelectionModalController.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 7/15/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import UIKit


class SelectionModalController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var okButton: UIButton!
    
    // indicate, if need to display general selection header
    public var allHeaderVisible = false
    
    public var singleSelection = false
    
    
    //DESC: Need to pass outside, will be called, controller finished dismis
    public var didFinishPresentationBlock: ((_ sender: UIButton, _ states: [SelectionType]?) -> ())?
    public var models: [SelectionType]? {
        didSet {
            self.setupHeadeView()
            models.map({ _ in self.tableView.reloadData() })
        }
    }
    
    var header: CheckBoxCell? {
        return self.tableView.tableHeaderView as? CheckBoxCell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialConfig()
    }
    
    //MARK: Actions
    
    @IBAction func okButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.didFinishPresentationBlock.map({ $0(sender, self.models) })
        }
    }
    
    @IBAction func dimissPressed(_ sender:Any){
        self.dismiss(animated: true) {}
    }
    
    //MARK: private
    
    private func initialConfig() {
        self.tableView.registerCell(withClass: CheckBoxCell.self)
        self.header?.checkBox.isChecked = self.isAllSelected()
    }
    
    public func isAllSelected() -> Bool {
        let states: [Bool] = (self.models?.compactMap({ $0.isChecked })) ?? []
        let allSelected = states.reduce(true, {$0 && $1})
        return allSelected
    }
    
    public func deselectAll() {
        guard let models = self.models else { return }
        for var model in models {
            model.isChecked = false
        }
        self.tableView.reloadData()
    }
    
    private func setupHeadeView() {
        guard allHeaderVisible, let models = self.models, !models.isEmpty else { return }
        let header = UINib.view(CheckBoxCell.self)
        header?.nameLabel.text = "Выбрать все"
        let state = self.isAllSelected()
        header?.checkBox.isChecked = state
        header?.checkBoxBlock = { [weak self] checkBox in
            guard let strongSelf = self else { return }
            let allChecked: Bool = !checkBox.isChecked
            
            for var model in (strongSelf.models) ?? [] {
                model.isChecked = allChecked
            }
            
            strongSelf.tableView.reloadData()
        }
        
        self.tableView.tableHeaderView = header
    }
    
    //MARK: UITableViewDelegate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.models?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(cls: CheckBoxCell.self, indexPath: indexPath)
        var state = (self.models?[indexPath.row])!
        cell.filleWithModel(state)
        cell.checkBoxBlock = { [] chechBox in
            let isChecked = chechBox.isChecked
            if self.singleSelection {
                self.deselectAll()
            }
            state.isChecked = !isChecked
            let isAllChecked = self.isAllSelected()
            self.header?.checkBox.isChecked = isAllChecked
        }
        
        return cell
    }
    
    // all rows for selection have standart height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
}

