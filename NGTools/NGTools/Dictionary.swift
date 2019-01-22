//
//  Dictionary.swift
//  NGTools
//
//  Created by Goldschmidt, Jérémy on 2019-01-22.
//  Copyright © 2019 Nuglif. All rights reserved.
//

import Foundation

public extension Dictionary {
    /// Transform all values of a dictionary into a new dictionary with the same keys.
    /// Ignore tranformations that lead to a nil value.
    ///
    /// - Parameter transform: transformation to apply on each values
    /// - Returns: new dictionary with non nil values
    /// - Throws: exception thrown by the transformation
    func compactMapValues<T>(_ transform: (Dictionary<Key, Value>.Value) throws -> T?) rethrows -> Dictionary<Dictionary<Key, Value>.Key, T> {
        return try self.reduce(into: [Dictionary<Key, Value>.Key: T]()) { (result, element) in
            let newValue = try transform(element.value)
            if newValue != nil {
                result[element.key] = newValue
            }
        }
    }
}
