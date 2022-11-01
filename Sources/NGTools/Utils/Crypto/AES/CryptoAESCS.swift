//
//  CryptoAESCS.swift
//  NGTools
//
//  Created by Lambert, Romain (Ordinateur) on 2022-11-01.
//

import Foundation
import CryptoSwift

@available(iOS, obsoleted:13.0)
struct CryptoAESCS {

    static func encrypt(_ string: String, aesKey: Data, iv: Data) throws -> (cipherText: Data, tag: Data) {
        guard let data = string.data(using: .utf8) else { throw Crypto.CryptoError.aesEncryptionError }

        let gcm = GCM(iv: iv.bytes, mode: .detached)
        let aes = try AES(key: aesKey.bytes, blockMode: gcm, padding: .noPadding)
        let encrypted = try aes.encrypt(data.bytes)

        guard let tag = gcm.authenticationTag else {
            throw Crypto.CryptoError.aesEncryptionError
        }

        return (Data(encrypted), Data(tag))
    }

    static func decrypt(_ data: Data, aesKey: Data, iv: Data, tag: Data) throws -> Data {
        let gcm = GCM(iv: iv.bytes, authenticationTag: tag.bytes)
        let aes = try AES(key: aesKey.bytes, blockMode: gcm, padding: .noPadding)
        let decrypted = try aes.decrypt(data.bytes)

        return Data(decrypted)
    }
}
