// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftOSM",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "SwiftOSM",
            targets: ["SwiftOSM"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/drmohundro/SWXMLHash.git", from: "4.2.5"),
        .package(url: "https://github.com/davecom/SwiftPriorityQueue.git", from: "1.2.1"),
        .package(url: "https://github.com/vapor/engine.git", from: "2.2.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "SwiftOSM",
            dependencies: ["SWXMLHash", "SwiftPriorityQueue", "HTTP"]),
        .testTarget(
            name: "SwiftOSMTests",
            dependencies: ["SwiftOSM"]),
    ]
)
