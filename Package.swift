// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "MockingKit",
    platforms: [
        .iOS(.v9),
        .tvOS(.v9),
        .watchOS(.v6),
        .macOS(.v10_10)
    ],
    products: [
        .library(
            name: "MockingKit",
            targets: ["MockingKit"]),
    ],
    dependencies: [
        .package(url: "git@github.com:Quick/Quick.git", .upToNextMajor(from: "3.0.0")),
        .package(url: "git@github.com:Quick/Nimble.git", .upToNextMajor(from: "9.0.0"))
    ],
    targets: [
        .target(
            name: "MockingKit",
            dependencies: []),
        .testTarget(
            name: "MockingKitTests",
            dependencies: ["MockingKit", "Quick", "Nimble"]),
    ]
)
