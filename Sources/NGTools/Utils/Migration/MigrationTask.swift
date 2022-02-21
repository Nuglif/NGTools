//
//  MigrationTask.swift
//  NGTools
//
//  Created by Fournier, Olivier on 2022-02-17.
//  Copyright © 2022 Nuglif. All rights reserved.
//

import Foundation
import RxSwift

public protocol MigrationTask {

    var identifier: String { get }

    func execute() -> Completable
}
