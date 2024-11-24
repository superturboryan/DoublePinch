// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DoublePinch",
    platforms: [.watchOS(.v9)],
    products: [
        .library(name: "DoublePinch", targets: ["DoublePinch"]),
    ],
    dependencies: [
        .package(path: "TappableButton"),
    ],
    targets: [
        .target(name: "DoublePinch", dependencies: ["TappableButton"]),
        .testTarget(name: "DoublePinchTests", dependencies: ["DoublePinch"]),
    ]
)
