// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TransientLabel",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "TransientLabel",
            targets: ["TransientLabel"]),
    ],
    targets: [
        .target(name: "TransientLabel"),
    ]
)
