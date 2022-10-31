//
//  AES.swift
//  NGTools
//
//  Created by Lambert, Romain (Ordinateur) on 2022-10-13.
//

import Foundation
import CommonCrypto
import CryptoKit
import CryptoSwift

public struct CryptoAES {

    static let ivSize: Int = kCCBlockSizeAES128
    static let keySize: Int = kCCKeySizeAES256

    static func getRandomBytes(length: Int = 32) throws -> Data {
        var keyData = Data(count: length)

        let result = try keyData.withUnsafeMutableBytes { pointer in
            guard let baseAddress = pointer.baseAddress else {
                throw Crypto.CryptoError.aesRandomBytesError
            }

            return SecRandomCopyBytes(kSecRandomDefault, length, baseAddress)
        }

        guard result == errSecSuccess else {
            throw Crypto.CryptoError.aesRandomBytesError
        }

        return keyData
    }

    //MARK: - Key creation
    @available(iOS 13.0, *)
    static func getAESKey(_ keyData: Data) -> SymmetricKey {
        return SymmetricKey.init(data: keyData)
    }

    //MARK: - Encryption
    @available(iOS 13.0, *)
    static func encrypt(_ string: String, key: SymmetricKey) throws -> CryptoKit.AES.GCM.SealedBox {
        guard let data = string.data(using: .utf8) else { throw Crypto.CryptoError.aesEncryptionError }
        return try AES.GCM.seal(data, using: key)
    }

    @available(iOS, obsoleted:13.0)
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

    //MARK: - Decryption
    @available(iOS 13.0, *)
    static func decrypt(_ sealedBox: CryptoKit.AES.GCM.SealedBox, key: SymmetricKey) throws -> String? {
        let decryptedData = try AES.GCM.open(sealedBox, using: key)
        return String(data: decryptedData, encoding: .utf8)
    }
    
    @available(iOS, obsoleted:13.0)
    static func decrypt(_ data: Data, aesKey: Data, iv: Data, tag: Data) throws -> Data {
        let gcm = GCM(iv: iv.bytes, authenticationTag: tag.bytes)
        let aes = try AES(key: aesKey.bytes, blockMode: gcm, padding: .noPadding)
        let decrypted = try aes.decrypt(data.bytes)

        return Data(decrypted)
    }
}
