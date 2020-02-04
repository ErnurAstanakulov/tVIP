//
//  SearchBarHeaderView.swift
//  TransfersVIP
//
//  Created by psuser on 10/16/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import UIKit

class SearchBarHeaderView: UITableViewHeaderFooterView, SearchBarProtocol {
    
    var searchBar: UISearchBar = UISearchBar()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        commonInit()

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        setSearchBar()
    }
   
    public func setSearchBar() {
        setupSearchBarView()
    }
    
}
