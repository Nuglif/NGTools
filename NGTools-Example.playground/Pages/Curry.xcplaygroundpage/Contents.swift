import Foundation
import NGTools

// MARK: - Curry

let addOperation: (Int, Int) -> Int = (+)

let add = curry(addOperation)

let resultAdd = add(2)(3)

print(resultAdd)


enum OperationError: Error {
    case divByZero
}

let divOperation: (Int, Int) throws -> Int = { numerator, denominator in
    guard denominator != 0 else {
        throw OperationError.divByZero
    }
    return numerator / denominator
}

let div = curry(divOperation)

let resultDiv = try? div(3)(0)

print (String(describing:resultDiv))

//: [Next](@next)
