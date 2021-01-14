//
//  Array+Extensions.swift
//  NGTools
//
//  Created by Fournier, Olivier on 2018-01-31.
//  Copyright © 2018 Nuglif. All rights reserved.
//

import Foundation

public extension Array {

    static func += (lhs: inout [Element], rhs: Element?) {
        guard let element = rhs else { return }

        lhs.append(element)
    }

    static func += (lhs: inout [Element], rhs: [Element]?) {
        guard let elements = rhs else { return }

        lhs.append(contentsOf: elements)
    }

    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
