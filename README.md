# Swift SDK for Dagger

> [!WARNING]
> This SDK is experimental and it's not feature-complete. Please do not use it for anything mission-critical.

> [!NOTE]
> We plan to move this to the Dagger's organization once the first iteration is stable.

## SDK prototype

If you want to run the prototype in this repository, you can run:

```bash
dagger run swift run
```

The code that's being run lives in the `Sources/Pipeline/Pipeline.swift` file.


## Installation

A Dagger pipeline in Swift is represented by an executable Swift package. Start by creating a new Swift package:

```shell
mkdir Pipeline && cd Pipeline
swift package init --name Pipeline --type executable
```

Open the `Package.swift` and add the Dagger Swift SDK as a dependency in the `Package.swift`:


<!-- TODO: Swift Package Manager's dependency resolution can't resolve dependencies whose sources live in a sub-directory of the repo -->

```diff
// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Pipeline",
+    dependencies: [
+        .package(url: "https://github.com/tuist/swift-sdk-for-dagger", .upToNextMajor(from: "0.1.0"))
+    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "Pipeline",
+            dependencies: [.product(name: "Dagger", package: "swift-sdk-for-dagger")]
        ),
    ]
)
```