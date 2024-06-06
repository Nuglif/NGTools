//
//  ThreadSafeSetTests.swift
//  
//
//  Created by Jeanne Creantor, N'rick (Ordinateur) on 2024-06-04.
//

import XCTest

import NGTools

final class ThreadSafeSetTests: XCTestCase {

    func testConcurrencyInsertionAndRemove() {
        let set = ThreadSafeSet<UUID>()
        let expectation = XCTestExpectation(description: "Testing")

        let queueA = DispatchQueue(label: "TestQueueA", qos: .background)
        let queueB = DispatchQueue(label: "TestQueueB", qos: .background)
        let iterations = 1000
        let requests = Array(repeating: UUID(), count: iterations)
        var completed = 0

        requests.forEach { request in
            queueA.async { set.insert(request) }

            queueB.async {
                set.remove(request)
                completed += 1
                if completed == iterations - 1 {
                    expectation.fulfill()
                }
            }
        }

        wait(for: [expectation], timeout: 3)
    }

    func testConcurrencyContainsAndRemove() {
        let expectation = XCTestExpectation(description: "Testing")

        let queueA = DispatchQueue(label: "TestQueueA", qos: .background)
        let queueB = DispatchQueue(label: "TestQueueB", qos: .background)
        let iterations = 1000
        let requests = Array(repeating: UUID(), count: iterations)
        let set = ThreadSafeSet<UUID>(set: Set(requests))
        var completed = 0

        requests.forEach { request in
            queueA.async {
                _ = set.contains(request)
            }

            queueB.async {
                set.remove(request)
                completed += 1
                if completed == iterations - 1 {
                    expectation.fulfill()
                }
            }
        }

        wait(for: [expectation], timeout: 3)
    }
}
