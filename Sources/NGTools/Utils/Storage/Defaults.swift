//
//  Defaults.swift
//  NGTools
//
//  Created by Olivier Fournier on 2023-08-11.
//  Copyright © 2023 Nuglif. All rights reserved.
//

import Foundation
import OSLog

@objc
open class Defaults: NSObject {

    public enum Constants {
        public static let defaultName = "_defaults"
    }

    private let backingStore: UserDefaults?
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    private let name: String

    public init(name: String = Constants.defaultName, encoder: JSONEncoder = .init(), decoder: JSONDecoder = .init()) {
        self.name = name
        self.backingStore = UserDefaults(suiteName: name)
        self.encoder = encoder
        self.decoder = decoder

        super.init()
    }
}

// MARK: - CodableStorage
extension Defaults: CodableStorage {

    public func get<V>(_ key: Key<V>) -> V? where V: Codable {
        do {
            if key.isPrimitive {
                return backingStore?.object(forKey: key.name) as? V
            } else if let data = backingStore?.data(forKey: key.name) {
                return try decoder.decode(V.self, from: data)
            } else {
                return nil
            }
        } catch {
            Logger.main.error("Error retreiving object: \(error)")
            return nil
        }

    }

    public func set<V>(_ value: V?, for key: Key<V>) where V: Codable {
        do {
            if key.isPrimitive || value == nil {
                backingStore?.set(value, forKey: key.name)
            } else {
                let data = try encoder.encode(value)
                backingStore?.set(data, forKey: key.name)
            }
        } catch {
            Logger.main.error("Error storing object: \(error)")
        }
    }

    public func reset() {
        UserDefaults.standard.removePersistentDomain(forName: name)
    }
}

// MARK: - Objc
@objc
extension Defaults: BasicStorage {

    @objc
    convenience init(with name: String) {
        self.init(name: name)
    }

    @objc
    open func object(forKey key: String) -> Any? {
        return backingStore?.object(forKey: key)
    }

    @objc
    open func set(_ value: Any?, forKey key: String) {
        backingStore?.set(value, forKey: key)
    }
}

// MARK: - Private
private extension Key {

    var isPrimitive: Bool {
        Value.self == String.self ||
        Value.self == Int.self ||
        Value.self == Double.self ||
        Value.self == Float.self ||
        Value.self == Date.self ||
        Value.self == Bool.self ||
        Value.self == Data.self ||
        Value.self == Array<AnyObject>.self ||
        Value.self == Dictionary<String, AnyObject>.self
    }
}

// MARK: - Private
private extension Logger {
    static let main = Logger(subsystem: "com.nuglif.ngtools", category: "Defaults")
}
