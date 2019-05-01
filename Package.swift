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
        .package(url: "https://github.com/vapor/crypto.git", from: "3.3.3"),
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0")
    ],
    targets: [
        .target(
            name: "OneRoster",
            dependencies: ["Crypto", "Vapor"]),
        .testTarget(
            name: "OneRosterTests",
            dependencies: ["OneRoster"]),
    ]
)
