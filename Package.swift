// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-osm",
    products: [
        .library(
            name: "SwiftOSM",
            targets: ["SwiftOSM"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/drmohundro/SWXMLHash.git", from: "5.0.1"),
        .package(url: "https://github.com/davecom/SwiftPriorityQueue.git", from: "1.3.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "SwiftOSM",
            dependencies: ["SWXMLHash", "SwiftPriorityQueue"]),
        .testTarget(
            name: "SwiftOSMTests",
            dependencies: ["SwiftOSM", "SWXMLHash"]),
    ]
)
