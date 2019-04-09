//
//  Reachability.swift
//  AdKit
//
//  Created by Werck, Ayrton on 2018-12-14.
//  Copyright © 2018 Nuglif. All rights reserved.
//

import Foundation
import SystemConfiguration

/// Detects an available network to perform requests over the internet
///
/// - Returns: true if network is available, false otherwise
public func isNetworkReachable() -> Bool {
    var zeroAddress = sockaddr()
    zeroAddress.sa_len = UInt8(MemoryLayout<sockaddr>.size)
    zeroAddress.sa_family = sa_family_t(AF_INET)

    guard let reachability = SCNetworkReachabilityCreateWithAddress(nil, &zeroAddress
        ) else { return false }

    var flags = SCNetworkReachabilityFlags()
    SCNetworkReachabilityGetFlags(reachability, &flags)
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
    let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)

    return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
}
