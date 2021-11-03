// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "OneRoster",
    platforms: [
       .macOS(.v12)
    ],
    products: [
        .library(name: "OneRoster", targets: ["OneRoster"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.52.1"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
    ],
    targets: [
        .target(name: "OneRoster", dependencies: [
            .product(name: "Vapor", package: "vapor"),
            .product(name: "Logging", package: "swift-log"),
        ]),
        .testTarget(name: "OneRosterTests", dependencies: [
            .target(name: "OneRoster"),
            .product(name: "XCTVapor", package: "vapor"),
        ])
    ]
)
