//
//  MigrationStore.swift
//  NGTools
//
//  Created by Fournier, Olivier on 2022-02-17.
//  Copyright © 2022 Nuglif. All rights reserved.
//

import Foundation

public protocol MigrationStore {

    func isCompleted(_ action: MigrationTask) -> Bool
    func setCompleted(_ action: MigrationTask)
}

public final class DefaultMigrationStore: MigrationStore {

    private let userDefault: UserDefaults?

    public init(suiteName: String = "ngtools.migration") {
        self.userDefault = UserDefaults(suiteName: suiteName)
    }

    public func isCompleted(_ task: MigrationTask) -> Bool {
        return userDefault?.bool(forKey: task.identifier) ?? false
    }

    public func setCompleted(_ task: MigrationTask) {
        userDefault?.setValue(true, forKey: task.identifier)
    }
}
