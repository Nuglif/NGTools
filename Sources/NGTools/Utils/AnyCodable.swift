//
//  AnyCodable.swift
//  NGTools
//
//  Created by Werck, Ayrton on 2018-11-05.
//  Copyright © 2018 Nuglif. All rights reserved.
//

//MARK: - JSONCodingKeys
public struct JSONCodingKeys: CodingKey {

    public var stringValue: String
    public var intValue: Int?

    public init(stringValue: String) {
        self.stringValue = stringValue
    }

    public init(intValue: Int) {
        self.init(stringValue: "\(intValue)")
        self.intValue = intValue
    }
}

//MARK: - Decode
public extension KeyedDecodingContainer {

    func decode(_ type: [String: Any].Type, forKey key: K) throws -> [String: Any] {
        let container = try nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key)
        return try container.decode(type)
    }

    func decodeIfPresent(_ type: [String: Any].Type, forKey key: K) throws -> [String: Any]? {
        guard contains(key) else { return nil }
        return try decode(type, forKey: key)
    }

    func decode(_ type: [Any].Type, forKey key: K) throws -> [Any] {
        var container = try nestedUnkeyedContainer(forKey: key)
        return try container.decode(type)
    }

    func decodeIfPresent(_ type: [Any].Type, forKey key: K) throws -> [Any]? {
        guard contains(key) else { return nil }
        return try decode(type, forKey: key)
    }

    func decode(_ type: [String: Any].Type) throws -> [String: Any] {
        var dictionary = [String: Any]()

        for key in allKeys {
            if let value = try? decode(Bool.self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode(String.self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode(Int.self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode(Double.self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode([String: Any].self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decode([Any].self, forKey: key) {
                dictionary[key.stringValue] = value
            } else if let value = try? decodeNil(forKey: key), value == true {
                dictionary[key.stringValue] = nil
            } else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath, debugDescription: "Unable to decode value for key: \(key)"))
            }
        }
        return dictionary
    }
}

extension UnkeyedDecodingContainer {

    mutating func decode(_ type: [Any].Type) throws -> [Any] {
        var array: [Any] = []

        while isAtEnd == false {
            if let value = try? decode(Bool.self) {
                array.append(value)
            } else if let value = try? decode(String.self) {
                array.append(value)
            } else if let value = try? decode(Int.self) {
                array.append(value)
            } else if let value = try? decode(Double.self) {
                array.append(value)
            } else if let value = try? decode([String: Any].self) {
                array.append(value)
            } else if let value = try? decodeNestedArray([Any].self) {
                array.append(value)
            } else if let value = try? decodeNil(), value == true {
                array.append(Optional<Any>.none as Any)
            } else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath, debugDescription: "Unable to decode value for type \(type)"))
            }
        }
        return array
    }

    mutating func decodeNestedArray(_ type: [Any].Type) throws -> [Any] {
        var container = try nestedUnkeyedContainer()
        return try container.decode(type)
    }

    mutating func decode(_ type: [String: Any].Type) throws -> [String: Any] {
        let nestedContainer = try nestedContainer(keyedBy: JSONCodingKeys.self)
        return try nestedContainer.decode(type)
    }
}

//MARK: - Encode
public extension KeyedEncodingContainer {
    mutating func encodeIfPresent(_ value: [String: Any]?, forKey key: KeyedEncodingContainer<K>.Key) throws {
        guard let safeValue = value, !safeValue.isEmpty else {
            return
        }
        var container = self.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key)

        for item in safeValue {
            if let val = item.value as? Int {
                try container.encodeIfPresent(val, forKey: JSONCodingKeys(stringValue: item.key))
            } else if let val = item.value as? String {
                try container.encodeIfPresent(val, forKey: JSONCodingKeys(stringValue: item.key))
            } else if let val = item.value as? Double {
                try container.encodeIfPresent(val, forKey: JSONCodingKeys(stringValue: item.key))
            } else if let val = item.value as? Float {
                try container.encodeIfPresent(val, forKey: JSONCodingKeys(stringValue: item.key))
            } else if let val = item.value as? Bool {
                try container.encodeIfPresent(val, forKey: JSONCodingKeys(stringValue: item.key))
            } else if let val = item.value as? [Any] {
                try container.encodeIfPresent(val, forKey: JSONCodingKeys(stringValue: item.key))
            } else if let val = item.value as? [String: Any] {
                try container.encodeIfPresent(val, forKey: JSONCodingKeys(stringValue: item.key))
            }
        }
    }

    mutating func encodeIfPresent(_ value: [Any]?, forKey key: KeyedEncodingContainer<K>.Key) throws {
        guard let safeValue = value else { return }
        var container = self.nestedUnkeyedContainer(forKey: key)
        try container.encode(safeValue)
    }
}

extension KeyedEncodingContainer where K == JSONCodingKeys {
    mutating func encode(_ dictionary: [String: Any]) throws {
        for (stringKey, value) in dictionary {
            let key = JSONCodingKeys(stringValue: stringKey)
            if let val = value as? Int {
                try encode(val, forKey: key)
            } else if let val = value as? String {
                try encode(val, forKey: key)
            } else if let val = value as? Bool {
                try encode(val, forKey: key)
            } else if let val = value as? Double {
                try encode(val, forKey: key)
            } else if let val = value as? Float {
                try encode(val, forKey: key)
            } else if let nestedArray = value as? [Any] {
                var nestedArrayContainer = nestedUnkeyedContainer(forKey: key)
                try nestedArrayContainer.encode(nestedArray)
            } else if let dict = value as? [String: Any] {
                var nestedDictContainer = nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key)
                try nestedDictContainer.encode(dict)
            } else {
                try encodeNil(forKey: key)
            }
        }
    }
}

extension UnkeyedEncodingContainer {
    mutating func encode(_ value: [Any]) throws {
        for element in value {
            if let val = element as? Int {
                try encode(val)
            } else if let val = element as? String {
                try encode(val)
            } else if let val = element as? Bool {
                try encode(val)
            } else if let val = element as? Double {
                try encode(val)
            } else if let val = element as? Float {
                try encode(val)
            } else if let nestedArray = element as? [Any] {
                var nested = nestedUnkeyedContainer()
                try nested.encode(nestedArray)
            } else if let dict = element as? [String: Any] {
                var nested = nestedContainer(keyedBy: JSONCodingKeys.self)
                try nested.encode(dict)
            } else {
                try encodeNil()
            }
        }
    }
}
