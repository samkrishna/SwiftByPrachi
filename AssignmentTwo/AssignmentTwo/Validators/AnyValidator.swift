//
//  AnyValidator.swift
//  AssignmentTwo
//
//  Created by Sam Krishna on 2/16/22.
//

import Foundation

protocol Validator {
    associatedtype Value
    func validate(_ value: Value) -> Bool
}

/// A type-erased validator.
///
/// The `AnyValidator` type forwards `Validator` operations to an underlying validator, hiding its specific underlying type. This can be useful when you
/// need to store references to one or more validators with a specific value type,
/// but you don't care about the validator types themselves.
struct AnyValidator<Value> : Validator {
    /// A private box base class that is generic on the underlying validator's
    /// `ValidatedValue` type.
    ///
    /// By being generic on the underlying validator's value type, we can erase
    /// its original type, but cannot use it. As such, no instances of `BoxBase`
    /// are ever created. It exists only so that we can reference the original validator
    /// using only its generic type parameters. To actually use it, we need a `Box`.
    private class BoxBase<BoxValue> : Validator {
        typealias ValidatedValue = BoxValue

        func validate(_ value: BoxValue) -> Bool {
            fatalError("Subclasses must override this method")
        }
    }

    /// A private subclass of our base box class that is generic on the
    /// underlying validator's type.
    ///
    /// This type is generic on the underlying validator's type as opposed to its
    /// `ValidatedValue` type. This allows us to actually use the validator.
    private class Box<BoxedValidator> : BoxBase<BoxedValidator.Value>
    where BoxedValidator : Validator {
        /// The box's base object.
        let base: BoxedValidator

        /// Initializes a `Box` with the specified base.
        ///
        /// - Parameter base: The base object this box contains.
        init(_ base: BoxedValidator) {
            self.base = base
        }

        override func validate(_ value: BoxedValidator.Value) -> Bool {
            return base.validate(value)
        }
    }

    /// The type-erased box in which we will store our underlying validator.
    ///
    /// While this property is defined as a `BoxBase` instance, it will only
    /// ever be a `Box`. This allows us to define `AnyValidator` as a generic on
    /// the validator's `ValidatedValue` type instead of the underlying validator's type,
    /// which we're creating.
    private let box: BoxBase<Value>

    /// Create a new `AnyValidator` instance with the specified underlying validator.
    ///
    /// - Parameter base: The underlying validator that the instance wraps.
    init<BoxedValidator>(_ base: BoxedValidator)
    where BoxedValidator : Validator, BoxedValidator.Value == Value {
        self.box = Box(base)
    }

    func validate(_ value: Value) -> Bool {
        return box.validate(value)
    }
}
