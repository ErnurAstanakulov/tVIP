//
//  TransferWorkCell.swift
//  TransfersVIP
//
//  Created by psuser on 31/08/2019.
//  Copyright © 2019 psuser. All rights reserved.
//

import UIKit

class TransferWorkCell: UITableViewCell {
    
    private var datePeriadLabel = UILabel()
    private var transferTypeLabel = UILabel()
    private var ownerLabel = UILabel()
    private var statusLabel = UILabel()
    private var sumLabel = UILabel()
    private var pointsButton = UIButton()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension TransferWorkCell: ViewInitalizationProtocol {
    func addSubviews() {
        addSubview(datePeriadLabel)
        addSubview(transferTypeLabel)
        addSubview(pointsButton)
        addSubview(ownerLabel)
        addSubview(statusLabel)
        addSubview(sumLabel)
    }
    
    func setupConstraints() {
        var layoutConstraints = [NSLayoutConstraint]()
        datePeriadLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            datePeriadLabel.topAnchor.constraint(equalTo: topAnchor, constant: 19),
            datePeriadLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            datePeriadLabel.trailingAnchor.constraint(equalTo: centerXAnchor)
        ]
        
        transferTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            transferTypeLabel.leadingAnchor.constraint(equalTo: centerXAnchor),
            transferTypeLabel.topAnchor.constraint(equalTo: datePeriadLabel.topAnchor),
            transferTypeLabel.trailingAnchor.constraint(equalTo: pointsButton.leadingAnchor, constant: -8)
        ]
        
        pointsButton.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            pointsButton.widthAnchor.constraint(equalToConstant: 12),
            pointsButton.heightAnchor.constraint(equalToConstant: 24),
            pointsButton.topAnchor.constraint(equalTo: datePeriadLabel.topAnchor),
            pointsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25)
        ]
        
        ownerLabel.addConstaintsToHorizontal(padding: 25)
        layoutConstraints += [
            ownerLabel.topAnchor.constraint(equalTo: datePeriadLabel.bottomAnchor, constant: 7)
        ]
        
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            statusLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            statusLabel.trailingAnchor.constraint(equalTo: centerXAnchor),
            statusLabel.topAnchor.constraint(equalTo: ownerLabel.bottomAnchor, constant: 7)
        ]
        
        sumLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutConstraints += [
            sumLabel.topAnchor.constraint(equalTo: ownerLabel.bottomAnchor, constant: 4),
            sumLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            sumLabel.leadingAnchor.constraint(equalTo: centerXAnchor),
            sumLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25)
        ]
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    func stylizeViews() {
        datePeriadLabel.textColor = .blue
        transferTypeLabel.textColor = .red
        pointsButton.setTitleColor(.black, for: .normal)
        
        ownerLabel.textColor = .green
        sumLabel.textColor = .cyan
        
        statusLabel.textColor = .yellow
    }
    
    
}
