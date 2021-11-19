// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NGTools",
    platforms: [.iOS(.v10)],
    products: [
        .library(
            name: "NGTools",
            targets: ["NGTools"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "NGTools",
            dependencies: []),
        .testTarget(
            name: "NGToolsTests",
            dependencies: ["NGTools"])
    ]
)
