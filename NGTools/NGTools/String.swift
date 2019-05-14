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

    var md5: String {
        let data = Data(self.utf8)

        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        _ = data.withUnsafeBytes {
            CC_MD5($0.baseAddress, UInt32(data.count), &digest)
        }

        return digest.map { String(format: "%02x", $0) }.joined()
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

    var URLEncodedString: String? {
        let queryKVSet = CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[]").inverted

        return addingPercentEncoding(withAllowedCharacters: queryKVSet)
    }
}

public extension NSString {
    @objc func md5() -> NSString {
        return (self as String).md5 as NSString
    }

    @objc func sha1() -> NSString {
        return (self as String).sha1 as NSString
    }

    @objc func isEmptyOrContainsOnlyWhitespaces() -> Bool {
        return (self as String).isEmptyOrContainsOnlyWhitespaces
    }

    @objc func URLEncodedString() -> NSString? {
        return (self as String).URLEncodedString as NSString?
    }
}
