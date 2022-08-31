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
        .package(url: "https://github.com/danielsaidi/Quick.git", branch: "main"),
        .package(url: "https://github.com/danielsaidi/Nimble.git", branch: "main")
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
