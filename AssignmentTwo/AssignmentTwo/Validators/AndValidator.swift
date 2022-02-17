//
//  AndValidator.swift
//  AssignmentTwo
//
//  Created by Sam Krishna on 2/16/22.
//

import Foundation

struct AndValidator<Value> : Validator {
    let children: [AnyValidator<Value>]

    init<Child>(_ childValidator: Child) where Child : Validator, Child.Value == Value {
        self.children = [AnyValidator(childValidator)]
    }

    func validate(_ value: Value) -> Bool {
        let validatedValues: [Bool] = children.map { (validator) in
            validator.validate(value)
        }

        return validatedValues.filter{$0 == true}.count == children.count
    }
}
