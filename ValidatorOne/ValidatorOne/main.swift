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
        if let _ = value.range(of: substring, options: options, locale: locale) {
            return true
        }
        else {
            return false;
        }
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
