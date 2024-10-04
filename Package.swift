// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "MockingKit",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .macOS(.v10_15),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "MockingKit",
            targets: ["MockingKit"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "MockingKit"
        ),
        .testTarget(
            name: "MockingKitTests",
            dependencies: ["MockingKit"]
        )
    ]
)
