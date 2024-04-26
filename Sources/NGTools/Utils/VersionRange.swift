//
//  VersionRange.swift
//  NGTools
//
//  Created by Delcros, Jean-Baptiste (Ordinateur) on 2024-04-26.
//  Copyright © 2024 Nuglif. All rights reserved.
//

import Foundation

public struct VersionRange: Codable {

    /// Inclusive limit
    var min: String
    /// Exclusive limit
    var max: String?

    public init(min: String, max: String? = nil) {
        self.min = min
        self.max = max
    }

    public func match(version: String) -> Bool {
        return version >= min && version < (max ?? String(Int.max))
    }
}

// MARK: - Private (String)
private extension String {

    static func >= (lhs: String, rhs: String) -> Bool {
        let length = Swift.max(lhs.length, rhs.length)
        let result = lhs.pad(length).compare(rhs.pad(length), options: .numeric)

        return result == .orderedDescending || result == .orderedSame
    }

    static func < (lhs: String, rhs: String) -> Bool {
        let length = Swift.max(lhs.length, rhs.length)
        let result = lhs.pad(length).compare(rhs.pad(length), options: .numeric)

        return result == .orderedAscending
    }

    var length: Int { split(separator: ".").count }

    func pad(_ length: Int) -> String {
        let array = split(separator: ".")
        var values = [Substring](repeating: "0", count: length)

        values.replaceSubrange(0..<array.count, with: array)

        return values.joined(separator: ".")
    }
}
