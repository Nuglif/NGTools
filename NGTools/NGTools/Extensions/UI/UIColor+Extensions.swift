//
//  UIColor+Extensions.swift
//  NGTools
//
//  Created by Bussiere, Mathieu on 2017-12-14.
//  Copyright © 2017 Nuglif. All rights reserved.
//

import UIKit

public extension UIColor {

    convenience init(hex string: String, alpha: CGFloat = 1) {
        let RGBA = Color.rgba(from: string, alpha: alpha)

        self.init(red: CGFloat(RGBA.red),
                  green: CGFloat(RGBA.green),
                  blue: CGFloat(RGBA.blue),
                  alpha: CGFloat(RGBA.alpha))
    }
}
