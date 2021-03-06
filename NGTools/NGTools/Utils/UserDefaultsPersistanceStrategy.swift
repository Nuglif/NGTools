//
//  UserDefaultsPersistanceStrategy.swift
//  La Presse+
//
//  Created by Condor, Judith on 2021-02-02.
//  Copyright © 2021 Nuglif. All rights reserved.
//

import Foundation

public final class UserDefaultsPersistanceStrategy: PersistanceStrategy {

    private let userDefaults: UserDefaults

    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    public func persist<T>(_ object: T, key: String) where T: Codable {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(object) else { return }

        userDefaults.set(data, forKey: key)
    }

    public func retrieve<T>(for key: String) -> T? where T: Codable {
        guard let data = userDefaults.data(forKey: key) else { return nil }

        let decoder = JSONDecoder()
        let record = try? decoder.decode(T.self, from: data)

        return record
    }

    public func remove(for key: String) {
        userDefaults.removeObject(forKey: key)
    }
}
