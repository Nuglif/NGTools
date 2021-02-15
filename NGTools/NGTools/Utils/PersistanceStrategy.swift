//
//  PersistanceStrategy.swift
//  La Presse+
//
//  Created by Condor, Judith on 2021-02-02.
//  Copyright © 2021 Nuglif. All rights reserved.
//

import Foundation

public protocol PersistanceStrategy: AnyObject {

    func persist<T>(_ object: T, key: String) where T: Codable
    func retrieve<T>(for key: String) -> T?  where T: Codable
    func remove(for key: String)
}
