//
//  ViewInitalizationProtocol.swift
//  TransfersVIP
//
//  Created by psuser on 30/08/2019.
//  Copyright © 2019 psuser. All rights reserved.
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
