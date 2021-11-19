//
//  NSDirectionalEdgeInsets+Extensions.swift
//  NGTools
//
//  Created by Yannick Jacques on 2019-06-26.
//  Copyright © 2019 Nuglif. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
public extension NSDirectionalEdgeInsets {

	init(_ value: CGFloat) {
		self.init(top: value, leading: value, bottom: -value, trailing: -value)
	}
}
