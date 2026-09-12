// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TransientLabel",
    platforms: [
        .iOS(.v15),
        .visionOS(.v1),
        // macOS builds the module empty (see the guard atop each source):
        // the Mac uses system controls rather than this touch-first gauge.
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "TransientLabel",
            targets: ["TransientLabel"]),
    ],
    targets: [
        .target(name: "TransientLabel"),
        .testTarget(
            name: "TransientLabelTests",
            dependencies: ["TransientLabel"]
        ),
    ]
)
