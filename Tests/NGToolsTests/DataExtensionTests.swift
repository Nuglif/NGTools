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
        let deviceTokenByteArray: [UInt8] = [66, 9, 171, 63, 201, 240, 114, 162, 137, 42, 39, 201, 116, 172, 205, 43, 20, 165, 127, 212, 219, 9, 150, 30, 84, 241, 72, 13, 92, 238, 65, 79]

        let deviceTokenData = Data(bytes: deviceTokenByteArray, count: deviceTokenByteArray.count)
        let expectedValue = "4209ab3fc9f072a2892a27c974accd2b14a57fd4db09961e54f1480d5cee414f"

        XCTAssertTrue(deviceTokenData.toHexadecimal() == expectedValue)
        XCTAssertEqual(deviceTokenData.toHexadecimal(), expectedValue)
    }
}
