// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TappableButton",
    platforms: [.watchOS(.v9)],
    products: [
        .library(name: "TappableButton", targets: ["TappableButton"]),
    ],
    targets: [
        .target(name: "TappableButton"),
    ]
)
