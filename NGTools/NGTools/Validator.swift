//
//  Validator.swift
//  NGTools
//
//  Created by Werck, Ayrton on 2018-11-08.
//  Copyright © 2018 Nuglif. All rights reserved.
//

import Foundation

public struct Untrusted<T> {
    fileprivate let value: T

    public init(_ untrustedValue: T) {
        self.value = untrustedValue
    }
}

public protocol Validator {
    associatedtype T

    func isValid(value: T) -> Bool
}

public extension Validator {
    public func validate(untrusted: Untrusted<T>) -> T? {
        return self.isValid(value: untrusted.value) ? untrusted.value : nil
    }
}

