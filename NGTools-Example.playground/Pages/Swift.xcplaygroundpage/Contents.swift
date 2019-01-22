//: [Previous](@previous)

import Foundation
import NGTools

let greenVegetables = ["🍏": 1, "🥒": 7, "🥦": 5, "🥑": 6]
let redVegetables: [String: Any] = ["🌶": 1, "🍓": 4, "🍎": "notANumber"]

let castInt: (Any) throws -> Int? = { value in
    return value as? Int
}

let mergedVegetables = try? greenVegetables
    .merging(redVegetables.compactMapValues(castInt), uniquingKeysWith: ( + ))

print(mergedVegetables)

//: [Next](@next)
