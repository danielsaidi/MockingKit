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
//        .package(url: "git@github.com:Quick/Quick.git", from: "2.1.0"),
//        .package(url: "git@github.com:Quick/Nimble.git", from: "8.0.2"),
    ],
    targets: [
        .target(
            name: "Mockery",
            dependencies: []),
        .testTarget(
            name: "MockeryTests",
            dependencies: ["Mockery"/*, "Quick", "Nimble"*/]),
    ]
)
