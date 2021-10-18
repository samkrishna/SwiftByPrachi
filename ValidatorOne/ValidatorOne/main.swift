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

// I was close to this one
//
// struct InRangeValidator<RangeExpression> where RangeExpression.Bound == Int : Validator
//
// I can see how the line above is a hot mess syntax-wise
struct InRangeValidator<RangeExpression> : Validator where RangeExpression : Swift.RangeExpression {
    let range: RangeExpression

    // NOTE: Prachi gave me the solution after an hour of head-banging against protocol conformance declaration
    func validate(_ value: RangeExpression.Bound) -> Bool {
        return range.contains(value)
    }
}

/*
 So important points:

 You know that the type you’re validating must be the same as the range. That should tell you immediately that you’ll need a generic type to represent that, but how?

 If you have a protocol with an associated type, you must use a generic for that protocol, otherwise you can’t actually reference an instance of the protocol.

 That’s why we use RangeExpression as a generic type parameter.

 Since that type already has an associated type for its “elements”, we just refer to those rather than create our own type for it.

 One thing I want to emphasize. I don’t think there’s any other solution to the problem

 So once you think it through and map out the relationships between types, the code won’t compile till you have it right

 SK: Ooooohh…. so this is at some level about TYPE relationships?

 PG: It’s all about type relationships
 Every generic and conformance and constraint is relating types

 All of these problems are basically asking you to relate a type (your Validator), to other types (sets, range expressions, etc)

 With range expressions, you need to relate it to two types:

 The range expression and the range expression’s bound

 So when you solve these, think through the type relationships

 And develop an understanding of what tools to use to express the relationships you need
*/

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

