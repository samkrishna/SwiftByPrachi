//
//  OrValidator.swift
//  AssignmentTwo
//
//  Created by Sam Krishna on 2/16/22.
//

import Foundation

struct OrValidator<Value> : Validator {
    let childValidator: [AnyValidator<Value>]

    init<Child>(_ childValidator: Child) where Child : Validator, Child.Value == Value {
        self.childValidator = [AnyValidator(childValidator)]
    }

    func validate(_ value: Value) -> Bool {
        let validatedValues: [Bool] = childValidator.map { (validator) in
            validator.validate(value)
        }

        return validatedValues.filter{$0 == true}.count > 0
    }
}
