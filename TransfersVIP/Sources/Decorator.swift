//
//  Decorator.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/10/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

typealias Decoration<T> = (T) -> Void

struct Decorator<T> {
    let object: T
    func apply(_ decorators: Decoration<T>...) {
        decorators.forEach { (decoration) in
            decoration(object)
        }
    }
}

protocol DecoratorCompatiable {
    associatedtype DecoratorCompatibleType
    var decorator: Decorator<DecoratorCompatibleType> { get }
}

extension DecoratorCompatiable {
    var decorator: Decorator<Self> {
        return Decorator(object: self)
    }
}

extension UIView: DecoratorCompatiable {}
