// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Dagger",
    platforms: [.macOS("13.0")],
    products: [
        .library(name: "Dagger", targets: ["Dagger"]),
        .executable(name: "pipeline", targets: ["Pipeline"])
    ],
    targets: [
        .executableTarget(name: "Pipeline", dependencies: ["Dagger"]),
        .target(
            name: "Dagger",
            dependencies: [
            ],
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
