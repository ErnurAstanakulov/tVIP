//
//  NewsletterDetailHeaderTableViewCell.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/15/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

class NewsletterDetailHeaderTableViewCell: UITableViewCell, ReusableView {
    private var stackView = UIStackView()
    private var dateLabel = UILabel()
    private var titleLabel = UILabel()
    
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
        dateLabel.text = newsletterItem.date
        titleLabel.text = newsletterItem.title
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        dateLabel.text = nil
        titleLabel.text = nil
    }
}

extension NewsletterDetailHeaderTableViewCell: ViewInitalizationProtocol {
    func addSubviews() {
        addSubview(stackView)
        
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(titleLabel)
    }
    
    func setupConstraints() {
        stackView.addConstaintsToVertical(padding: 11)
        stackView.addConstaintsToHorizontal(padding: 25)
    }
    
    func stylizeViews() {
        backgroundColor = AppColor.green.uiColor.withAlphaComponent(0.1)
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        dateLabel.font = AppFont.light.with(size: 10)
        dateLabel.textColor = AppColor.dark.uiColor
        
        titleLabel.font = AppFont.regular.with(size: 16)
        titleLabel.textColor = AppColor.dark.uiColor
        titleLabel.numberOfLines = 0
    }
}
