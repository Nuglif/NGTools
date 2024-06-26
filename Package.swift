// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NGTools",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "NGTools",
            targets: ["NGTools"])
    ],
    dependencies: [
        .package(name: "RxSwift", url: "https://github.com/ReactiveX/RxSwift", .upToNextMajor(from: "6.0.0")),
        .package(name: "CryptoSwift", url: "https://github.com/krzyzanowskim/CryptoSwift.git", .upToNextMajor(from: "1.6.0"))
    ],
    targets: [
        .target(
            name: "NGTools",
            dependencies: [
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "CryptoSwift", package: "CryptoSwift")
            ],
            exclude: ["Info.plist"]),
        .testTarget(
            name: "NGToolsTests",
            dependencies: ["NGTools"],
            exclude: ["Info.plist"])
    ]
)
