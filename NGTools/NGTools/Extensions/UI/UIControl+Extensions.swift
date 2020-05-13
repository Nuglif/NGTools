//
//  UIControl+Extensions.swift
//  NGTools
//
//  Created by Bussiere, Mathieu on 2019-10-22.
//  Copyright © 2019 Nuglif. All rights reserved.
//

import UIKit

extension UIControl.State: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}
