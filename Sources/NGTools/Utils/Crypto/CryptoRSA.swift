//
//  RSA.swift
//  NGTools
//
//  Created by Lambert, Romain (Ordinateur) on 2022-10-07.
//

import Foundation

public struct CryptoRSA {

    static func generatePublicKeyFrom(pemFileURL: URL) throws -> SecKey {
        let fileData = try Data(contentsOf: pemFileURL)
        guard let pemString = String(data: fileData, encoding: .utf8) else { throw Crypto.CryptoError.rsaKeyCreationError }

        return try generatePublicKeyFrom(pemString: pemString)
    }

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
            throw Crypto.CryptoError.rsaKeyCreationError
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
        return pemString.filter { $0 != " " }
            .components(separatedBy: "\n")
            .filter { !$0.starts(with: "-----") }
            .joined()
    }
}