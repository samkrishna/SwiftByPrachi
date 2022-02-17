//
//  NotValidator.swift
//  AssignmentTwo
//
//  Created by Sam Krishna on 2/16/22.
//

import Foundation

struct NotValidator<Value> : Validator {
    let childValidator: AnyValidator<Value>

    init<Child>(_ childValidator: Child) where Child : Validator, Child.Value == Value {
        self.childValidator = AnyValidator(childValidator)
    }

    func validate(_ value: Value) -> Bool {
        return !childValidator.validate(value)
    }
}
