//
//  UIColor+Extensions.swift
//  NGTools
//
//  Created by Bussiere, Mathieu on 2017-12-14.
//  Copyright © 2017 Nuglif. All rights reserved.
//

import UIKit

public extension UIColor {

    convenience init(hex: String) {
        let color = Color(hex: hex)

        self.init(red: color.red,
                  green: color.green,
                  blue: color.blue,
                  alpha: color.alpha)
    }

    convenience init(hex: String, alpha: CGFloat) {
        let color = Color(hex: hex, alpha: alpha)

        self.init(red: color.red,
                  green: color.green,
                  blue: color.blue,
                  alpha: color.alpha)
    }
}
