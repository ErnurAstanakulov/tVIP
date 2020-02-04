//
//  ProfileNotificationCell.swift
//  TransfersVIP
//
//  Created by psuser on 10/18/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import UIKit

class NotificationFieldCell: UITableViewCell, ReusableView {
    
    let view = NotificationView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(view)
        setViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setViewConstraints() {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        view.prepareForReuse()
        accessoryType = .none
        selectionStyle = .none
    }
    
    func fill(_ notification: ProfileNotification) {
        view.fill(notification)
    }
    
    func setDelegate(_ delegate: EditButtonDelegate) {
        view.delegate = delegate
    }
}
