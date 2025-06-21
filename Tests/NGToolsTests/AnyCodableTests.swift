//
//  AnyCodableTests.swift
//  NGTools
//
//  Created by Lambert, Romain (Ordinateur) on 2025-06-20.
//  Copyright © 2025 Nuglif. All rights reserved.
//

import XCTest

@testable import NGTools

final class AnyCodableTests: XCTestCase {

    func testDecodeDictionaryFromJSON() throws {
        let json = """
        {
            "data": {
                "bool": true,
                "int": 44,
                "double": 2.5,
                "string": "lorem",
                "simpleDictionary": {
                    "key": "ipsum"
                },
                "complexDictionary": {
                    "subDict": {
                         "key": "value"
                    },
                    "key": "value"
                },
                "array": [1, 2, 3],
                "arrayOfArrays": [[1,2,3], ["a","b","c"]],
                "list": [1, "two", true, { "key": "value" }, [1, 2], null],
                "null": null
            }
        }
        """.data(using: .utf8)!

        let result = try JSONDecoder().decode(Wrapper.self, from: json)
        validateContentOf(result.data)
    }

    func testEncodeDictionaryToJSON() throws {
        let dict: [String: Any] = [
            "int": 44,
            "string": "lorem",
            "bool": true,
            "simpleDictionary": ["key": "ipsum"],
            "complexDictionary": ["subDict": ["key": "value"], "key": "value"],
            "array": [1, 2, 3],
            "arrayOfArrays": [[1,2,3], ["a","b","c"]],
            "list": [1, "two", true, ["key": "value"], [1, 2]]
        ]

        let wrapper = Wrapper(data: dict)
        let encodedData = try JSONEncoder().encode(wrapper)
        let jsonObject = try JSONSerialization.jsonObject(with: encodedData, options: []) as! [String: Any]
        let result = jsonObject["data"] as! [String: Any]

        validateContentOf(result)
    }

    private func validateContentOf(_ data: [String: Any]) {
        XCTAssertEqual(data["int"] as? Int, 44)
        XCTAssertEqual(data["string"] as? String, "lorem")
        XCTAssertEqual(data["bool"] as? Bool, true)
        XCTAssertEqual((data["simpleDictionary"] as? [String: Any])?["key"] as? String, "ipsum")
        XCTAssertEqual(data["array"] as? [Int], [1, 2, 3])

        if let complexDictionary = data["complexDictionary"] as? [String: Any] {
            XCTAssertEqual((complexDictionary["subDict"] as? [String: Any])?["key"] as? String, "value")
            XCTAssertEqual(complexDictionary["key"] as? String, "value")
        } else {
            XCTFail("Cannot cast complexDictionary to [String: Any]")
        }

        if let arrayOfArrays = data["arrayOfArrays"] as? [[Any]] {
            XCTAssertEqual(arrayOfArrays[0] as? [Int], [1, 2, 3])
            XCTAssertEqual(arrayOfArrays[1] as? [String], ["a", "b", "c"])
        } else {
            XCTFail("Cannot cast arrayOfArrays to [[Any]]")
        }

        if let list = (data["list"] as? [Any])  {
            XCTAssertEqual(list[0] as? Int, 1)
            XCTAssertEqual(list[1] as? String, "two")
            XCTAssertEqual(list[2] as? Bool, true)
            XCTAssertEqual((list[3] as? [String: Any])?["key"] as? String, "value")
            XCTAssertEqual(list[4] as? [Int], [1, 2])
        } else {
            XCTFail("Cannot cast list to [Any]")
        }
    }
}

private struct Wrapper: Codable {
    let data: [String: Any]

    init (data: [String: Any]) {
        self.data = data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode([String: Any].self, forKey: .data)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(data, forKey: .data)
    }

    enum CodingKeys: String, CodingKey {
        case data
    }
}
