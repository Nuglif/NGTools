//
//  MigrationTaskState.swift
//  NGTools
//
//  Created by Fournier, Olivier on 2022-02-17.
//  Copyright © 2022 Nuglif. All rights reserved.
//

import Foundation

public enum MigrationTaskState {

    case completed
    case error(Error)
    case skipped
}

extension MigrationTaskState: Equatable {

    public static func == (lhs: MigrationTaskState, rhs: MigrationTaskState) -> Bool {
        switch (lhs, rhs) {
        case (.completed, .completed):
            return true
        case (.error(let err1), .error(let err2)):
            return type(of: err1) == type(of: err2)
        case (.skipped, .skipped):
            return true
        default:
            return false
        }
    }
}
