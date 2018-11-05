//
//  memoization.swift
//  NGTools
//
//  Created by Werck, Ayrton on 2018-11-05.
//  Copyright © 2018 Nuglif. All rights reserved.
//

import Foundation

public func cached<In: Hashable, Out>(_ fn: @escaping (In) -> Out) -> (In) -> Out {
    var cache: [In: Out] = [:]

    return { (input: In) -> Out in
        if let cachedOut = cache[input] {
            return cachedOut
        }
        let out = fn(input)
        cache[input] = out
        return out
    }
}

public func cachedAutoFlush<In: Hashable & AnyObject, Out: AnyObject>(_ fn: @escaping (In) -> Out) -> (In) -> Out {
    let cache: NSCache<In, Out> = NSCache()

    return { (input: In) -> Out in
        if let cachedOut = cache.object(forKey: input) {
            return cachedOut
        }
        let out = fn(input)
        cache.setObject(out, forKey: input)
        return out
    }
}
