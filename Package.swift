// swift-tools-version:5.9

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
            name: "MockingKit",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "MockingKitTests",
            dependencies: ["MockingKit"]
        )
    ]
)
