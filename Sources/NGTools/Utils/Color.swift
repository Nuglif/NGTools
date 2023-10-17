//
//  Color.swift
//  NGTools
//
//  Created by Bussiere, Mathieu on 2018-02-16.
//  Copyright © 2018 Nuglif. All rights reserved.
//

import UIKit

public struct Color {

    public typealias RGBA = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)

    public var rgba: RGBA

    var red: CGFloat { rgba.red }
    var green: CGFloat { rgba.green }
    var blue: CGFloat { rgba.blue }
    var alpha: CGFloat { rgba.alpha }

    public init(_ uicolor: UIColor) {
        let ciColor = CIColor(color: uicolor)

        self.init(red: ciColor.red, green: ciColor.green, blue: ciColor.blue, alpha: ciColor.alpha)
    }

    public init(hex: String, alpha: CGFloat = 1) {
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

        self.rgba = RGBA(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: CGFloat(effectiveAlpha))
    }

    public init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) {
        func clamp(_ value: CGFloat) -> CGFloat {
            return min(1, max(0, value))
        }

        rgba = RGBA(red: clamp(red), green: clamp(green), blue: clamp(blue), alpha: clamp(alpha))
    }

    public func toHex() -> String {
        return String(format: "%02X%02X%02X%02X", Int(red * 255), Int(green * 255), Int(blue * 255), Int(alpha * 255))
    }
}

public extension Color {

    var systemColor: UIColor { UIColor(cgColor: cgColor) }
    var cgColor: CGColor { CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [red, green, blue, alpha])! }
}

extension Color: Codable {

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let hex = try container.decode(String.self)

        self.init(hex: hex)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        try container.encode(toHex())
    }
}
