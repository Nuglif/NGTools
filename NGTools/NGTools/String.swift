//
//  String.swift
//  NGTools
//
//  Created by Goldschmidt, Jérémy on 2019-05-13.
//  Copyright © 2019 Nuglif. All rights reserved.
//

import Foundation
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import var CommonCrypto.CC_SHA1_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import func CommonCrypto.CC_SHA1
import typealias CommonCrypto.CC_LONG

public extension String {
    var md5: String? {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = self.data(using:.utf8)!
        var digestData = Data(count: length)

        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        return String(data: digestData, encoding: .utf8)
    }

    var sha1: String {
        let data = Data(self.utf8)
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0.baseAddress, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }

    var isEmptyOrContainsOnlyWhitespaces: Bool {
        return trimmingCharacters(in: CharacterSet.whitespaces).count == 0
    }
}

public extension NSString {
    @objc func md5() -> NSString? {
        return (self as String).md5 as NSString?
    }

    @objc func sha1() -> NSString? {
        return (self as String).sha1 as NSString?
    }

    @objc func isEmptyOrContainsOnlyWhitespaces() -> Bool {
        return (self as String).isEmptyOrContainsOnlyWhitespaces
    }
}
