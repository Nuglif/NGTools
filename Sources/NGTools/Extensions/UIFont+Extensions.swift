//
//  UIFont+Extensions.swift
//  NGTools
//
//  Created by Bussiere, Mathieu on 2018-02-06.
//  Copyright © 2018 Nuglif. All rights reserved.
//

import UIKit

public extension UIFont {

    var dynamicTypeFont: UIFont {
        if #available(iOS 11.0, *) {
            return UIFontMetrics.default.scaledFont(for: self)
        } else {
            return self
        }
    }

    static func customFont(for fontName: String?, size: CGFloat, fallbackFont: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)) -> UIFont {
        let defaultFont = fallbackFont.withSize(size)

        guard let fontName = fontName else { return defaultFont }

        if let font = UIFont(name: fontName, size: size) {
            return font
        }

        do {
            try loadFont(for: fontName)
            return UIFont(name: fontName, size: size) ?? defaultFont
        } catch {
            return defaultFont
        }
    }
}

// MARK: - UIFont (Private)
private extension UIFont {

    enum FontError: Error {
        case notFound
        case notLoaded
    }

    static func loadFont(for fontName: String) throws {
        let bundle = Bundle.main

        guard let fileUrl = bundle.url(forResource: fontName, withExtension: "otf") else { throw(FontError.notFound) }
        guard let data = NSData(contentsOf: fileUrl),
              let provider = CGDataProvider(data: data),
              let font = CGFont(provider) else {
            throw(FontError.notLoaded)
        }

        CTFontManagerRegisterGraphicsFont(font, nil)
    }
}
