//
//  VersionRangeTests.swift
//  NGToolsTests
//
//  Created by Delcros, Jean-Baptiste (Ordinateur) on 2024-04-26.
//  Copyright © 2024 Nuglif. All rights reserved.
//

import XCTest

@testable import NGTools

final class VersionRangeTests: XCTestCase {

    let fixRange = VersionRange(min: "1.0.0", max: "2.0.0")
    let openRange = VersionRange(min: "1.9")

    func testMatchingFixRange() {
        XCTAssertTrue(fixRange.match(version: "1"))
        XCTAssertTrue(fixRange.match(version: "1.0"))
        XCTAssertTrue(fixRange.match(version: "1.0.0"))
        XCTAssertTrue(fixRange.match(version: "1.0.0b"))
        XCTAssertTrue(fixRange.match(version: "1.100"))
        XCTAssertTrue(fixRange.match(version: "1.99.99.99"))
    }

    func testMatchingOpenRange() {
        XCTAssertTrue(openRange.match(version: "2"))
        XCTAssertTrue(openRange.match(version: "1.9"))
        XCTAssertTrue(openRange.match(version: "1.9.0"))
        XCTAssertTrue(openRange.match(version: "50"))
        XCTAssertTrue(openRange.match(version: "50.9.9"))
    }

    func testNotMatchingFixRange() {
        XCTAssertFalse(fixRange.match(version: "0"))
        XCTAssertFalse(fixRange.match(version: "0.9"))
        XCTAssertFalse(fixRange.match(version: "0.9.99"))
        XCTAssertFalse(fixRange.match(version: "2.0.0"))
        XCTAssertFalse(fixRange.match(version: "99.99.99.99"))
    }

    func testNotMatchingOpenRange() {
        XCTAssertFalse(openRange.match(version: "0.10.100"))
        XCTAssertFalse(openRange.match(version: "1.0"))
        XCTAssertFalse(openRange.match(version: "1.0.10"))
    }

    func testNonNumericRanges() {
        let range1 = VersionRange(min: "a.b.c", max: "a.b.d")
        let range2 = VersionRange(min: "1.0", max: "2.0")
        let range3 = VersionRange(min: "", max: "")

        XCTAssertFalse(range1.match(version: "a.b.d"))
        XCTAssertFalse(range1.match(version: "b.c.d"))
        XCTAssertFalse(range1.match(version: "a"))

        XCTAssertFalse(range2.match(version: ""))
        XCTAssertFalse(range2.match(version: "-"))
        XCTAssertFalse(range2.match(version: "a"))

        XCTAssertFalse(range3.match(version: ""))
        XCTAssertFalse(range3.match(version: "-"))
        XCTAssertFalse(range3.match(version: "a.b"))
    }

}
