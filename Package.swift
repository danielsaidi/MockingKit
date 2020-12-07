// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Mockery",
    platforms: [
        .iOS(.v9),
        .tvOS(.v13),
        .watchOS(.v6),
        .macOS(.v10_10)
    ],
    products: [
        .library(
            name: "Mockery",
            targets: ["Mockery"]),
    ],
    dependencies: [
        .package(url: "git@github.com:Quick/Quick.git", .upToNextMajor(from: "3.0.0")),
        .package(url: "git@github.com:Quick/Nimble.git", .upToNextMajor(from: "9.0.0"))
    ],
    targets: [
        .target(
            name: "Mockery",
            dependencies: []),
        .testTarget(
            name: "MockeryTests",
            dependencies: ["Mockery", "Quick", "Nimble"]),
    ]
)
