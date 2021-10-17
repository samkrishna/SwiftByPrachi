//
//  main.swift
//  ValidatorOne
//
//  Created by Sam Krishna on 10/17/21.
//

import Foundation

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

struct CharacterSetValidator : Validator {
    let disallowedCharSet: CharacterSet

    func validate(_ value: String) -> Bool {
        let stringSet = CharacterSet(charactersIn: value)
        let intersection = disallowedCharSet.intersection(stringSet)
        return intersection.isEmpty
    }
}

struct ContainsSubstringValidator : Validator {
    let substring: String
    let options: String.CompareOptions
    let locale: Locale?

    func validate(_ value: String) -> Bool {
        // From Prachi: Usually if you’ve got a if { return} you should use guard instead
        return value.range(of: substring, options: options, locale: locale) != nil
    }
}

// struct Thing<S, T> where S : Collection and T.Element == Int
// as a way of thinking about types
struct InSetValidator<T: Hashable>: Validator {
    let allowedValues: Set<T>

    func validate(_ value: T) -> Bool {
        return allowedValues.contains(value)
    }
}

let ccv = CharacterCountValidator(range: 1...10)
var trueOutcome = ccv.validate("yes")
var falseOutcome = ccv.validate("hell no this shouldn\'t validate")

print("true outcome is \(trueOutcome)")
print("false outcome is \(falseOutcome)")

let csv = CharacterSetValidator(disallowedCharSet: CharacterSet(charactersIn: "abcde"))

let trueCharSet = "fghij"
let falseCharSet = "abc"

print("character set validation for \(trueCharSet) is \(csv.validate(trueCharSet))")
print("character set validation for \(falseCharSet) is \(csv.validate(falseCharSet))")

let cssv = ContainsSubstringValidator(substring: "test", options: String.CompareOptions.caseInsensitive, locale: nil)

let trueContainsWord = "This is a test"
let falseContainsWord = "This is not a dog"

print("Contains word for \(trueContainsWord) is:  \(cssv.validate(trueContainsWord))")
print("Contains word for \(falseContainsWord) is:  \(cssv.validate(falseContainsWord))")

let isv = InSetValidator(allowedValues: [112, 114, 115, 118, 116])

let trueSetMember = 114
let falseSetMember = 120

print("Contains member for \(trueSetMember) is:  \(isv.validate(trueSetMember))")
print("Contains word for \(falseSetMember) is:  \(isv.validate(falseSetMember))")

