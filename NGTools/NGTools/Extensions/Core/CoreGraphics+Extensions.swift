//
//  CoreGraphics+Extensions.swift
//  NGTools
//
//  Created by Fournier, Olivier on 2018-02-28.
//  Copyright © 2018 Nuglif. All rights reserved.
//

import CoreGraphics

public extension CGFloat {

    init?(_ value: Double?) {
        guard let value = value else { return nil }

        self.init(value)
    }

    init?(_ value: Float?) {
        guard let value = value else { return nil }

        self.init(value)
    }

    func ceil() -> CGFloat {
        return Darwin.ceil(self)
    }

    func floor() -> CGFloat {
        return Darwin.floor(self)
    }

    func round() -> CGFloat {
        return Darwin.round(self)
    }

    func percentage() -> CGFloat {
        return Darwin.round(self * 100) / 100
    }

    static func interpolate(startValue: CGFloat, endValue: CGFloat, progress: CGFloat) -> CGFloat {
        return startValue + ((endValue - startValue) * progress)
    }

    static func interpolationProgress(endValue: CGFloat, value: CGFloat) -> CGFloat {
        let diff = value - endValue

        guard diff != .infinity else { return 1}
        var progress: CGFloat = 1

        if diff >= 0 {
            progress = 1 - (diff / endValue)
        }

        return progress
    }
}

public extension CGPoint {

    var isInfinite: Bool {
        return x.isInfinite || y.isInfinite
    }

    static func ceil(x: CGFloat, y: CGFloat) -> CGPoint {
        return .init(x: x.ceil(), y: y.ceil())
    }

    static func floor(x: CGFloat, y: CGFloat) -> CGPoint {
        return .init(x: x.floor(), y: y.floor())
    }

    static func round(x: CGFloat, y: CGFloat) -> CGPoint {
        return .init(x: x.round(), y: y.round())
    }

    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return .init(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return .init(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    static func += (lhs: inout CGPoint, rhs: CGPoint) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }

    func offsetting(x offsetX: CGFloat = 0, y offsetY: CGFloat = 0) -> CGPoint {
        return .init(x: x + offsetX, y: y + offsetY)
    }
}

public extension CGSize {

    static func ceil(width: CGFloat, height: CGFloat) -> CGSize {
        return .init(width: width.ceil(), height: height.ceil())
    }

    static func floor(width: CGFloat, height: CGFloat) -> CGSize {
        return .init(width: width.floor(), height: height.floor())
    }

    static func round(width: CGFloat, height: CGFloat) -> CGSize {
        return .init(width: width.round(), height: height.round())
    }

    static func + (lhs: CGSize, rhs: CGSize) -> CGSize {
        return .init(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }

    static func - (lhs: CGSize, rhs: CGSize) -> CGSize {
        return .init(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }

    static func * (lhs: CGSize, rhs: CGFloat) -> CGSize {
        return .init(width: lhs.width * rhs, height: lhs.height * rhs)
    }

    func diff(to size: CGSize) -> CGPoint {
        return .init(x: size.width - width, y: size.height - height)
    }
}

public extension CGRect {

    var topRight: CGPoint { return .init(x: maxX, y: minY) }
    var topLeft: CGPoint { return .init(x: minX, y: minY) }

    var midLeft: CGPoint { return .init(x: minX, y: midY) }
    var midRight: CGPoint { return .init(x: maxX, y: midY) }

    var bottomRight: CGPoint { return .init(x: maxX, y: maxY) }
    var bottomLeft: CGPoint { return .init(x: minX, y: maxY) }

    static func ceil(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> CGRect {
        return .init(x: x.ceil(), y: y.ceil(), width: width.ceil(), height: height.ceil())
    }

    static func floor(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> CGRect {
        return .init(x: x.floor(), y: y.floor(), width: width.floor(), height: height.floor())
    }

    static func round(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> CGRect {
        return .init(x: x.round(), y: y.round(), width: width.round(), height: height.round())
    }
}
