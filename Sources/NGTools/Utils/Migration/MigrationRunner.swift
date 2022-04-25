//
//  MigrationRunner.swift
//  NGTools
//
//  Created by Fournier, Olivier on 2022-02-17.
//  Copyright © 2022 Nuglif. All rights reserved.
//

import Foundation
import RxSwift

public class MigrationRunner {

    private let tasks: [MigrationTask]
    private let store: MigrationStore
    private let scheduler: SerialDispatchQueueScheduler

    public init(tasks: [MigrationTask],
         store: MigrationStore = DefaultMigrationStore(),
         scheduler: SerialDispatchQueueScheduler = .init(qos: .background)) {

        self.tasks = tasks
        self.store = store
        self.scheduler = scheduler
    }

    public func execute() -> Observable<MigrationTaskState> {
        let store = self.store
        let scheduler = self.scheduler
        let observables = tasks.map { task -> Observable<MigrationTaskState> in
            Observable.deferred {
                guard !store.isCompleted(task) else { return .just(.skipped) }

                return task
                    .execute()
                    .observe(on: scheduler)
                    .andThen(.just(.completed))
                    .catch { .just(.error($0)) } // Continue on errors
                    .do(onSuccess: { result in
                        if case .completed = result {
                            store.setCompleted(task)
                        }
                    })
                    .asObservable()
            }
        }
        return Observable
            .concat(observables)
            .subscribe(on: scheduler)
    }
}
