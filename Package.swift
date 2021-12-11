// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AdventOfCode2021",
    platforms: [.iOS("15.0")],
    products: [
        .library(
            name: "AdventOfCode2021",
            targets: ["AdventOfCode2021"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-overture",
            from: "0.5.0"
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-parsing",
            from: "0.3.1"
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-custom-dump",
            from: "0.3.0"
        )
    ],
    targets: [
        .target(
            name: "AdventOfCode2021",
            dependencies: [
                .product(name: "Overture", package: "swift-overture"),
                .product(name: "Parsing", package: "swift-parsing")
            ]
        ),
        .testTarget(
            name: "AdventOfCode2021Tests",
            dependencies: [
                "AdventOfCode2021",
                .product(name: "CustomDump", package: "swift-custom-dump")
            ]
        ),
    ]
)
