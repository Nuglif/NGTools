//
//  JsonLoader.swift
//  NGTools
//
//  Created by Werck, Ayrton on 2018-11-05.
//  Copyright © 2018 Nuglif. All rights reserved.
//

import Foundation

public func += <KeyType, ValueType> (left: inout [KeyType: ValueType], right: [KeyType: ValueType]) {
    for (key, value) in right {
        left.updateValue(value, forKey: key)
    }
}

public protocol JsonLoader {

    func decodeJson<T: Decodable>(decoder: JSONDecoder, for type: T.Type, error: inout NSError?) -> T?
}

public extension JsonLoader {

    func decodeJson<T: Decodable>(decoder: JSONDecoder = .init(), for type: T.Type = T.self) -> T? {
        var error: NSError?
        return decodeJson(decoder: decoder, for: type, error: &error)
    }
}

extension Dictionary: JsonLoader {

    public func decodeJson<T: Decodable>(decoder: JSONDecoder = .init(), for type: T.Type = T.self, error: inout NSError?) -> T? {
        do {
            let data = try JSONSerialization.data(withJSONObject: self)
            return try decoder.decode(type, from: data)
        } catch (let e) {
            error = e as NSError
            return nil
        }
    }
}

extension NSDictionary: JsonLoader {

    public func decodeJson<T: Decodable>(decoder: JSONDecoder = .init(), for type: T.Type = T.self, error: inout NSError?) -> T? {
        do {
            let data = try JSONSerialization.data(withJSONObject: self)
            return try decoder.decode(type, from: data)
        } catch (let e) {
            error = e as NSError
            return nil
        }
    }
}

extension Data: JsonLoader {

    public func decodeJson<T: Decodable>(decoder: JSONDecoder = .init(), for type: T.Type = T.self, error: inout NSError?) -> T? {
        do {
            return try decoder.decode(type, from: self)
        } catch (let e) {
            error = e as NSError
            return nil
        }
    }
}
