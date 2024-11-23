// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DoublePinch",
    products: [
        .library(name: "DoublePinch", targets: ["DoublePinch"]),
    ],
    targets: [
        .target(name: "DoublePinch"),
    ]
)
