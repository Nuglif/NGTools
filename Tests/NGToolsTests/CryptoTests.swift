//
//  CryptoTests.swift
//  NGToolsTests
//
//  Created by Lambert, Romain (Ordinateur) on 2022-10-31.
//  Copyright © 2022 Nuglif. All rights reserved.
//

import XCTest

@testable import NGTools

final class CryptoTests: XCTestCase {

    let message = "NGTools"
    let base64KeyData = "xuklFcMMklVs3uOwsaOGLzgVpZyjhgm8Ffm9Qf27JZc="
    let base64IVData = "4lKdApKttNHlw4p/nwKEVw=="

    func testCryptoSwiftAESEncryption() {
        do {
            guard let keyData = Data(base64Encoded: base64KeyData), let ivData = Data(base64Encoded: base64IVData) else {
                XCTFail("Failed to create data")
                return
            }

            let encodedData = try CryptoSwiftAES.encrypt(message, aesKey: keyData, iv: ivData)
            let encodedDataBase64 = encodedData.cipherText.base64EncodedString()
            let expectedValue = "mU4TsQ24Ug=="

            XCTAssertEqual(encodedDataBase64, expectedValue, "Unexpected encrypted data")

            let decodedData = try CryptoSwiftAES.decrypt(encodedData.cipherText, aesKey: keyData, iv: ivData, tag: encodedData.tag)
            XCTAssertEqual(String(data: decodedData, encoding: .utf8), message)

        } catch Crypto.CryptoError.aesEncryptionError {
            XCTFail("Failed to encrypt message")
        } catch {
            XCTFail("Failed to decrypt message")
        }
    }

    func testCryptoKitAESEncryption() {
        guard #available(iOS 13, *) else { return }
        
        do {
            guard let keyData = Data(base64Encoded: base64KeyData) else {
                XCTFail("Failed to create data")
                return
            }

            let key = CryptoKitAES.getAESKey(keyData)
            let encodedData = try CryptoKitAES.encrypt(message, key: key)
            let decodedData = try CryptoKitAES.decrypt(encodedData, key: key)

            XCTAssertEqual(decodedData, message)

        } catch Crypto.CryptoError.aesEncryptionError {
            XCTFail("Failed to encrypt message")
        } catch {
            XCTFail("Failed to decrypt message")
        }
    }

    func testRSAEncryption() {
        do {
            let rsaPublicKey = """
            MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA4BldolR6OJqHn1JwOMSQ
            K0YUdbtVZNtcaxFqQw9bcMRvJzNQtaVmXGBbCynTDieLIQ8FDpLKzHfNeh1Yk3V7
            8glIyK7KTgx9vaq4IgNHOeijlevYnK9PHohz5j9J1aYejiAZQSjCvOmkD7D4EKKs
            pvPxmZ4gMLiasEIamuhQAEQv8MKbH5AFMuRA7nWO84VrdfVSD14fUpuX87SHkWqD
            /5t7SkO+9/YUFluU3F1pyWIJSwuWLgKs7RX1O5GVfBixyILb0+NRKaTB2qfKJyVH
            D5uORX7xYgvu3Nw5an3pbwmEFzJ2Qytdk9/SHs/9s0olgIh9ius/MagB2k1gBZR4
            hwIDAQAB
            """

            guard let messageData = message.data(using: .utf8) else {
                XCTFail("Failed to create data")
                return
            }

            let rsaKey = try CryptoRSA.generatePublicKeyFrom(pemString: rsaPublicKey)
            let encryptedData = try CryptoRSA.encrypt(messageData, key: rsaKey)

            XCTAssertEqual(encryptedData.count, 256)

        } catch Crypto.CryptoError.rsaKeyCreationError {
            XCTFail("Failed to create RSA key")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
