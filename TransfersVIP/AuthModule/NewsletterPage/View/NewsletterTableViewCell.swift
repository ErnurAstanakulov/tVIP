//
//  NewsletterTableViewCell.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/15/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

class NewsletterTableViewCell: UITableViewCell, ReusableView {
    
    private var stackView = UIStackView()
    
    private var dateLabel = UILabel()
    private var titleLabel = UILabel()
    private var moreTitleLabel = UILabel()
    
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

extension NewsletterTableViewCell: ViewInitalizationProtocol {
    func addSubviews() {
        addSubview(stackView)
        
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(moreTitleLabel)
    }
    
    func setupConstraints() {
        stackView.addConstaintsToVertical(padding: 7)
        stackView.addConstaintsToHorizontal(padding: 25)
    }
    
    func stylizeViews() {
        backgroundColor = .clear
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        
        dateLabel.textAlignment = .left
        dateLabel.textColor = AppColor.dark.uiColor
        dateLabel.font = AppFont.light.with(size: 10)
        
        titleLabel.textColor = AppColor.dark.uiColor
        titleLabel.font = AppFont.regular.with(size: 14)
        titleLabel.numberOfLines = 2
        
        moreTitleLabel.textAlignment = .right
        moreTitleLabel.text = "Подробнее"
        moreTitleLabel.textColor = AppColor.dark.uiColor
        moreTitleLabel.font = AppFont.light.with(size: 10)
    }
}
