//
//  CryptoBuilder.swift
//  NGTools
//
//  Created by Lambert, Romain (Ordinateur) on 2022-11-01.
//  Copyright © 2022 Nuglif. All rights reserved.
//

import Foundation

struct CryptoBuilder {
    static func build() -> ServerEncryptor {
        if #available(iOS 13.0, *) {
            return CryptoKitServerEncryptor()
        } else {
            return CryptoSwiftServerEncryptor()
        }
    }
}
