//
//  UIColor+UIImage.swift
//  NGTools
//
//  Created by Werck, Ayrton on 2018-11-05.
//  Copyright © 2018 Nuglif. All rights reserved.
//

import UIKit

public extension UIColor {
    static let cachedImage = cached(imageWrp)

    func image() -> UIImage? {
        return image(size: CGSize(width: 1.0, height: 1.0))
    }

    func image(size: CGSize) -> UIImage? {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    private static func imageWrp(from color: UIColor) -> UIImage? {
        return color.image()
    }
}
