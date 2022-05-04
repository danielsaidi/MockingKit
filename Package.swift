// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "MockingKit",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "MockingKit",
            targets: ["MockingKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Quick.git", .upToNextMajor(from: "3.0.0")),
        .package(url: "https://github.com/Quick/Nimble.git", .upToNextMajor(from: "9.0.0")),
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
