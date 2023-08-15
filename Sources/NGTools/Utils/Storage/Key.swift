//
//  Key.swift
//  NGTools
//
//  Created by Olivier Fournier on 2023-08-14.
//  Copyright © 2023 Nuglif. All rights reserved.
//

import Foundation

public struct Key<V: Codable> {

    public typealias Value = V
    public private(set) var name: String

    public init(_ name: String) {
        self.name = name
    }
}
