//
//  main.swift
//  ValidatorOne
//
//  Created by Sam Krishna on 10/17/21.
//

protocol Validator {
    associatedtype ValidatedValue
    func validate(_: ValidatedValue) -> Bool
}

struct CharacterCountValidator : Validator {
    let range: ClosedRange<Int>

    func validate(_ value: String) -> Bool {
        return range.contains(value.count)
    }
}

let ccv = CharacterCountValidator(range: 1...10)
let trueOutcome = ccv.validate("yes")
let falseOutcome = ccv.validate("hell no this shouldn\'t validate")

print("true outcome is \(trueOutcome)")
print("false outcome is \(falseOutcome)")

