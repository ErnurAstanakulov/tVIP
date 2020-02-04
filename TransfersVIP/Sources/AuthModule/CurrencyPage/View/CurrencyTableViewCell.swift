//
//  CurrencyTableViewCell.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/12/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell, ReusableView {
    
    private var stackView = UIStackView()
    
    private var currencyView = UIView()
    private var currencyStackView = UIStackView()
    private var currencyIconImageView = UIImageView()
    private var currencyTitleLabel = UILabel()
    
    private var ratePurchaseLabel = UILabel()
    private var rateSaleLabel = UILabel()
    private var rateNationalLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initialize()
    }
    
    private func initialize() {
        setupViews()
    }
    
    public func set(currencyItem: CurrencyItem) {
        currencyIconImageView.image = CurrencyImage.getBy(isoCode: currencyItem.isoCode)?.toCircle()
        currencyTitleLabel.text = currencyItem.isoCode
        ratePurchaseLabel.text = currencyItem.ratePurchase
        rateSaleLabel.text = currencyItem.rateSale
        rateNationalLabel.text = currencyItem.rateNational
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        currencyIconImageView.image = nil
        currencyTitleLabel.text = nil
        ratePurchaseLabel.text = nil
        rateSaleLabel.text = nil
        rateNationalLabel.text = nil
    }
}

extension CurrencyTableViewCell: ViewInitalizationProtocol {
    func addSubviews() {
        addSubview(stackView)
        
        stackView.addArrangedSubview(currencyView)
        stackView.addArrangedSubview(ratePurchaseLabel)
        stackView.addArrangedSubview(rateSaleLabel)
        stackView.addArrangedSubview(rateNationalLabel)
        
        currencyView.addSubview(currencyStackView)
        currencyStackView.addArrangedSubview(currencyIconImageView)
        currencyStackView.addArrangedSubview(currencyTitleLabel)
    }
    
    func setupConstraints() {
        stackView.addConstaintsToVertical()
        stackView.addConstaintsToHorizontal(padding: 8)
        
        currencyStackView.translatesAutoresizingMaskIntoConstraints = false
        currencyStackView.centerXAnchor.constraint(equalTo: currencyView.centerXAnchor).isActive = true
        currencyStackView.centerYAnchor.constraint(equalTo: currencyView.centerYAnchor).isActive = true
        
        currencyIconImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        currencyIconImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func stylizeViews() {
        selectionStyle = .none
        backgroundColor = .clear
        
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        currencyStackView.axis = .horizontal
        currencyStackView.alignment = .center
        currencyStackView.distribution = .equalSpacing
        currencyStackView.spacing = 8
        
        currencyTitleLabel.textColor = .black
        currencyTitleLabel.font = AppFont.regular.uiFont
        
        ratePurchaseLabel.textAlignment = .center
        ratePurchaseLabel.textColor = AppColor.gray.uiColor
        ratePurchaseLabel.font = AppFont.regular.with(size: 14)
        
        rateSaleLabel.textAlignment = .center
        rateSaleLabel.textColor = AppColor.gray.uiColor
        rateSaleLabel.font = AppFont.regular.with(size: 14)
        
        rateNationalLabel.textAlignment = .center
        rateNationalLabel.textColor = AppColor.gray.uiColor
        rateNationalLabel.font = AppFont.regular.with(size: 14)
    }
}
