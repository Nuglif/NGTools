//
//  UIDevice.swift
//  NGTools
//
//  Created by Goldschmidt, Jérémy on 2019-06-07.
//  Copyright © 2019 Nuglif. All rights reserved.
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
