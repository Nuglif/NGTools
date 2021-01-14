//
//  UIDevice+Extensions.swift
//  NGTools
//
//  Created by Fournier, Olivier on 2021-01-14.
//  Copyright © 2021 Nuglif. All rights reserved.
//

import Foundation

public extension UIDevice {

    @objc var platformIdentifier: String {
        var size = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var machine = [CChar](repeating: 0,  count: size)
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        return String(cString: machine)
    }
}
