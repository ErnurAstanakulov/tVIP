//  OperationComponent.swift
//  DigitalBank
//
//  Created by Алем Утемисов on 06.05.2018.
//  Copyright © 2018 iosDeveloper. All rights reserved.
//

import Foundation

class OperationComponent: Equatable {
    
    let name: String
    let title: String?
    var description: String?
    var placeholder: String?
    let type: ComponentType
    let dependecy: Dependency?
    var constraints: BaseConstraint?
    private(set) var uiProperties: [ComponentUIProperty] {
        didSet {
            isReloadNeeded = true
        }
    }
    private(set) var value: String? {
        didSet {
            isReloadNeeded = true
        }
    }
    var isVisible: Bool = true {
        didSet {
            isReloadNeeded = true
        }
    }
    var errorDescription: String? {
        didSet {
            isReloadNeeded = true
        }
    }
    var isReloadNeeded: Bool = false
    
    init(type: ComponentType, name: String, title: String? = nil, description: String? = nil, placeholder: String? = nil, dependency: Dependency? = nil, constraints: BaseConstraint? = nil, isVisible: Bool = true, value: String? = nil, uiProperties: [ComponentUIProperty] = []) {
        self.type = type
        self.name = name
        self.title = title
        self.description = description
        self.placeholder = placeholder
        self.dependecy = dependency
        self.constraints = constraints
        self.value = value
        self.isVisible = isVisible
        self.uiProperties = uiProperties
    }
    
    func set(uiProperty: ComponentUIProperty) {
        if let index = uiProperties.index (where: { uiProperty.isEqual(property: $0) }) {
            uiProperties[index] = uiProperty
        } else {
            uiProperties.append(uiProperty)
        }
    }
    
    func getValue<T: LosslessStringConvertible>() -> T? {
        guard let value = value else { return nil }
        return T.init(value)
    }
    
    func setValue<T: CustomStringConvertible>(newValue: T?) {
        self.value = newValue?.description
    }
    
    func clearValue() {
        self.value = nil
    }
    
    static func == (lhs: OperationComponent, rhs: OperationComponent) -> Bool {
        return lhs.name == rhs.name
    }
    
}

class Dependency {
    let name: String
    let condition: Condition
    
    init(name: String, condition: Condition) {
        self.name = name
        self.condition = condition
    }
    
    enum Condition: String {
        case calculatable
        case visibility
    }
}

enum ComponentType: String {
    case amount
    case textfield
    case searchTextField
    case options
    case label
    case switcher
    case employees
    case date
    case imageOptions
    case inputFile
}
