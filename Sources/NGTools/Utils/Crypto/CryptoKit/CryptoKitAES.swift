//
//  CryptoAESCK.swift
//  NGTools
//
//  Created by Lambert, Romain (Ordinateur) on 2022-11-01.
//  Copyright © 2022 Nuglif. All rights reserved.
//

import Foundation
import CryptoKit

@available(iOS 13.0, *)
struct CryptoKitAES {

    static func getAESKey(_ keyData: Data) -> SymmetricKey {
        return SymmetricKey.init(data: keyData)
    }

    static func encrypt(_ string: String, key: SymmetricKey) throws -> CryptoKit.AES.GCM.SealedBox {
        guard let data = string.data(using: .utf8) else { throw Crypto.CryptoError.aesEncryptionError }
        return try AES.GCM.seal(data, using: key)
    }

    static func decrypt(_ sealedBox: CryptoKit.AES.GCM.SealedBox, key: SymmetricKey) throws -> String? {
        let decryptedData = try AES.GCM.open(sealedBox, using: key)
        return String(data: decryptedData, encoding: .utf8)
    }
}
