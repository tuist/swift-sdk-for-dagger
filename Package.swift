// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Dagger",
    platforms: [.macOS("13.0")],
    products: [
        .library(name: "Dagger", targets: ["Dagger"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Dagger",
            dependencies: [],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency"),
            ]
        ),
        .testTarget(
            name: "DaggerTests",
            dependencies: [
                "Dagger",
            ]
        ),
    ]
)
