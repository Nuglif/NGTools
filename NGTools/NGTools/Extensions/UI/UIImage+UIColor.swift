//
//  UIImage+UIColor.swift
//  NGTools
//
//  Created by Werck, Ayrton on 2018-11-05.
//  Copyright © 2018 Nuglif. All rights reserved.
//

import UIKit

public extension UIImage {

    @objc static func image(color: UIColor, size: CGSize) -> UIImage? {
        return color.image(size: size)
    }

    @objc static func image(color: UIColor, andWidth width: Int) -> UIImage? {
        return color.image(size: CGSize(width: width, height: 1))
    }

    convenience init?(color: UIColor) {
        let rect = CGRect(origin: CGPoint.zero, size: CGSize(width: 1, height: 1))
        UIGraphicsBeginImageContext(rect.size)

        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.setFillColor(color.cgColor)
        context.fill(rect)

        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()

        guard let cgImage = image.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }

    @objc func tintedImage(for color: UIColor?) -> UIImage {
        guard let color = color else { return self }

        let imageRect = CGRect(origin: .zero, size: size)

        // Save original properties
        let originalCapInsets = capInsets
        let originalResizingMode = resizingMode
        let originalAlignmentRectInsets = alignmentRectInsets

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return self }

        // Flip the context vertically
        context.translateBy(x: 0.0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)

        // Image tinting mostly inspired by http://stackoverflow.com/a/22528426/255489
        context.setBlendMode(.normal)
        context.draw(cgImage!, in: imageRect)

        // .sourceIn: resulting color = source color * destination alpha
        context.setBlendMode(.sourceIn)
        context.setFillColor(color.cgColor)
        context.fill(imageRect)

        // Get new image
        guard var image = UIGraphicsGetImageFromCurrentImageContext() else { return self }
        UIGraphicsEndImageContext()

        // Prevent further tinting
        image = image.withRenderingMode(.alwaysOriginal)

        // Restore original properties
        image = image.withAlignmentRectInsets(originalAlignmentRectInsets)

        if originalCapInsets != image.capInsets || originalResizingMode != image.resizingMode {
            image = image.resizableImage(withCapInsets: originalCapInsets, resizingMode: originalResizingMode)
        }

        image.accessibilityLabel = self.accessibilityLabel

        return image
    }
}
