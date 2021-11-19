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

    func base64EncodedString() -> String {
        return dataRepresentation.base64EncodedString()
    }

    func appendingScheme(defaultScheme: String = "http") -> URL {
        guard scheme == nil else { return self }

        return URL(string: "\(defaultScheme)://\(absoluteString)") ?? self
    }

    func integrate(parameters: [String: Any], into queryParameterName: String) -> URLComponents? {
        guard var urlComponents = URLComponents(string: absoluteString) else { return nil }

        var queryParams = [String: String]()

        urlComponents.queryItems?.forEach { item in
            queryParams[item.name] = item.value
        }

        var customParameters = queryParams[queryParameterName]?
            .split(separator: "&")
            .map(String.init) ?? []

        customParameters.append(contentsOf:
            parameters.map { key, value -> String in
                switch value {
                case let array as [Any]:
                    let values = array
                        .map { "\($0)" }
                        .joined(separator: ",")
                    return "\(key)=\(values)"
                default:
                    return "\(key)=\(value)"
                }
            }
        )

        queryParams[queryParameterName] = customParameters
            .sorted(by: <)
            .joined(separator: "&")

        urlComponents.percentEncodedQuery = queryParams
            .sorted {$0.key < $1.key }
            .compactMap { param in
                guard let key = param.key.urlEncoded,
                      let value = param.value.urlEncoded else {
                    return nil
                }

                return "\(key)=\(value)"
            }
            .joined(separator: "&")

        return urlComponents
    }
}
