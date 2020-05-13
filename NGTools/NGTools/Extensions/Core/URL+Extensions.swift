//
//  URL+Extensions.swift
//  NGTools
//
//  Created by Fournier, Olivier on 2018-12-10.
//  Copyright © 2018 Nuglif. All rights reserved.
//

import Foundation

public extension URL {

    func base64EncodedString() -> String {
        return dataRepresentation.base64EncodedString()
    }

    func sha1() -> String? {
        return dataRepresentation.sha1()
    }

    func appendingScheme(defaultScheme: String = "http") -> URL {
        guard scheme == nil else { return self }

        return URL(string: "\(defaultScheme)://\(absoluteString)") ?? self
    }
}
