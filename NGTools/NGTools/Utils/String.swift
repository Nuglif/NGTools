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
        return (self as String).md5() as NSString
    }

    @objc func sha1() -> NSString {
        return (self as String).sha1() as NSString
    }

    @objc func isEmptyOrContainsOnlyWhitespaces() -> Bool {
        return (self as String).isEmptyOrContainsOnlyWhitespaces
    }

    @objc func URLEncodedString() -> NSString? {
        return (self as String).URLEncodedString as NSString?
    }
}
