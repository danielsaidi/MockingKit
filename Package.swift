// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Mockery",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(
            name: "Mockery",
            targets: ["Mockery"]),
    ],
    dependencies: [
        .package(url: "git@github.com:Quick/Quick.git", .upToNextMajor(from: "3.0.0")),
        .package(url: "git@github.com:Quick/Nimble.git", .upToNextMajor(from: "8.1.0"))
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
