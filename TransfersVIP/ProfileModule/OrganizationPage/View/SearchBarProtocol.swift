//
//  SearchBarProtocol.swift
//  TransfersVIP
//
//  Created by psuser on 10/16/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import Foundation

protocol SearchBarProtocol where Self: UIView {
    var searchBar: UISearchBar { get }
}

extension SearchBarProtocol {
    
    func setupSearchBarView() {
        addSearchBarSubviews()
        setupSearchBarConstraints()
        stylizeSearchBar()
        makeTransparent()
    }
    
    func addSearchBarSubviews() {
        addSubview(searchBar)
    }
    
    func setupSearchBarConstraints() {
        searchBar.addConstaintsToHorizontal(padding: 25)
        searchBar.addConstaintsToVertical(padding: 15)
    }
    
    private func makeTransparent() {
        searchBar.decorator.apply(Style.round())
        searchBar.subviews.forEach { $0.backgroundColor = .clear; $0.decorator.apply(Style.round()); $0.subviews.forEach { $0.backgroundColor = .clear }}
    }
    
    func stylizeSearchBar() {
        guard let searchBarTextField: UITextField = searchBar.subviews[0].subviews.last as? UITextField else { return }
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        imageView.contentMode = .scaleAspectFit
        imageView.image = AppImage.search.uiImage
        let innerView = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        innerView.addSubview(imageView)
        searchBarTextField.rightViewMode = UITextField.ViewMode.always
        searchBarTextField.leftViewMode = UITextField.ViewMode.never
        searchBarTextField.rightView = innerView
        searchBarTextField.leftView = nil
        searchBarTextField.placeholder = "Поиск по организации"
        searchBarTextField.textAlignment = .left
        searchBarTextField.font = AppFont.regular.with(size: 14)
        searchBarTextField.textColor = AppColor.gray.uiColor
        searchBarTextField.decorator.apply(Style.round())
        searchBar.layoutIfNeeded()
        searchBarTextField.backgroundColor = AppColor.lightGray.uiColor
    }
    
}
