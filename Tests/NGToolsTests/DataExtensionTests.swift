//
//  DataExtensionTests.swift
//  NGTools
//
//  Created by Condor, Judith on 2022-02-17.
//  Copyright © 2022 Nuglif. All rights reserved.
//

import Foundation
import XCTest

@testable import NGTools

final class DataExtensionTests: XCTestCase {

    func testDatatoHexadecimal() {
        let deviceTokenData = Data("%08x%08x%08x%08x%08x%08x%08x%08x".utf8)
        let expectedValue = "2530387825303878253038782530387825303878253038782530387825303878"

        XCTAssertTrue(deviceTokenData.toHexadecimal() == expectedValue)
    }
}
