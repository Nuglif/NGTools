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
        if #available(iOSApplicationExtension 11.0, *) {
            return UIFontMetrics.default.scaledFont(for: self)
        } else {
            return self
        }
    }

    static func customFont(for fontName: String?, size: CGFloat) -> UIFont {
        if let fontName = fontName, let font = UIFont(name: fontName, size: size) {
            return font
        }

        return UIFont.systemFont(ofSize: size)
    }
}
