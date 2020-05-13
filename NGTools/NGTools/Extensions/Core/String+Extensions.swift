//
//  String+Extensions.swift
//  NGTools
//
//  Created by Fournier, Olivier on 2017-11-24.
//  Copyright © 2017 Nuglif. All rights reserved.
//

import Foundation
import CommonCrypto

public extension String {

    static func * (lhs: String, rhs: Int) -> String {
        guard rhs > 0 else { return "" }

        return String(repeating: lhs, count: rhs)
    }

    func localized(_ args: CVarArg...) -> String {
        let format = NSLocalizedString(self, comment: self)

        return String(format: format, arguments: args)
    }

    func base64Encoded() -> String? {
        guard let data = data(using: .utf8) else { return nil }

        return data.base64EncodedString()
    }

    func sha1() -> String? {
        return data(using: .utf8)?.sha1()
    }

    func md5() -> String? {
        return data(using: .utf8)?.md5()
    }

	func sha256() -> String? {
		return data(using: .utf8)?.sha256()
	}

	static func randomNonce(length: Int = 32) -> String {
		precondition(length > 0)
		let charset: [Character] =
			Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
		var result = ""
		var remainingLength = length

		while remainingLength > 0 {
			let randoms: [UInt8] = (0 ..< 16).map { _ in
				var random: UInt8 = 0
				let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
				if errorCode != errSecSuccess {
					fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
				}
				return random
			}

			randoms.forEach { random in
				if length == 0 {
					return
				}

				if random < charset.count {
					result.append(charset[Int(random)])
					remainingLength -= 1
				}
			}
		}

		return result
	}

    func characterAtIndexIsAlphaNumeric(index: Int) -> Bool {
        var charSet = CharacterSet()
        charSet.formUnion(.whitespacesAndNewlines)

        let currentCharacterIndex = self.index(self.startIndex, offsetBy: index)
        let currentCharacter = self[currentCharacterIndex]

        return currentCharacter.unicodeScalars.allSatisfy { !charSet.contains($0) }
    }
}
