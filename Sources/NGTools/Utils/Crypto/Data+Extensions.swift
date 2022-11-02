//
//  Data+Extensions.swift
//  NGTools
//
//  Created by Fournier, Olivier on 2019-01-04.
//  Copyright © 2019 Nuglif. All rights reserved.
//

import Foundation
import CommonCrypto

public extension Data {

    enum DataError: Error {
        case randomBytesError
    }

    var sha1: String {
        let digest: [UInt8] = withUnsafeBytes {
            var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))

            CC_SHA1($0.baseAddress, CC_LONG(count), &digest)

            return digest
        }

        return digest
            .map { String(format: "%02hhx", $0) }
            .joined()
    }

    var md5: String {
        let digest: [UInt8] = withUnsafeBytes {
            var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))

            CC_MD5($0.baseAddress, CC_LONG(count), &digest)

            return digest
        }

        return digest
            .map { String(format: "%02hhx", $0) }
            .joined()
    }

    var sha256: String {
		let digest: [UInt8] = withUnsafeBytes {
			var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))

			CC_SHA256($0.baseAddress, CC_LONG(count), &digest)

			return digest
		}

		return digest.map {
			String(format: "%02x", $0)
		}.joined()
	}

    func toHexadecimal() -> String {
        return reduce("", { $0 + String(format: "%02X", $1) })
            .lowercased()
    }

    static func randomBytes(length: Int = 32) throws -> Data {
        var randomData = Data(count: length)

        let result = try randomData.withUnsafeMutableBytes { pointer in
            guard let baseAddress = pointer.baseAddress else {
                throw DataError.randomBytesError
            }

            return SecRandomCopyBytes(kSecRandomDefault, length, baseAddress)
        }

        guard result == errSecSuccess else {
            throw DataError.randomBytesError
        }

        return randomData
    }
}
