//
//  UserDefaultsPersistanceTests.swift
//  NGToolsTests
//
//  Created by Condor, Judith on 2021-02-15.
//  Copyright © 2021 Nuglif. All rights reserved.
//

import Foundation
import XCTest

@testable import NGTools

final class UserDefaultsPersistanceTests: XCTestCase {

    let persistanceStrategy: UserDefaultsPersistanceStrategy? = UserDefaultsPersistanceStrategy(userDefaults: .init())
    let identifier = "testIdentifier"

    func testAddUserDefault() {
        let record = EventRecord(id: identifier, description: "testDescription")
        persistanceStrategy?.persist(record, key: identifier)

        let expectedUserDefault: EventRecord? = persistanceStrategy?.retrieve(for: identifier)

        XCTAssertNotNil(expectedUserDefault, "UserDefault retrieved shouldn't be nil")
        XCTAssertTrue(record.id == expectedUserDefault?.id)
    }

    func testRemoveUserDefault() {
        let record = EventRecord(id: identifier, description: "testDescription")
        persistanceStrategy?.persist(record, key: identifier)

        let expectedUserDefault: EventRecord? = persistanceStrategy?.retrieve(for: identifier)

        XCTAssertNotNil(expectedUserDefault, "UserDefault retrieved shouldn't be nil")
        XCTAssertTrue(record.id == expectedUserDefault?.id)

        persistanceStrategy?.remove(for: identifier)

        let expectedUserDefaultRemoved: EventRecord? = persistanceStrategy?.retrieve(for: identifier)

        XCTAssertNil(expectedUserDefaultRemoved, "UserDefault retrieved should be nil")
    }
}

// MARK: - UserDefaultsPersistanceTests
private extension UserDefaultsPersistanceTests {

    struct EventRecord {
        let id: String
        let description: String
    }
}

// MARK: - EventRecord: Codable
extension UserDefaultsPersistanceTests.EventRecord: Codable {

    private enum CodingKeys: String, CodingKey {
        case id
        case description
    }
}
