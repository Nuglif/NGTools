//
//  Crypto.swift
//  NGTools
//
//  Created by Lambert, Romain (Ordinateur) on 2022-11-01.
//  Copyright © 2022 Nuglif. All rights reserved.
//

import Foundation

public struct Crypto {
    public enum CryptoError: Error {
        case rsaKeyCreationError
        case rsaEncryptionError
        case rsaAlgorithmNotSupported
        case aesKeyCreationError
        case aesRandomBytesError
        case aesEncryptionError
        case aesDecryptionError
        case cryptoKitNotAvailable
    }

    public static func encryptForAuthenticationServer(_ text: String, rsaPublicKey: String) throws -> String {
        let serverEncryptor = CryptoBuilder.build()

        return try serverEncryptor.encryptForAuthenticationServer(text, rsaPublicKey: rsaPublicKey)
    }
}
