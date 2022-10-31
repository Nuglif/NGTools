//
//  Crypto.swift
//  NGTools
//
//  Created by Lambert, Romain (Ordinateur) on 2022-10-12.
//

import Foundation
import CryptoKit
import CryptoSwift

public struct Crypto {

    public enum CryptoError: Error {
        case rsaKeyCreationError
        case rsaEncryptionError
        case rsaAlgorithmNotSupported
        case aesKeyCreationError
        case aesRandomBytesError
        case aesEncryptionError
        case aesDecryptionError
    }

    public static func encryptForServer(_ text: String, rsaPublicKey: String) throws -> String {
        if #available(iOS 13.0, *) {
            return try encryptForServerCK(text, rsaPublicKey: rsaPublicKey)
        } else {
            return try encryptForServerCS(text, rsaPublicKey: rsaPublicKey)
        }
    }
}

private extension Crypto {

    @available(iOS 13.0, *)
    static func encryptForServerCK(_ text: String, rsaPublicKey: String) throws -> String {

        // 1. Generate AES key
        let aesKeyData = try CryptoAES.getRandomBytes()
        let symmetricKey = CryptoAES.getAESKey(aesKeyData)

        // 2. Encrypt data
        let encryptedData = try CryptoAES.encrypt(text, key: symmetricKey)

        // 3. Encrypt AES key with RSA public key
        let rsaPublicKey = try CryptoRSA.generatePublicKeyFrom(pemString: rsaPublicKey)
        let aesKeyEncryptedData = try CryptoRSA.encrypt(aesKeyData, key: rsaPublicKey)

        // 4. Build base64 string to share
        let ivData64 = Data(encryptedData.nonce).base64EncodedString()
        let cypherText64 = encryptedData.ciphertext.base64EncodedString()
        let tag64 = encryptedData.tag.base64EncodedString()
        let aesKeyEncryptedData64 = aesKeyEncryptedData.base64EncodedString()

        let base64ToShare = "\(aesKeyEncryptedData64).\(ivData64).\(cypherText64).\(tag64)"
        return base64ToShare
    }

    @available(iOS, obsoleted:13.0)
    static func encryptForServerCS(_ text: String, rsaPublicKey: String) throws -> String {

        // 1. Generate AES key
        let aesKeyData = try CryptoAES.getRandomBytes(length: CryptoAES.keySize)
        let aesIVData = try CryptoAES.getRandomBytes(length: CryptoAES.ivSize)

        // 2. Encrypt data
        let encryptedData = try CryptoAES.encrypt(text, aesKey: aesKeyData, iv: aesIVData)

        // 3. Encrypt AES key with RSA public key
        let rsaPublicKey = try CryptoRSA.generatePublicKeyFrom(pemString: rsaPublicKey)
        let aesKeyEncryptedData = try CryptoRSA.encrypt(aesKeyData, key: rsaPublicKey)

        // 4. Build base64 string to share
        let ivData64 = aesIVData.base64EncodedString()
        let cypherText64 = encryptedData.cipherText.base64EncodedString()
        let tag64 = encryptedData.tag.base64EncodedString()
        let aesKeyEncryptedData64 = aesKeyEncryptedData.base64EncodedString()

        let base64ToShare = "\(aesKeyEncryptedData64).\(ivData64).\(cypherText64).\(tag64)"
        return base64ToShare
    }
}
