//
//  reflect.swift
//  NGTools
//
//  Created by Werck, Ayrton on 2018-11-05.
//  Copyright © 2018 Nuglif. All rights reserved.
//

public func reflect<T>(_ subject: T?, defaultValue: String = "") -> String {
    switch subject {
    case .some(let value):
        return String(reflecting: value)
    case .none:
        return defaultValue
    }
}
