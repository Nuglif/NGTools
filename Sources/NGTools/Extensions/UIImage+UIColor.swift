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
        let rect: CGRect = .init(x: 0, y: 0, width: 1, height: 1)
        let format = UIGraphicsImageRendererFormat.default()
        format.opaque = false

        let renderer = UIGraphicsImageRenderer(size: rect.size, format: format)
        let image = renderer.image { context in
            context.cgContext.setFillColor(color.cgColor)
            context.cgContext.fill(rect)
        }

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

        let format = UIGraphicsImageRendererFormat.default()
        format.opaque = false

        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        var image = renderer.image { context in
            // Flip the context vertically
            context.cgContext.translateBy(x: 0.0, y: size.height)
            context.cgContext.scaleBy(x: 1.0, y: -1.0)

            // Image tinting mostly inspired by http://stackoverflow.com/a/22528426/255489
            context.cgContext.setBlendMode(.normal)
            context.cgContext.draw(cgImage!, in: imageRect)

            // .sourceIn: resulting color = source color * destination alpha
            context.cgContext.setBlendMode(.sourceIn)
            context.cgContext.setFillColor(color.cgColor)
            context.cgContext.fill(imageRect)
        }

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
