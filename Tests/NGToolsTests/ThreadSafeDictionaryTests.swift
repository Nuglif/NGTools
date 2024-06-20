//
//  ThreadSafeDictionary.swift
//  
//
//  Created by Jeanne Creantor, N'rick (Ordinateur) on 2024-06-20.
//

import XCTest
import NGTools

final class ThreadSafeDictionaryTests: XCTestCase {

    func testConcurrencyInsertionAndRemove() {
        let set = ThreadSafeDictionary<String, UUID>()
        let expectation = XCTestExpectation(description: "Testing")

        let queueA = DispatchQueue(label: "TestQueueA", qos: .background)
        let queueB = DispatchQueue(label: "TestQueueB", qos: .background)
        let iterations = 1000
        var requests = [UUID]()
        for _ in 0..<iterations { requests.append(UUID()) }
        var completed = 0

        requests.forEach { request in
            queueA.async {
                set.updateValue(request, for: request.uuidString)
            }

            queueB.async {
                set.removeItem(for: request.uuidString)
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
        var array = [UUID]()
        for i in 0..<iterations { array.append(UUID()) }
        let requests = array.reduce(into: [:]) { partialResult, id in
            partialResult[id.uuidString] = id
        }
        let set = ThreadSafeDictionary(dictionary: requests)
        var completed = 0

        requests.forEach { request in
            queueA.async {
                _ = set.contains(where: { key, item in
                    request.key == key && request.value == item
                })
            }

            queueB.async {
                set.removeItem(for: request.key)
                completed += 1
                if completed == iterations - 1 {
                    expectation.fulfill()
                }
            }
        }

        wait(for: [expectation], timeout: 3)
    }
}
