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
        .package(name: "RxSwift", url: "https://github.com/ReactiveX/RxSwift", .upToNextMajor(from: "5.0.0"))
    ],
    targets: [
        .target(
            name: "NGTools",
            dependencies: [
                .product(name: "RxSwift", package: "RxSwift")
            ]),
        .testTarget(
            name: "NGToolsTests",
            dependencies: ["NGTools"])
    ]
)
