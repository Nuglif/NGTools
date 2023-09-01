//
//  DefaultsTests.swift
//  NGTools
//
//  Created by Olivier Fournier on 2023-08-14.
//  Copyright © 2023 Nuglif. All rights reserved.
//

import Foundation
import XCTest

@testable import NGTools

final class DefaultsTests: XCTestCase {

    func testPrimitives() {
        let stringValue = "abcdefghijklmnopqrstuvwxyz_1234567890"
        let doubleValue = 9999.99
        let floatValue: Float = 7777.7
        let intValue = 10
        let dateValue = Date(timeIntervalSince1970: 0)
        let boolValue = true
        let dataValue = "data".data(using: .utf8)!
        let arrayValue = ["a", "b", "c"]
        let dictValue = ["a": "1", "b": "2", "c": "3"]
        let defaults = Defaults()

        defaults.set(stringValue, for: .stringKey)

        XCTAssertEqual(defaults.get(.stringKey), stringValue)

        defaults.set(nil, for: .stringKey)
        defaults.set(doubleValue, for: .doubleKey)
        defaults.set(floatValue, for: .floatKey)
        defaults.set(intValue, for: .intKey)
        defaults.set(dateValue, for: .dateKey)
        defaults.set(boolValue, for: .boolKey)
        defaults.set(dataValue, for: .dataKey)
        defaults.set(arrayValue, for: .arrayKey)
        defaults.set(dictValue, for: .dictionaryKey)

        XCTAssertEqual(defaults.get(.stringKey), nil)
        XCTAssertEqual(defaults.get(.doubleKey), doubleValue)
        XCTAssertEqual(defaults.get(.floatKey), floatValue)
        XCTAssertEqual(defaults.get(.intKey), intValue)
        XCTAssertEqual(defaults.get(.dateKey), dateValue)
        XCTAssertEqual(defaults.get(.boolKey), boolValue)
        XCTAssertEqual(defaults.get(.dataKey), dataValue)
        XCTAssertEqual(defaults.get(.dataKey), dataValue)
        XCTAssertEqual(defaults.get(.arrayKey), arrayValue)
        XCTAssertEqual(defaults.get(.dictionaryKey), dictValue)
    }

    func testCodables() {
        let object = TestObject(p1: "test_string", p2: 56, p3: [.init(p1: "arr1", p2: 1, p3: []), .init(p1: "arr2", p2: 2, p3: [])])
        let defaults = Defaults()

        defaults.set(object, for: .keyCodable)

        XCTAssertEqual(defaults.get(.keyCodable), object)
    }

    func testSuites() {
        let anotherDefaults = Defaults(name: "another_suite")
        let anotherDefaults2 = Defaults(name: "another_suite2")

        anotherDefaults.set(nil, for: .keySuite)
        anotherDefaults2.set("value_123", for: .keySuite)

        XCTAssertEqual(anotherDefaults.get(.keySuite), nil)
        XCTAssertEqual(anotherDefaults2.get(.keySuite), "value_123")
    }

    func testEncoding() {
        let object = TestErrorObject(p1: "test_string")
        let stringValue = "simple_string"
        let defaults = Defaults()

        TestErrorObject.encodingError = true

        defaults.set(stringValue, for: Key<String>("key"))

        // Should not overwrite other object
        defaults.set(object, for: Key("key"))

        XCTAssertEqual(defaults.get(Key<String>("key")), stringValue)
    }

    func testDecoding() {
        let object = TestErrorObject(p1: "test_string")
        let defaults = Defaults()

        defaults.set(object, for: Key("key"))

        TestErrorObject.decodingError = true

        XCTAssertEqual(defaults.get(Key<TestErrorObject>("key")), nil)
    }

    func testMismatch() {
        let defaults = Defaults()
        let keyMismatch1 = Key<String>("keyMismatch")
        let keyMismatch2 = Key<Double>("keyMismatch")
        let keyMismatch3 = Key<Bool>("keyMismatch")

        defaults.set("simple_string", for: keyMismatch1)

        XCTAssertEqual(defaults.get(keyMismatch2), nil)
        XCTAssertEqual(defaults.get(keyMismatch3), nil)
    }

    func testDictionary() {
        let defaults = Defaults()
        let dict1: [String: Any] = [ "key1": Date(timeIntervalSinceNow: 0),
                                     "key2": "string",
                                     "key3": true ]

        defaults.set(dict1, forKey: "key")

        let dict2 = defaults.object(forKey: "key") as! [String: Any]

        XCTAssertEqual(dict2.count, 3)
        XCTAssertEqual(dict2["key1"] as? Date, dict1["key1"] as? Date)
        XCTAssertEqual(dict2["key2"] as? String, dict1["key2"] as? String)
        XCTAssertEqual(dict2["key3"] as? Bool, dict1["key3"] as? Bool)
    }

    func testArray() {
        let defaults = Defaults()
        let array1: [String] = [ "value1", "value2", "value3" ]

        defaults.set(array1, forKey: "key")

        let array2 = defaults.object(forKey: "key") as! [String]

        XCTAssertEqual(array2.count, 3)
        XCTAssertEqual(array2[0], array1[0])
        XCTAssertEqual(array2[1], array1[1])
        XCTAssertEqual(array2[2], array1[2])
    }
}

extension Key {

    static var stringKey: Key<String> { .init("stringKey") }
    static var doubleKey: Key<Double> { .init("doubleKey") }
    static var floatKey: Key<Float> { .init("floatKey") }
    static var intKey: Key<Int> { .init("intKey") }
    static var dateKey: Key<Date> { .init("dateKey") }
    static var boolKey: Key<Bool> { .init("boolKey") }
    static var dataKey: Key<Data> { .init("dataKey") }
    static var arrayKey: Key<[String]> { .init("arrayKey") }
    static var dictionaryKey: Key<[String: String]> { .init("dictionaryKey") }
    static var keyCodable: Key<TestObject> { .init("keyCodable") }
    static var keySuite: Key<String> { .init("keySuite") }
    static var keyError: Key<String> { .init("keyError") }
}

struct TestObject: Codable, Equatable {
    var p1: String
    var p2: Int
    var p3: [TestObject]
}

struct TestErrorObject: Codable, Equatable {
    enum TestEncodingObjectError: Error {
        case encodingError
        case decodingError
    }

    enum CodingKeys: CodingKey {
        case p1
    }

    static var encodingError = false
    static var decodingError = false

    var p1: String

    init(p1: String) {
        self.p1 = p1
    }

    init(from decoder: Decoder) throws {
        guard !Self.decodingError else { throw TestEncodingObjectError.decodingError }

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.p1 = try container.decode(String.self, forKey: .p1)
    }

    func encode(to encoder: Encoder) throws {
        guard !Self.encodingError else { throw TestEncodingObjectError.encodingError }

        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.p1, forKey: .p1)
    }
}
