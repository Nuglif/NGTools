//
//  Color.swift
//  NGTools
//
//  Created by Bussiere, Mathieu on 2018-02-16.
//  Copyright © 2018 Nuglif. All rights reserved.
//

import UIKit

public struct Color {

    public var rgba: RGBA
    public typealias RGBA = (red: Float, green: Float, blue: Float, alpha: Float)

    public static func rgba(from hex: String, alpha: CGFloat = 1) -> RGBA {
        let hexCode = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)

        var int = UInt32()
        var effectiveAlpha = alpha
        Scanner(string: hexCode).scanHexInt32(&int)

        let r, g, b: UInt32
        switch hexCode.count {
        case 3: // RGB (12-bit)
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // RGBA (32-bit)
            (r, g, b) = (int >> 24 & 0xFF, int >> 16 & 0xFF, int >> 8 & 0xFF)
            effectiveAlpha = CGFloat(int & 0xFF) / 255
        default:
            (r, g, b) = (0, 0, 0)
        }

        return RGBA(red: Float(r)/255, green: Float(g)/255, blue: Float(b)/255, alpha: Float(effectiveAlpha))
    }

    public init(red: Float, green: Float, blue: Float, alpha: Float = 1) {
        func clamp(_ value: Float) -> Float {
            return min(1, max(0, value))
        }

        rgba = RGBA(red: clamp(red), green: clamp(green), blue: clamp(blue), alpha: clamp(alpha))
    }

    public init(hex: String, alpha: CGFloat = 1) {
        rgba = Color.rgba(from: hex, alpha: alpha)
    }

    public func toHex() -> String {
        return String(format: "%02X%02X%02X%02X", Int(rgba.red * 255), Int(rgba.green * 255), Int(rgba.blue * 255), Int(rgba.alpha * 255))
    }
}

public extension Color {

    var systemColor: UIColor {
        return UIColor(cgColor: cgColor)
    }

    var cgColor: CGColor {
        return CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(),
                       components: [CGFloat(rgba.red), CGFloat(rgba.green), CGFloat(rgba.blue), CGFloat(rgba.alpha)])!
    }
}

extension Color: Codable {

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let hex = try container.decode(String.self)

        self.rgba = Color.rgba(from: hex)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        try container.encode(toHex())
    }
}
