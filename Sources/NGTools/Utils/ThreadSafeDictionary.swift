//
//  ThreadSafeDictionary.swift
//
//
//  Created by Jeanne Creantor, N'rick (Ordinateur) on 2024-06-20.
//

import Foundation

public class ThreadSafeDictionary<Key: Hashable, Item> {

    private var dictionary: [Key: Item] = [:]

    private let queue = DispatchQueue(label: "com.nuglif.safeThreadDictionary.\(Key.self):\(Item.self)", attributes: .concurrent)

    public init(dictionary: [Key: Item] = [:]) {
        self.dictionary = dictionary
    }

    public func updateValue(_ newElement: Item, for key: Key) {
        queue.async(flags: .barrier) {
            self.dictionary.updateValue(newElement, forKey: key)
        }
    }

    public func removeItem(for key: Key) {
        queue.async(flags: .barrier) {
            self.dictionary.removeValue(forKey: key)
        }
    }

    public func removeAll() {
        queue.async(flags: .barrier) {
            self.dictionary.removeAll()
        }
    }

    public func item(key: Key) -> Item? {
        queue.sync { dictionary[key] }
    }

    public func contains(where predicate: (Key, Item) -> Bool) -> Bool {
        queue.sync {
            self.dictionary.contains(where: predicate)
        }
    }

    public func first(where predicate: (Key, Item) -> Bool) -> (Key, Item)? {
        queue.sync {
            self.dictionary.first(where: predicate)
        }
    }

    public func copy() -> [Key: Item] { queue.sync { dictionary } }
}
