//
//  CryptoRSA.swift
//  NGTools
//
//  Created by Lambert, Romain (Ordinateur) on 2022-11-01.
//  Copyright © 2022 Nuglif. All rights reserved.
//

import Foundation

struct CryptoRSA {

    static func generatePublicKeyFrom(pemString: String) throws -> SecKey {
        let clearedPEM = CryptoRSA.clearPEMString(pemString)

        guard let keyData = Data(base64Encoded: clearedPEM, options: .ignoreUnknownCharacters) else {
            throw Crypto.CryptoError.rsaKeyCreationError
        }

        let keyAttributes: [String: Any] = [
            String(kSecAttrKeyType): kSecAttrKeyTypeRSA,
            String(kSecAttrKeyClass): kSecAttrKeyClassPublic
        ]

        var error: Unmanaged<CFError>?
        guard let key = SecKeyCreateWithData(keyData as CFData, keyAttributes as CFDictionary, &error) else {
            if let managedError = error?.takeRetainedValue() as? Error {
                throw managedError
            } else {
                throw Crypto.CryptoError.rsaKeyCreationError
            }
        }

        return key
    }

    static func encrypt(_ data: Data, key: SecKey) throws -> Data {
        guard SecKeyIsAlgorithmSupported(key, .encrypt, .rsaEncryptionPKCS1) else {
            throw Crypto.CryptoError.rsaAlgorithmNotSupported
        }

        var error: Unmanaged<CFError>?
        guard let cryptedData = SecKeyCreateEncryptedData(key, .rsaEncryptionPKCS1, data as CFData, &error) as? Data else {
            throw Crypto.CryptoError.rsaEncryptionError
        }

        return cryptedData
    }
}

private extension CryptoRSA {
    static func clearPEMString(_ pemString: String) -> String {
        return pemString.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
