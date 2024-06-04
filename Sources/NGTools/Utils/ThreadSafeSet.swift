//
//  File.swift
//  
//
//  Created by Jeanne Creantor, N'rick (Ordinateur) on 2024-06-04.
//

import Foundation

public class ThreadSafeSet<T: Hashable> {
    private var set: Set<T> = []
    private let queue = DispatchQueue(label: "com.nuglif.safeThreadSet.\(T.self)", attributes: .concurrent)

    public init(set: Set<T> = []) {
        self.set = set
    }

    public func insert(_ newElement: T) {
        queue.async(flags: .barrier) {
            self.set.insert(newElement)
        }
    }

    public func remove(_ member: T) {
        queue.async(flags: .barrier) {
            self.set.remove(member)
        }
    }

    public func removeAll() {
        queue.async(flags: .barrier) {
            self.set.removeAll()
        }
    }

    public func contains(_ member: T) -> Bool {
        queue.sync { set.contains(member) }
    }

    public func first(where predicate: (T) -> Bool) -> T? {
        queue.sync { set.first(where: predicate) }
    }
}

