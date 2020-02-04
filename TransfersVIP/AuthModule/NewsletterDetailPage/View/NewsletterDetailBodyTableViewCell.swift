//
//  NewsletterDetailBodyTableViewCell.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/15/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

class NewsletterDetailBodyTableViewCell: UITableViewCell, ReusableView {
    private var textView = UITextView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.initilize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initilize()
    }
    
    private func initilize() {
        setupViews()
    }
    
    public func set(newsletterItem: NewsletterItem) {
        textView.text = newsletterItem.description
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        textView.text = nil
    }
}

extension NewsletterDetailBodyTableViewCell: ViewInitalizationProtocol {
    func addSubviews() {
        addSubview(textView)
    }
    
    func setupConstraints() {
        textView.addConstaintsToVertical(padding: 15)
        textView.addConstaintsToHorizontal(padding: 25)
    }
    
    func stylizeViews() {
        backgroundColor = .clear
        
        textView.isEditable = false
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.font = AppFont.regular.with(size: 16)
    }
}
