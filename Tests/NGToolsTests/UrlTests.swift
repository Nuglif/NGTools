//
//  UrlTests.swift
//  NGToolsTests
//
//  Created by Fournier, Olivier on 2021-01-14.
//  Copyright © 2021 Nuglif. All rights reserved.
//

import Foundation
import XCTest

@testable import NGTools

final class UrlTests: XCTestCase {

    func testUrlEncoding() {
        let value1 = "!#$%&'()*+,/:;=?@[ ]".encoded
        let expectedValue1 = "%21%23%24%25%26%27%28%29%2A%2B%2C%2F%3A%3B%3D%3F%40%5B%20%5D"

        XCTAssertTrue(value1 == expectedValue1)

        let value2 = "abcdefghijklmnopqrstuvwxyz0123456789".encoded
        let expectedValue2 = "abcdefghijklmnopqrstuvwxyz0123456789"

        XCTAssertTrue(value2 == expectedValue2)
    }

    func testUrlComponentsWithParams() {
        let baseUrl = "https://testhost.com?other1=value1&cust_params=\("key1=value1&key2=value2&key5=".encoded)&other2=value2&other3="
        let expectedComponents = URLComponents(string: "https://testhost.com?cust_params=\("key1=value1&key2=value2&key3=value3&key4=value4&key5=".encoded)&other1=value1&other2=value2&other3=")
        let parameters: [String: Any] = ["key3": "value3", "key4": "value4"]

        let components = baseUrl.integrate(parameters)

        XCTAssertTrue(components == expectedComponents)
    }

    func testUrlComponentsWithoutParams() {
        let baseUrl = "https://testhost.com"
        let parameters: [String: Any] = ["key3": "value3", "key4": "value4"]

        let components = baseUrl.integrate(parameters)
        let expectedComponents = URLComponents(string: "https://testhost.com?cust_params=\("key3=value3&key4=value4".encoded)")

        XCTAssertTrue(components == expectedComponents)
    }

    func testUrlComponentsWithArray() {
        let baseUrl = "https://testhost.com?cust_params=\("key1=value1&key2=value2".encoded)"
        let parameters: [String: Any] = ["key3": ["v1", true, 99], "key4": "value4"]

        let components = baseUrl.integrate(parameters)
        let expectedComponents = URLComponents(string: "https://testhost.com?cust_params=\("key1=value1&key2=value2&key3=v1,true,99&key4=value4".encoded)")

        XCTAssertTrue(components == expectedComponents)
    }

    // swiftlint:disable line_length
    func testUrlComponentsWithAdTagUrl() {
        let baseUrl =
            """
            https://pubads.g.doubleclick.net/gampad/ads?gdfp_req=1&env=vp&unviewed_position_start=1&sz=640x480&iu=%2F21686484267%2FLPM%2FLPM_Sports&ad_rule=1&cust_params=typePage%3Darticle%26articleId%3D4a0c93a9ef8a3efdab0b7a345ecc59fe%26suptitle%3Dsports-illustrated%26publicationDate%3D2020-12-06%26microtheme%3Dcoronavirus%26sectionName%3Dfootball%26videoDuration%3Dvideo31-60&hl=fr&output=vast
            """
        let expectedUrl =
            """
            https://pubads.g.doubleclick.net/gampad/ads?ad_rule=1&cust_params=articleId%3D4a0c93a9ef8a3efdab0b7a345ecc59fe%26key1%3Dvalue1%26key2%3Dvalue2%26microtheme%3Dcoronavirus%26publicationDate%3D2020-12-06%26sectionName%3Dfootball%26suptitle%3Dsports-illustrated%26typePage%3Darticle%26videoDuration%3Dvideo31-60&env=vp&gdfp_req=1&hl=fr&iu=%2F21686484267%2FLPM%2FLPM_Sports&output=vast&sz=640x480&unviewed_position_start=1
            """
        let parameters: [String: Any] = ["key1": "value1", "key2": "value2"]
        let components = baseUrl.integrate(parameters)

        XCTAssertTrue(components?.url?.absoluteString == expectedUrl)
    }
}

// MARK: - String (private)
private extension String {

    var encoded: String { urlEncoded! }

    func integrate(_ parameters: [String: Any]) -> URLComponents? {
        return URL(string: self)?.integrate(parameters: parameters, into: "cust_params")
    }
}
