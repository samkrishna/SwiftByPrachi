//
//  AndValidator.swift
//  AssignmentTwo
//
//  Created by Sam Krishna on 2/16/22.
//

import Foundation

struct AndValidator<Value> : Validator {
    let children: [AnyValidator<Value>]

    init(_ children: [AnyValidator<Value>]) {
        self.children = children
    }

    func validate(_ value: Value) -> Bool {
        return children.first { !$0.validate(value) } == nil
    }
}
