//: [Previous](@previous)

import Foundation
import NGTools

let stringToHash = "My favorite ice cream flavor is praline."
let md5 = stringToHash.md5

if let md5 = md5,
    md5 == "fafb45dd33739bc76f988a0ce0765269" {
    print("md5 of 'My favorite ice cream flavor is praline.' is 'fafb45dd33739bc76f988a0ce0765269': OK !")
} else {
    print("md5 of 'My favorite ice cream flavor is praline.' should be 'fafb45dd33739bc76f988a0ce0765269' but was '\(md5)': KO !")
}

//: [Next](@next)
