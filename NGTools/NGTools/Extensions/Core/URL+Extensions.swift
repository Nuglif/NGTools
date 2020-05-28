//
//  URL+Extensions.swift
//  NGTools
//
//  Created by Fournier, Olivier on 2018-12-10.
//  Copyright © 2018 Nuglif. All rights reserved.
//

import Foundation

public extension URL {

    var sha1: String { dataRepresentation.sha1 }

    func base64EncodedString() -> String { dataRepresentation.base64EncodedString() }

    func appendingScheme(defaultScheme: String = "http") -> URL {
        guard scheme == nil else { return self }

        return URL(string: "\(defaultScheme)://\(absoluteString)") ?? self
    }
}
