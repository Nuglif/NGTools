//
//  CryptoKitServerEncryptor.swift
//  NGTools
//
//  Created by Lambert, Romain (Ordinateur) on 2022-11-01.
//  Copyright © 2022 Nuglif. All rights reserved.
//

import Foundation
import CryptoKit

struct CryptoKitServerEncryptor: ServerEncryptor {

    func encryptForAuthenticationServer(_ text: String, rsaPublicKey: String) throws -> String {
        // 1. Generate AES key
        let aesKeyData = try Data.randomBytes()
        let symmetricKey = CryptoKitAES.getAESKey(aesKeyData)

        // 2. Encrypt data
        let encryptedData = try CryptoKitAES.encrypt(text, key: symmetricKey)

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
}
