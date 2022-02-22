//
//  MigrationTests.swift
//  
//
//  Created by Fournier, Olivier on 2022-02-17.
//

import Foundation
import XCTest
import RxSwift

@testable import NGTools

final class MigrationTests: XCTestCase {

    enum MigrationTestError: Error {
        case failed
    }

    private let store = MockMigrationStore()
    private let successTask = MockMigrationTask(identifier: "success_id", completable: .create { observer in
        observer(.completed)

        return Disposables.create()
    })
    private let successAsyncTask = MockMigrationTask(identifier: "success_async_id", completable: .create { observer in
        DispatchQueue.global(qos: .default).async {
            observer(.completed)
        }

        return Disposables.create()
    })
    private let errorTask = MockMigrationTask(identifier: "error_id", completable: .create { observer in
        observer(.error(MigrationTestError.failed))

        return Disposables.create()
    })
    let disposeBag = DisposeBag()

    func testMigrationSuccess() {
        let runner = MigrationRunner(tasks: [successTask], store: store)
        let expectation = XCTestExpectation(description: "should complete")

        runner.execute()
            .do(onNext: { state in
                XCTAssert(state == .completed)
            }, onCompleted: {
                expectation.fulfill()
            })
            .subscribe()
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 5)

        XCTAssert(store.isCompleted(successTask))
    }

    func testMigrationError() {
        let runner = MigrationRunner(tasks: [errorTask], store: store)
        let expectation = XCTestExpectation(description: "should complete")

        runner.execute()
            .do(onNext: { state in
                XCTAssert(state == .error(MigrationTestError.failed))
            }, onCompleted: {
                expectation.fulfill()
            })
            .subscribe()
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 5)

        XCTAssert(!store.isCompleted(errorTask))
    }

    func testMigrationMultipleTasks() {
        let runner = MigrationRunner(tasks: [successTask, errorTask, successAsyncTask, successTask], store: store)
        let expectation = XCTestExpectation(description: "should complete")
        let expectedStates: [MigrationTaskState] = [.completed,
                                                      .error(MigrationTestError.failed),
                                                      .completed,
                                                      .skipped]
        var states = [MigrationTaskState]()

        runner.execute()
            .do(onNext: { state in
                states.append(state)
            }, onCompleted: {
                expectation.fulfill()
            })
            .subscribe()
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 5)

        XCTAssert(states == expectedStates)

        XCTAssert(store.isCompleted(successTask))
        XCTAssert(!store.isCompleted(errorTask))
    }
}

private class MockMigrationTask: MigrationTask {

    let identifier: String
    let completable: Completable

    init(identifier: String, completable: Completable) {
        self.identifier = identifier
        self.completable = completable
    }

    func execute() -> Completable {
        return completable
    }
}

private class MockMigrationStore: MigrationStore {

    var values = [String: Bool]()

    func setCompleted(_ action: MigrationTask) {
        self.values[action.identifier] = true
    }

    func isCompleted(_ action: MigrationTask) -> Bool {
        return values[action.identifier] ?? false
    }
}
