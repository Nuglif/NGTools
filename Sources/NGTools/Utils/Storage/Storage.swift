//
//  Storage.swift
//  NGTools
//
//  Created by Olivier Fournier on 2023-08-14.
//  Copyright © 2023 Nuglif. All rights reserved.
//

import Foundation

public protocol CodableStorage {

    func get<V: Codable>(_ key: Key<V>) -> V?
    func set<V: Codable>(_ value: V?, for key: Key<V>)
}

@objc
public protocol BasicStorage: AnyObject {

    @objc
    func object(forKey key: String) -> Any?

    @objc
    func set(_ value: Any?, forKey key: String)
}
