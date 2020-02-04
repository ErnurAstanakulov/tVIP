//
//  ViewInitalizationProtocol.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 6/28/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

protocol ViewInitalizationProtocol {
    func addSubviews()
    func setupConstraints()
    func stylizeViews()
    func extraTasks()
}

extension ViewInitalizationProtocol {
    func extraTasks() {}
    
    func setupViews() {
        addSubviews()
        setupConstraints()
        stylizeViews()
        extraTasks()
    }
}

