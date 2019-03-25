// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "OneRoster",
    products: [
        .library(
            name: "OneRoster",
            targets: ["OneRoster"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "OneRoster",
            dependencies: []),
        .testTarget(
            name: "OneRosterTests",
            dependencies: ["OneRoster"]),
    ]
)
