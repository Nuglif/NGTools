//
//  ProcessInfo+Extensions.swift
//  NGTools
//
//  Created by Olivier Fournier on 2023-06-13.
//  Copyright © 2023 Nuglif. All rights reserved.
//

import Foundation

public extension ProcessInfo {

    @objc var isAppRunningOnMac: Bool {
        guard #available(iOS 14.0, *) else { return false }

        return isiOSAppOnMac
    }
}
