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

    @objc func image() -> UIImage? {
        return image(size: CGSize(width: 1.0, height: 1.0))
    }

    func image(size: CGSize) -> UIImage? {
        let rect = CGRect(origin: .zero, size: size)
        let format = UIGraphicsImageRendererFormat.default()
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        let newImage = renderer.image { context in
            context.cgContext.setFillColor(self.cgColor)
            context.cgContext.fill(rect)
        }

        return newImage
    }

    private static func imageWrp(from color: UIColor) -> UIImage? {
        return color.image()
    }
}
