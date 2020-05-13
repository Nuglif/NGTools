//
//  UIEdgeInsets+Extensions.swift
//  NGTools
//
//  Created by Bussiere, Mathieu on 2018-02-26.
//  Copyright © 2018 Nuglif. All rights reserved.
//

import UIKit

extension UIEdgeInsets {

    public var horizontalInsets: CGFloat {
        return left + right
    }

    public var verticalInsets: CGFloat {
        return top + bottom
    }

    public static func += (lhs: inout UIEdgeInsets, rhs: UIEdgeInsets?) {
        guard let insets = rhs else { return }

        lhs.top += insets.top
        lhs.right += insets.right
        lhs.bottom += insets.bottom
        lhs.left += insets.left
    }

    public static func + (lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> UIEdgeInsets {
        var insets = lhs
        insets += rhs

        return insets
    }

    public init(_ value: CGFloat) {
        self.init(top: value, left: value, bottom: value, right: value)
    }

    public init(horizontal value: CGFloat) {
        self.init(top: 0, left: value, bottom: 0, right: value)
    }

    public init(vertical value: CGFloat) {
        self.init(top: value, left: 0, bottom: value, right: 0)
    }

    public init(top value: CGFloat) {
        self.init(top: value, left: 0, bottom: 0, right: 0)
    }

    public init(left value: CGFloat) {
        self.init(top: 0, left: value, bottom: 0, right: 0)
    }

    public init(bottom value: CGFloat) {
        self.init(top: 0, left: 0, bottom: value, right: 0)
    }

    public init(right value: CGFloat) {
        self.init(top: 0, left: 0, bottom: 0, right: value)
    }
}

// MARK: - UIEdgeInsets
extension UIEdgeInsets {

    public func inverted() -> UIEdgeInsets {
        return UIEdgeInsets(top: top, left: right, bottom: bottom, right: left)
    }
}
