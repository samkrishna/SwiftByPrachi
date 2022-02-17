//
//  OrValidator.swift
//  AssignmentTwo
//
//  Created by Sam Krishna on 2/16/22.
//

import Foundation

struct OrValidator<Value> : Validator {
    let children: [AnyValidator<Value>]

    init(_ children: [AnyValidator<Value>]) {
        self.children = children
    }

    func validate(_ value: Value) -> Bool {
        let validatedValues: [Bool] = children.map { (validator) in
            validator.validate(value)
        }

        return validatedValues.filter{$0 == true}.count > 0
    }
}
